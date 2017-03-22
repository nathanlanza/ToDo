import XCTest
@testable import ToDo

class StoryboardTests: XCTestCase {
    
    var sut: UIViewController!
    var inputViewController: InputViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        sut = navigationController.viewControllers[0]
        
        UIApplication.shared.keyWindow?.rootViewController = sut.navigationController
    }
    
    func setupInput() {
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail()
            return
        }
        guard let action = addButton.action else {
            XCTFail()
            return
        }
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        inputViewController = sut.presentedViewController as? InputViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_InitialViewController_IsItemListViewController() {
        XCTAssert(sut is ItemListViewController)
    }
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }
    func test_AddItem_PresentsAddItemViewController() {
        XCTAssertNil(sut.presentedViewController)
        
        setupInput()
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        XCTAssertNotNil(inputViewController?.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        setupInput()
        guard let inputItemManager = inputViewController?.itemManager else {
            XCTFail()
            return
        }
        XCTAssert((sut as! ItemListViewController).itemManager === inputItemManager)
    }
}

