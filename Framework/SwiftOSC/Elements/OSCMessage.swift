import Foundation

public class OSCMessage: OSCElement, CustomStringConvertible {
    //MARK: Properties
    public var address: OSCAddressPattern
    public var arguments:[OSCType?] = []
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
                description += " Blob\(blob)"
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
    public init(_ address: OSCAddressPattern){
        self.address = address
    }
    
    public init(_ address: OSCAddressPattern,_ arguments:OSCType?...){
        self.address = address
        self.arguments = arguments
    }
    
    public init(_ address: OSCAddressPattern,_ arguments:[OSCType?]){
        self.address = address
        self.arguments = arguments
    }
    
    //MARK: Methods
    public func add(){
        self.arguments.append(nil)
    }
    
    public func add(_ arguments: OSCType?...){
        self.arguments += arguments
    }
    
    public func add(_ arguments: [OSCType?]){
        self.arguments += arguments
    }
}
