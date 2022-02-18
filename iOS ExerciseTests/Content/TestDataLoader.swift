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
    private let url = URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")!
    
    func test_dataLoader_withSuccessRequest_receiveData() {
        // Given
        URLSessionMock.responseDataStub = Data()
        
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
        let errorMessage = "Request Fail"
        URLSessionMock.errorDescription = errorMessage
        
        // When
        sut.loadData(requestURL: url) { result in
            // Then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, errorMessage)
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
    }
    
    override func tearDown() {
        sut = nil
        URLSessionMock.responseDataStub = nil
        URLSessionMock.errorDescription = nil
    }
}
