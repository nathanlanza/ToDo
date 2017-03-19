import XCTest
@testable import FirstDemo

class FirstDemoTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        viewController = ViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_numberOfVowels_WhenPassedNathanReturnsTwo() {
        let string = "Nathan"
        let numberOfVowels = viewController.numberOfVowels(in: string)
        XCTAssertEqual(numberOfVowels, 2, "should find 2 vowels in 'Nathan'")
    }
    
    func test_makeHeadline_ReturnsStringWithEachWordStartCapital() {
        let input = "this is a test headline"
        let expectedOutput = "This Is A Test Headline"
        
        let headline = viewController.makeHeadline(from: input)
        
        XCTAssertEqual(headline, expectedOutput)
    }
    func test_makeHeadline_ReturnsStringWithEachWordStartCapital2() {
        let input = "Here is another example"
        let expectedOutput = "Here Is Another Example"
        
        let headline = viewController.makeHeadline(from: input)
        
        XCTAssertEqual(headline, expectedOutput)
    }
   
    
    
}
