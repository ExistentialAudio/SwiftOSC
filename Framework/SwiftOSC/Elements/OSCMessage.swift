import Foundation





/// Most common OSCElement. Most of the OSC data that is sent/received is this type.
public class OSCMessage: OSCElement, CustomStringConvertible {
    
    //MARK: Properties
    
    /// The address for the message. Eg: "/some/source"
    public var address: OSCAddressPattern
    /// An array of the arguments for the message. See OSCType.
    public var arguments = [OSCType?]()
    /// The whole OSC message in Data form. This has the address and the arguments needed to send/receive.
    public var data: Data {
        get {
            var data = Data()
            
            //add address
            data.append(self.address.string.toDataBase32())
            
            //create type list
            var types = ","
            for argument in self.arguments {
                if let argument = argument {
                    types += argument.tag
                } else {
                    //add null tag if nil argument
                    types += "N"
                }
            }
            data.append(types.toDataBase32())
            
            //get arguments data
            for argument in arguments {
                if let argument = argument {
                    data.append(argument.data)
                }
            }
            
            return data
        }
    }
    
    /// A String version of the whole OSC message. This is helpful for printing and debuging.
    public var description: String {
        var description = "OSCMessage [Address<\(self.address.string)>"
        
        for argument in self.arguments {
            
            if let int = argument as? Int {
                description += " Int<\(int)>"
            }
            if let float = argument as? Float {
                description += " Float<\(float)>"
            }
            if let float = argument as? Double {
                description += " Float<\(float)>"
            }
            if let string = argument as? String {
                description += " String<\(string)>"
            }
            if let blob = argument as? Blob {
                description += " Blob<\(blob)>"
            }
            if let bool = argument as? Bool {
                description += " <\(bool)>"
            }
            if argument == nil {
                description += " <null>"
            }
            if argument is Impulse {
                description += " <impulse>"
            }
            if let timetag = argument as? Timetag {
                description += " Timetag<\(timetag)>"
            }
        }
        
        description += "]"
        return description
    }
    
    //MARK: Initializers
    
    /// Creates an OSCMessage with an address and no arguments.
    public init(_ address: OSCAddressPattern){
        self.address = address
    }
    
    /// Creates an OSCMessage with an address and a series of OSCTypes.
    public init(_ address: OSCAddressPattern,_ arguments:OSCType?...){
        self.address = address
        self.arguments = arguments
    }
    
    /// Creates an OSCMessage with an address and an array of OSCTypes.
    public init(_ address: OSCAddressPattern,_ arguments:[OSCType?]){
        self.address = address
        self.arguments = arguments
    }
    
    //MARK: Methods
    
    public func add(){
        self.arguments.append(nil)
    }
    
    /// Appends one or a series of OSCTypes to the current array of arguments.
    public func add(_ arguments: OSCType?...){
        self.arguments += arguments
    }
    
    /// Appends an array of OSCTypes to the current array of arguments
    public func add(_ arguments: [OSCType?]){
        self.arguments += arguments
    }
}
