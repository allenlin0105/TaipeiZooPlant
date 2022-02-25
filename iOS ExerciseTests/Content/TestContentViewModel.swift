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
        dataLoaderMock.apiStatuses = [.requestFail]
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations

        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .requestFail)
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }

    func test_requestData_withDecodeFail_shouldSetStatusToDecodeFailAndReloadTableView() {
        // Given
        dataLoaderMock.apiStatuses = [.decodeFail]
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations

        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.requestPlantDataStatus, .decodeFail)
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }

    func test_lastRequest_withAllDataReceived_shouldSetStatusToNoDataAndReloadTableView() {
        // Given
        dataLoaderMock.apiStatuses = [.noData]
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations

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
        let expect = makePlantData(totalData: 20,
                                   withImageURL: true,
                                   image: nil)
        
        // When
        sut.requestPlantData(at: 0)
        wait(for: expectations, timeout: 2)
        sut.requestPlantData(at: 0)
        
        // Then
        XCTAssertEqual(sut.dataList, expect)
    }
    
    func test_requestData_withTwoDifferentRequests_shouldSaveDataTwice() {
        // Given
        dataLoaderMock.apiStatuses = [.success, .success]
        dataLoaderMock.expectations = expectations
        let expect = makePlantData(totalData: 40,
                                   withImageURL: true,
                                   image: nil)
        
        // When
        sut.requestPlantData(at: 0)
        sut.requestPlantData(at: 20)
        wait(for: expectations, timeout: 2)
        
        // Then
        XCTAssertEqual(sut.dataList, expect)
    }
    
    func test_requestImage_withNoDataReturnYet_shouldNotCrashInProductionCode() {
        // Given
        // When
        sut.requestImage(at: 0)
        
        // Then
        // It should not crash
    }
    
    func test_requestImage_withSuccessResponse_shouldSaveImageAndReloadTableView() {
        // Given
        dataLoaderMock.apiStatuses = [.success, .success]
        dataLoaderMock.expectations = expectations
        sut.requestPlantData(at: 0)
        wait(for: [expectations[0]], timeout: 2)
        viewDelegateMock.reloadContentTableViewIsCalled = false
        dataLoaderMock.isRequestImage = true

        // When
        sut.requestImage(at: 0)
        wait(for: [expectations[1]], timeout: 2)
        
        // Then
        XCTAssertEqual(sut.firstImage?.pngData(), TestingConstant.successImage?.pngData())
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }
    
    func test_requestImage_withRequestFail_shouldSaveErrorImageAndReloadTableView() {
        // Given
        dataLoaderMock.apiStatuses = [.success, .requestFail]
        dataLoaderMock.expectations = expectations
        
        sut.requestPlantData(at: 0)
        wait(for: [expectations[0]], timeout: 2)
        viewDelegateMock.reloadContentTableViewIsCalled = false
        dataLoaderMock.isRequestImage = true

        // When
        sut.requestImage(at: 0)
        wait(for: [expectations[1]], timeout: 2)
        
        // Then
        XCTAssertEqual(sut.firstImage?.pngData(), TestingConstant.errorImage?.pngData())
        XCTAssertTrue(viewDelegateMock.reloadContentTableViewIsCalled)
    }
    
    func test_requestImage_withImageURLEqualsNil_shouldSaveErrorImageAndNotCallLoadData() {
        // Given
        let expectations = Array(expectations[..<1])
        dataLoaderMock.expectations = expectations
        dataLoaderMock.withImageURL = false

        sut.requestPlantData(at: 0)
        wait(for: [expectations[0]], timeout: 2)
        dataLoaderMock.isRequestImage = true
        dataLoaderMock.loadDataIsCalled = false

        // When
        sut.requestImage(at: 0)

        // Then
        XCTAssertEqual(sut.firstImage?.pngData(), TestingConstant.errorImage?.pngData())
        XCTAssertFalse(dataLoaderMock.loadDataIsCalled)
    }
    
    func test_requestImage_withImageAlreadySaved_shouldNotCallLoadData() {
        // Given
        // Request order: json, image, image
        dataLoaderMock.apiStatuses = [.success, .success, .success]
        dataLoaderMock.expectations = expectations

        sut.requestPlantData(at: 0)
        wait(for: [expectations[0]], timeout: 2)
        dataLoaderMock.isRequestImage = true
        sut.requestImage(at: 0)
        wait(for: [expectations[1]], timeout: 2)
        dataLoaderMock.loadDataIsCalled = false

        // When
        sut.requestImage(at: 0)
        
        // Then
        XCTAssertFalse(dataLoaderMock.loadDataIsCalled)
    }
}

// MARK: - ContentViewModel Private Extension

private extension ContentViewModel {
    
    var dataList: [PlantData] {
        return self.plantDataModel.plantDataList
    }
    
    var firstImage: UIImage? {
        return self.dataList.first?.image
    }
}
