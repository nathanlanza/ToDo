import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
   
    func test_Login_UsesExpectedURL() {
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        let sut = APIClient()
        
        sut.session = mockURLSession
        
        let completion = { (token: Token?, error: Error?) in }
        let username = "dasdöm"
        let password = "%&34"
        sut.loginUser(withName: username, password: password, completion: completion)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let expectedUsername = username.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        guard let expectedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        let usernameQueryItem = URLQueryItem(name: "username", value: username)
        XCTAssert(urlComponents?.queryItems?.contains(usernameQueryItem) ?? false)
        let passwordQueryItem = URLQueryItem(name: "password", value: password)
        XCTAssert(urlComponents?.queryItems?.contains(passwordQueryItem) ?? false)
        
        XCTAssert(urlComponents?.percentEncodedQuery?.contains("username=\(expectedUsername)") ?? false)
        XCTAssert(urlComponents?.percentEncodedQuery?.contains("password=\(expectedPassword)") ?? false)
        
    }
    
    func test_Login_WhenSuccessful_CreatesToken() {
        let sut = APIClient()
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        let tokenExpectation = expectation(description: "Token")
        var catchedToken: Token?
        
        sut.loginUser(withName: "Foo", password: "Bar") { token, error in
            catchedToken = token  
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(catchedToken?.id, "1234567890")
        }
    }
    
    func test_Login_WhenJSONIsInvalid_ReturnsError() {
        let sut = APIClient()
        let mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error?
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(catchedError)
        }
    }
    
    func test_Login_WhenDataIsNil_ReturnsError() {
        let sut = APIClient()
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        
        var catchedError: Error?
        sut.loginUser(withName: "Foo", password: "Bar") { token, error in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(catchedError)
        }
    }
    
    func test_Login_WhenResponseHasError_ReturnsError() {
        let sut = APIClient()
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: error)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        
        var catchedError: Error?
        sut.loginUser(withName: "Foo", password: "Bar") { token, error in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(catchedError)
        }
    }
}

extension APIClientTests {
    class MockURLSession: SessionProtocol {
        var url: URL?
        private let dataTask: MockTask
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
        
        
    }
}
