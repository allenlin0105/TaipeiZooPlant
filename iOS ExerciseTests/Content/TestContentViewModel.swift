//
//  TestContentViewModel.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/24.
//

import XCTest
@testable import iOS_Exercise

class TestContentViewModel: XCTestCase {
    
    func test_setupUrl_withOneRequest_receiveUrlWithOffsetEqualsZero() {
        let (sut, _) = makeSUT(with: [.successWithJSON])
        sut.requestProcedure()
        
        XCTAssertEqual(sut.apiString, "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")
    }
        
    func test_requestData_withNetworkFail_receiveError() {
        let (sut, _) = makeSUT(with: [.networkFailure])
        sut.requestProcedure()
        
        XCTAssertEqual(sut.dataList(), [])
    }
    
    func test_requestData_withDecodeFail_receiveError() {
        let (sut, _) = makeSUT(with: [.decodeFailure])
        sut.requestProcedure()
        
        XCTAssertEqual(sut.dataList(), [])
    }
    
    func test_requestDataTwice_withTwoSameRequestsAndNoFail_onlyReceiveDataOnce() {
        let (sut, stub) = makeSUT(with: [.successWithJSON, .successWithJSON], totalStub: 1)
        sut.requestProcedure(for: [0, 0])
        
        XCTAssertEqual(sut.dataList(), stub)
    }
    
    func test_requestDataTwice_withTwoSameRequestsButFirstFail_shouldReceiveCorrectData() {
        let (sut, stub) = makeSUT(with: [.networkFailure, .successWithJSON], totalStub: 1)
        sut.requestProcedure(for: [0, 0])
        
        XCTAssertEqual(sut.dataList(), stub)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsAndNoFail_receiveCorrectData() {
        let (sut, stub) = makeSUT(with: [.successWithJSON, .successWithJSON], totalStub: 2)
        sut.requestProcedure(for: [0, 20])
        
        XCTAssertEqual(sut.dataList(), stub)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsButOneNetworkFail_onlyReceiveDataOnce() {
        let (firstSUT, stub) = makeSUT(with: [.successWithJSON, .networkFailure], totalStub: 1)
        firstSUT.requestProcedure(for: [0, 20])
        
        let (secondSUT, _) = makeSUT(with: [.networkFailure, .successWithJSON], totalStub: 1)
        secondSUT.requestProcedure(for: [0, 0])
        
        XCTAssertEqual(firstSUT.dataList(), stub)
        XCTAssertEqual(secondSUT.dataList(), stub)
    }
    
    func test_lastRequest_withAllDataReceived_setFinishAllAccessToTrue() {
        let (sut, _) = makeSUT(with: [.successWithJSONButNoData])
        sut.requestProcedure(for: [1000])
        
        XCTAssertTrue(sut.finishAllAccess)
    }
    
    func test_requestImage_withImageUrlIsNil_imageStillNil() {
        let (sut, _) = makeSUT(with: [.successWithJSON], withImageURL: false)
        sut.requestProcedure()
        sut.requestImage(at: 0)
        
        XCTAssertNil(sut.firstImageURL())
        XCTAssertNil(sut.firstImage())
    }
    
    func test_requestImage_withImageUrl_receiveCorrectImage() {
        let (sut, stub) = makeSUT(with: [.successWithJSON, .successWithImage], totalStub: 1, stubWithImage: true)
        sut.requestProcedure()
        sut.requestImage(at: 0)
        
        XCTAssertNotNil(sut.firstImage())
        XCTAssertEqual(sut.firstImage()?.pngData(), stub.first?.image?.pngData())
    }
    
    func test_requestImage_withImageUrlButNetworkFail_imageStillNil() {
        let (sut, _) = makeSUT(with: [.successWithJSON, .networkFailure])
        sut.requestProcedure()
        sut.requestImage(at: 0)
        
        XCTAssertNotNil(sut.firstImageURL())
        XCTAssertNil(sut.firstImage())
    }
    
    func test_requestImage_jsonNotReceiveYet_shouldReturnAndNotCrash() {
        let (sut, _) = makeSUT(with: [.successWithImage])
        sut.requestImage(at: 0)
    }
    
    // MARK: - Helper
    
    func makeSUT(with apiCondition: [APICondition], totalStub: Int = 0, withImageURL: Bool = true, stubWithImage: Bool = false) -> (ContentViewModel, [PlantData]) {
        let mock = DataLoaderMock(apiCondition: apiCondition, withImageURL: withImageURL, withImage: stubWithImage)
        let sut = ContentViewModel(dataLoader: mock)
        let stub = makeStub(totalStub: totalStub, imageURL: mock.imageURL, image: mock.image)
        
        return (sut, stub)
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
