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
    private var viewDelegateMock: ContentViewDelegateMock!
    private var expectations: [XCTestExpectation]!
    
    override func setUp() {
        dataLoaderMock = DataLoaderMock()
        viewDelegateMock = ContentViewDelegateMock()
        sut = ContentViewModel(dataLoader: dataLoaderMock,
                               delegate: viewDelegateMock)
        expectations = [
            XCTestExpectation(description: "First load"),
            XCTestExpectation(description: "Second load")
        ]
    }
    
    override func tearDown() {
        dataLoaderMock = nil
        viewDelegateMock = nil
        sut = nil
        expectations = nil
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
        
    func test_requestData_withSuccessResponse_shouldSetStatusToSuccessAndReloadTableView() {
        // Given
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations
        
        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .success)
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }
    
    func test_requestData_withNetworkFail_shouldSetStatusToRequestFailAndReloadTableView() {
        // Given
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations
        dataLoaderMock.apiStatuses = [.requestFail]

        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .requestFail)
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }

    func test_requestData_withDecodeFail_shouldSetStatusToDecodeFailAndReloadTableView() {
        // Given
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations
        dataLoaderMock.apiStatuses = [.decodeFail]

        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .decodeFail)
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }

    func test_lastRequest_withAllDataReceived_shouldSetStatusToNoDataAndReloadTableView() {
        // Given
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations
        dataLoaderMock.apiStatuses = [.noData]

        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .noData)
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }
    
    func test_requestData_withTwoSameRequests_shouldOnlySaveDataOnce() {
        // Given
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations
        dataLoaderMock.apiStatuses = [.success]
        let expect = makePlantData(totalStub: 1,
                                   imageURL: "http://www.zoo.gov.tw/image.jpg",
                                   image: nil)
        
        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        sut.requestPlantData(at: 0)
        
        // Then
        XCTAssertEqual(sut.plantDataModel.plantDataList, expect)
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
