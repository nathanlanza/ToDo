import Foundation

struct ToDoItem: Equatable {
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    public static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.location == rhs.location &&
            lhs.timestamp == rhs.timestamp &&
            lhs.itemDescription == rhs.itemDescription &&
            lhs.title == rhs.title
    }
    
    fileprivate let titleKey = "titleKey"
    fileprivate let itemDescriptionKey = "itemDescriptionKey"
    fileprivate let timestampKey = "timestampKey"
    fileprivate let locationKey = "locationKey"
    
    var plistDict: [String:Any] {
        var dict: [String:Any] = [:]
        
        dict[titleKey] = title
        dict[itemDescriptionKey] = itemDescription
        dict[timestampKey] = timestamp
        dict[locationKey] = location?.plistDict
        
        return dict
    }
    
    init?(dict: [String:Any]) {
        guard let title = dict[titleKey] as? String else { return nil }
        self.title = title
        
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timestamp = dict[timestampKey] as? Double
        if let locationDict = dict[locationKey] as? [String:Any] {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }
}
