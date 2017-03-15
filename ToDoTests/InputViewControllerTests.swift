import XCTest
@testable import ToDo
import CoreLocation

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        
        _ = sut.view
    }

    func test_HasTitleUIElements() {
        XCTAssertNotNil(sut.titleTextField)
        XCTAssertNotNil(sut.dateTextField)
        XCTAssertNotNil(sut.addressTextField)
        XCTAssertNotNil(sut.descriptionTextField)
        XCTAssertNotNil(sut.saveButton)
        XCTAssertNotNil(sut.cancelButton)
    }

    var placemark: MockPlacemark!
    
    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let timestamp = 1456030800.0
        let date = Date(timeIntervalSince1970: timestamp)
        
        sut.titleTextField.text = "Foo"
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.locationTextField.text = "Bar"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Baz"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        sut.itemManager = ItemManager()
        sut.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2D(latitude: 37.33116851, longitude: -122.0300674)
        
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark],nil)
        
        let item = sut.itemManager?.item(at: 0)
        
        let testItem = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: timestamp, location: Location(name: "Bar", coordinate: coordinate))
    
        
        XCTAssertEqual(item?.title, testItem.title)
        XCTAssertEqual(item?.location, testItem.location)
        XCTAssertEqual(item?.timestamp, testItem.timestamp)
        XCTAssertEqual(item?.itemDescription, testItem.itemDescription)
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(actions.contains("save"))
    }
    
}

fileprivate let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "MM/dd/yyyy"
    return df
}()

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            
            self.completionHandler = completionHandler
        }
    }
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
