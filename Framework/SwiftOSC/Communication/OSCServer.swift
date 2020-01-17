import Foundation

public protocol OSCServerDelegate: class {
    func didReceive(_ data: Data)
    func didReceive(_ bundle: OSCBundle)
    func didReceive(_ message: OSCMessage)
}
extension OSCServerDelegate {
    public func didReceive(_ data: Data){}
    public func didReceive(_ bundle: OSCBundle){}
    public func didReceive(_ message: OSCMessage){}
}

open class OSCServer {
    open var address: String {
        didSet {
            _ = server.close()
            server = UDPServer(addr: self.address, port:self.port)
        }
    }
    open var port: Int {
        didSet {
            _ = server.close()
            server = UDPServer(addr: self.address, port:self.port)
        }
    }
    open var delegate: OSCServerDelegate?
    open var running = false
    var server: UDPServer
    
    public init(address: String, port: Int){
        self.address = address
        self.port = port
        self.server = UDPServer(addr: self.address, port:self.port)
        run()
    }
    
    open func start(){
        running = true
    }
    open func stop(){
        running = false
    }
    func run() {
        DispatchQueue.global().async{
            while true {
                let (data,_,_) = self.server.recv(9216)
                if let data = data {
                    if self.running {
                        let data = Data(data)
                        self.decodePacket(data)
                    }
                }
            }
        }
    }
    
    func decodePacket(_ data: Data){
        
        autoreleasepool{
        
            DispatchQueue.main.async {
                self.delegate?.didReceive(data)
            }
            
            if data[0] == 0x2f { // check if first character is "/"
                if let message = decodeMessage(data){
                    self.sendToDelegate(message)
                }

            } else if data.count > 8 {//make sure we have at least 8 bytes before checking if a bundle.
                if "#bundle\0".toData() == data.subdata(in: Range(0...7)){//matches string #bundle
                    if let bundle = decodeBundle(data){
                        self.sendToDelegate(bundle)
                    }
                }
            } else {
                NSLog("Invalid OSCPacket: data must begin with #bundle\\0 or /")
            }
        }
        
}
    
    func decodeBundle(_ data: Data)->OSCBundle? {
        
        //extract timetag
        var bundle: OSCBundle?
        
        autoreleasepool{
            
            
            bundle = OSCBundle(Timetag(data.subdata(in: 8..<16)))
            var bundleData = data.subdata(in: 16..<data.count)
            
            while bundleData.count > 0 {
                let length = Int(bundleData.subdata(in: Range(0...3)).toInt32())
                let nextData = bundleData.subdata(in: 4..<length+4)
                bundleData = bundleData.subdata(in:length+4..<bundleData.count)
                if "#bundle\0".toData() == nextData.subdata(in: Range(0...7)){//matches string #bundle
                    if let newbundle = self.decodeBundle(nextData){
                        bundle?.add(newbundle)
                    } else {
                        bundle = nil
                    }
                } else {
                    
                    if let message = self.decodeMessage(nextData) {
                        bundle?.add(message)
                    } else {
                        bundle = nil
                    }
                }
            }
        }
        return bundle
    }
    
    func decodeMessage(_ data: Data)->OSCMessage?{
        var message: OSCMessage?
        
        autoreleasepool{
            
            var messageData = data
            message = OSCMessage(OSCAddressPattern("/"))
            
            //extract address and check if valid
            let addressEnd = messageData.firstIndex(of: 0x00)!
            if let addressString = messageData.subdata(in: 0..<addressEnd).toString() {
                var address = OSCAddressPattern()
                if address.valid(addressString) {
                    address.string = addressString
                    message = OSCMessage(address)

                    //extract types
                    messageData = messageData.subdata(in: (addressEnd/4+1)*4..<messageData.count)
                    if let typeEnd = messageData.firstIndex(of: 0x00){
                        if let type = messageData.subdata(in: 1..<typeEnd).toString() {

                            messageData = messageData.subdata(in: (typeEnd/4+1)*4..<messageData.count)

                            for char in type {
                                switch char {
                                case "i"://int
                                    message?.add(Int(messageData.subdata(in: Range(0...3))))
                                    messageData = messageData.subdata(in: 4..<messageData.count)
                                case "f"://float
                                    message?.add(Float(messageData.subdata(in: Range(0...3))))
                                    messageData = messageData.subdata(in: 4..<messageData.count)
                                case "s"://string
                                    let stringEnd = messageData.firstIndex(of: 0x00)!
                                    message?.add(String(messageData.subdata(in: 0..<stringEnd)))
                                    messageData = messageData.subdata(in: (stringEnd/4+1)*4..<messageData.count)
                                case "b": //blob
                                    var length = Int(messageData.subdata(in: Range(0...3)).toInt32())
                                    messageData = messageData.subdata(in: 4..<messageData.count)
                                    message?.add(Blob(messageData.subdata(in: 0..<length)))
                                    while length%4 != 0 {//remove null ending
                                        length += 1
                                    }
                                    messageData = messageData.subdata(in: length..<messageData.count)

                                case "T"://true
                                    message?.add(true)
                                case "F"://false
                                    message?.add(false)
                                case "N"://null
                                    message?.add()
                                case "I"://impulse
                                    message?.add(Impulse())
                                case "t"://timetag
                                    message?.add(Timetag(messageData.subdata(in: Range(0...7))))
                                    messageData = messageData.subdata(in: 8..<messageData.count)
                                default:
                                    print("unknown osc type")
                                    message = nil
                                }
                            }
                        } else {message = nil}
                    }
                } else {message = nil}
            } else {message = nil}
        }
        return message
    }
    func sendToDelegate(_ element: OSCElement){
        DispatchQueue.main.async {
            if let message = element as? OSCMessage {
                self.delegate?.didReceive(message)
            }
            if let bundle = element as? OSCBundle {
                
                // send to delegate at the correct time
                if bundle.timetag.secondsSinceNow < 0 {
                    self.delegate?.didReceive(bundle)
                    for element in bundle.elements {
                        self.sendToDelegate(element)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + bundle.timetag.secondsSinceNow, execute: {
                        self.delegate?.didReceive(bundle)
                        for element in bundle.elements {
                            self.sendToDelegate(element)
                        }
                    })
                }
            }
        }
    }
    
    deinit {
        _ = server.close()
    }
}
