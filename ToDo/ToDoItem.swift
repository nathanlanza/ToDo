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
}
