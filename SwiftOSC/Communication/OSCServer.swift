import Foundation

public class OSCServer {
    public var address: String {
        didSet {
            _ = server.close()
            server = UDPServer(addr: self.address, port:self.port)
        }
    }
    public var port: Int {
        didSet {
            _ = server.close()
            server = UDPServer(addr: self.address, port:self.port)
        }
    }

    public var running = false
    var server: UDPServer
    
    static public var didReceiveMessage = "didReceiveMessage" as NSNotification.Name
    static public var didReceiveBundle = "didReceiveBundle" as NSNotification.Name
    
    public init(address: String, port: Int){
        self.address = address
        self.port = port
        self.server = UDPServer(addr: self.address, port:self.port)
        run()
    }
    
    public func start(){
        running = true
    }
    public func stop(){
        running = false
    }
    func run() {
        DispatchQueue.global(attributes: .qosDefault).async{
            while true {
                let (data,_,_) = self.server.recv(9216)
                if let d = data {
                    if self.running {
                        self.decodePacket(Data(bytes: d))   
                    }
                }
            }
        }
    }
    
    func decodePacket(_ data: Data){
        
            if "#bundle\0".toData() == data.subdata(in: Range(0...7)){//matches string #bundle
                if let bundle = decodeBundle(data){
                    self.postNotification(bundle)
                } else {
                    print("invalid packet")
                }
            } else {
                if let message = decodeMessage(data){
                    self.postNotification(message)
                } else {
                    print("invalid packet")
                }
            }
    }
    
    func decodeBundle(_ data: Data)->OSCBundle? {
        
        //extract timetag
        let bundle = OSCBundle(Timetag(data.subdata(in: Range(8..<16))))
    
        var bundleData = data.subdata(in: Range(16..<data.count))
        
        while bundleData.count > 0 {
            let length = Int(bundleData.subdata(in: Range(0...3)).toInt32())
            let nextData = bundleData.subdata(in: Range(4..<length+4))
            bundleData = bundleData.subdata(in: Range(length+4..<bundleData.count))
            if "#bundle\0".toData() == nextData.subdata(in: Range(0...7)){//matches string #bundle
                if let newbundle = self.decodeBundle(nextData){
                    bundle.add(newbundle)
                } else {
                    return nil
                }
            } else {
                
                if let message = self.decodeMessage(nextData) {
                    bundle.add(message)
                } else {
                    return nil
                }
            }
        }
        return bundle
    }
    
    func decodeMessage(_ data: Data)->OSCMessage?{
        var messageData = data
        var message: OSCMessage
        
        //extract address and check if valid
        let addressEnd = messageData.index(of: 0x00)!
        let addressString = messageData.subdata(in: Range(0..<addressEnd)).toString()
        var address = OSCAddressPattern()
        if address.valid(addressString) {
            address.string = addressString
            message = OSCMessage(address)
            
            //extract types
            messageData = messageData.subdata(in: Range((addressEnd/4+1)*4..<messageData.count))
            let typeEnd = messageData.index(of: 0x00)!
            let type = messageData.subdata(in: Range(1..<typeEnd)).toString()
            
            messageData = messageData.subdata(in: Range((typeEnd/4+1)*4..<messageData.count))
            
            for char in type.characters {
                switch char {
                case "i"://int
                    message.add(Int(messageData.subdata(in: Range(0...3))))
                    messageData = messageData.subdata(in: Range(4..<messageData.count))
                case "f"://float
                    message.add(Float(messageData.subdata(in: Range(0...3))))
                    messageData = messageData.subdata(in: Range(4..<messageData.count))
                case "s"://string
                    let stringEnd = messageData.index(of: 0x00)!
                    message.add(String(messageData.subdata(in: Range(0...stringEnd))))
                    messageData = messageData.subdata(in: Range((stringEnd/4+1)*4..<messageData.count))
                case "b": //blob
                    var length = Int(messageData.subdata(in: Range(0...3)).toInt32())
                    messageData = messageData.subdata(in: Range(4..<messageData.count))
                    message.add(Blob(messageData.subdata(in: Range(0..<length))))
                    while length%4 != 0 {//remove null ending
                        length += 1
                    }
                    messageData = messageData.subdata(in: Range(length..<messageData.count))
                    
                case "T"://true
                    message.add(true)
                case "F"://false
                    message.add(false)
                case "N"://null
                    message.add()
                case "I"://impulse
                    message.add(Impulse())
                case "t"://timetag
                    message.add(Timetag(messageData.subdata(in: Range(0...7))))
                    messageData = messageData.subdata(in: Range(8..<messageData.count))
                default:
                    print("unknown osc type")
                    return nil
                }
            }
        } else {
            return nil
        }
        return message
    }
    func postNotification(_ element: OSCElement){
        DispatchQueue.main.async {
            if let message = element as? OSCMessage {
                NotificationCenter.default.post(name: OSCServer.didReceiveMessage, object: message)
            }
            if let bundle = element as? OSCBundle {
                NotificationCenter.default.post(name: OSCServer.didReceiveBundle, object: bundle)
                for element in bundle.elements {
                    self.postNotification(element)
                }
            }
        }
    }
}
