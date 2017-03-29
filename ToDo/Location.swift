import Foundation
import CoreLocation

struct Location: Equatable {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
    init?(dict: [String:Any]) {
        guard let name = dict[nameKey] as? String else { return nil }
        
        let coordinate: CLLocationCoordinate2D?
        if let latitude = dict[latitudeKey] as? Double, let longitude = dict[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
        
        self.name = name
        self.coordinate = coordinate
    }
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.coordinate?.latitude == rhs.coordinate?.latitude &&
               lhs.coordinate?.longitude == rhs.coordinate?.longitude &&
               lhs.name == rhs.name
    }
    
    var plistDict: [String:Any] {
        var dict: [String:Any] = [:]
        
        dict[nameKey] = name
        dict[latitudeKey] = coordinate?.latitude
        dict[longitudeKey] = coordinate?.longitude
        
        return dict
    }
    
    fileprivate let nameKey = "nameKey"
    fileprivate let latitudeKey = "latitudeKey"
    fileprivate let longitudeKey = "longitudeKey"
}

