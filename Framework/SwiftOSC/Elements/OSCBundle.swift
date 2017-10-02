import Foundation

public class OSCBundle: OSCElement, CustomStringConvertible {
    //MARK: Properties
    public var timetag: Timetag
    public var elements:[OSCElement] = []
    public var data: Data {
        get {
            var data = Data()
            //add "#bundle" tag
            data.append("#bundle".toDataBase32())
            
            //add timetag
            data.append(timetag.data)
            
            //add elements data
            for element in elements {
                let elementData = element.data
                data.append(Int32(elementData.count).toData())
                data.append(element.data)
            }
            return data
        }
    }
    public var description: String {
        get {
            return "OSCBundle [Timetag<\(self.timetag)> Elements<\(elements.count)>]"
        }
    }
    
    //MARK: Initializers
    public init(_ timetag: Timetag){
        self.timetag = timetag
    }
    
    public init (_ timetag: Timetag, _ elements: OSCElement...){
        self.timetag = timetag
        self.elements = elements
    }
    public init (_ elements: OSCElement...){
        self.timetag = 1
        self.elements = elements
    }
    
    //MARK: Methods
    public func add(_ elements: OSCElement...){
        self.elements += elements
    }
}
