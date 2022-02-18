//
//  TestDataLoader.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/2/18.
//

import XCTest
@testable import iOS_Exercise

class TestDataLoader: XCTestCase {
    
    var sut: DataLoaderProtocol!
    var expectation: XCTestExpectation!
    var url: URL!
    
    func test_dataLoader_withSuccessRequest_receiveData() {
        // Given
        URLSessionMock.isSuccess = true
        
        // When
        sut.loadData(requestURL: url) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(_):
                XCTFail()
            }
            self.expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func test_dataLoader_withFailRequest_receiveRequestError() {
        // Given
        URLSessionMock.isSuccess = false
        
        // When
        sut.loadData(requestURL: url) { result in
            // Then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Helpers
    
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
}
