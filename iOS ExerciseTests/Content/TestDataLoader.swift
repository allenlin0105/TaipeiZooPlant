//
//  TestDataLoader.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/2/18.
//

import XCTest
@testable import iOS_Exercise

class TestDataLoader: XCTestCase {
    
    private var sut: DataLoader!
    private var expectation: XCTestExpectation!
    private var url: URL!
    
    override func setUp() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLSessionMock.self]
        let urlSession = URLSession(configuration: config)
        sut = DataLoader(urlSession: urlSession)
        expectation = XCTestExpectation(description: "Test DataLoader")
        url = URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")
    }
    
    override func tearDown() {
        sut = nil
        expectation = nil
        url = nil
    }
    
    func test_dataLoader_withSuccessRequest_receiveData() {
        // Given
        var expectedData: Data? = nil
        URLSessionMock.isSuccess = true
        
        // When
        sut.loadData(requestURL: url) { result in
            switch result {
            case .success(let data):
                expectedData = data
            case .failure(_):
                XCTFail()
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertNotNil(expectedData)
    }
    
    func test_dataLoader_withFailRequest_receiveRequestError() {
        // Given
        var expectedError: Error? = nil
        URLSessionMock.isSuccess = false
        
        // When
        sut.loadData(requestURL: url) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertNotNil(expectedError)
    }
}
