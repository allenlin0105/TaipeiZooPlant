//
//  TestContentViewModel.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/24.
//

import XCTest
@testable import iOS_Exercise

class TestContentViewModel: XCTestCase {
    
    private var sut: ContentViewModel!
    private var dataLoaderMock: DataLoaderMock!
    
    override func setUp() {
        dataLoaderMock = DataLoaderMock()
        sut = ContentViewModel(dataLoader: dataLoaderMock)
    }
    
    override func tearDown() {
        dataLoaderMock = nil
        sut = nil
    }
    
    func test_setupURLString_withOffsetEqualsZero_receiveCorrectURL() {
        // Given
        // When
        let apiString = sut.makeAPIString(offset: 0)
        
        // Then
        XCTAssertEqual(apiString, "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")
    }
    
    func test_requestData_whenLoadingData_shouldSetStatusToLoading() {
        // Given
        dataLoaderMock.runLoadData = false
        
        // When
        sut.requestPlantData(at: 0)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .loading)
    }
        
    func test_requestData_withNetworkFail_shouldSetStatusToRequestFail() {
        // Given
        let expectation = XCTestExpectation(description: "Testing ContentViewModel for request fail")
        dataLoaderMock.apiStatus = .requestFail
        dataLoaderMock.expectation = expectation

        // When
        sut.requestPlantData(at: 0)
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .requestFail)
    }

    func test_requestData_withDecodeFail_shouldSetStatusToDecodeFail() {
        // Given
        let expectation = XCTestExpectation(description: "Testing ContentViewModel for decode fail")
        dataLoaderMock.apiStatus = .decodeFail
        dataLoaderMock.expectation = expectation

        // When
        sut.requestPlantData(at: 0)
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .decodeFail)
    }

    func test_lastRequest_withAllDataReceived_shouldSetStatusToNoData() {
        // Given
        let expectation = XCTestExpectation(description: "Testing ContentViewModel for no data")
        dataLoaderMock.apiStatus = .noData
        dataLoaderMock.expectation = expectation

        // When
        sut.requestPlantData(at: 0)
        wait(for: [expectation], timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .noData)
    }
}

// MARK: - ContentViewModel Private Extension

private extension ContentViewModel {

    func dataList() -> [PlantData] {
        return self.plantDataModel.plantDataList
    }
    
    func requestProcedure(for offset: [Int] = [0]) {
        for i in offset {
            self.requestPlantData(at: i)
        }
    }
    
    func firstImageURL() -> URL? {
        return self.dataList().first?.imageURL
    }
    
    func firstImage() -> UIImage? {
        return self.dataList().first?.image
    }
}
