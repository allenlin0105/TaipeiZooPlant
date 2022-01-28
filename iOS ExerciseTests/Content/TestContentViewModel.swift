//
//  TestContentViewModel.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/24.
//

import XCTest
@testable import iOS_Exercise

enum APICondition {
    case successWithJSON
    case successWithImage
    case networkFailure
    case decodeFailure
}

class TestContentViewModel: XCTestCase {
    
    func test_setupUrl_withOneRequest_receiveUrlWithOffsetEqualsZero() {
        let (sut, _) = makeSUT(with: [.successWithJSON])
        sut.requestProcedure()
        
        XCTAssertEqual(sut.apiString, "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")
    }
        
    func test_requestDataTwice_withTwoSameRequestsAndNoFail_onlyReceiveDataOnce() {
        let (sut, stub) = makeSUT(with: [.successWithJSON, .successWithJSON], totalStub: 1)
        sut.requestProcedure(for: [0, 0])
        
        XCTAssertEqual(sut.dataList(), stub)
        XCTAssertEqual(sut.alreadyRequestOffset, 0)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsAndNoFail_receiveCorrectData() {
        let (sut, stub) = makeSUT(with: [.successWithJSON, .successWithJSON], totalStub: 2)
        sut.requestProcedure(for: [0, 20])
        
        XCTAssertEqual(sut.dataList(), stub)
        XCTAssertEqual(sut.alreadyRequestOffset, 20)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsButOneNetworkFail_onlyReceiveDataOnce() {
        let (firstSUT, stub) = makeSUT(with: [.successWithJSON, .networkFailure], totalStub: 1)
        firstSUT.requestProcedure(for: [0, 20])
        
        let (secondSUT, _) = makeSUT(with: [.networkFailure, .successWithJSON], totalStub: 1)
        secondSUT.requestProcedure(for: [0, 0])
        
        XCTAssertEqual(firstSUT.dataList(), stub)
        XCTAssertEqual(secondSUT.dataList(), stub)
        XCTAssertEqual(firstSUT.alreadyRequestOffset, 0)
        XCTAssertEqual(secondSUT.alreadyRequestOffset, 0)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsButBothFail_receiveNetworkError() {
        let (sut, _) = makeSUT(with: [.networkFailure, .networkFailure])
        sut.requestProcedure(for: [0, 0])
        
        XCTAssertEqual(sut.dataList(), [])
        XCTAssertEqual(sut.alreadyRequestOffset, -20)
    }
    
    func test_lastRequest_withAllDataReceived_setFinishAllAccessToTrue() {
        let (sut, _) = makeSUT(with: [.decodeFailure])
        sut.requestProcedure(for: [1000])
        
        XCTAssertTrue(sut.finishAllAccess)
    }
    
    func test_requestImage_withImageUrlIsNil_imageStillNil() {
        let (sut, _) = makeSUT(with: [.successWithJSON], withImageUrl: false)
        sut.requestPlantData(at: 0)
        sut.requestImage(at: 0)
        
        XCTAssertNil(sut.dataList().first?.imageURL)
        XCTAssertNil(sut.dataList().first?.image)
    }
    
    func test_requestImage_withImageUrl_receiveCorrectImage() {
        let (sut, stub) = makeSUT(with: [.successWithJSON, .successWithImage], totalStub: 1, stubWithImage: true)
        sut.requestProcedure()
        sut.requestImage(at: 0)
        
        XCTAssertNotNil(sut.dataList().first?.image)
        XCTAssertEqual(sut.dataList().first?.image?.pngData(), stub.first?.image?.pngData())
    }
    
    func test_requestImage_withImageUrlButNetworkFail_imageStillNil() {
        let (sut, _) = makeSUT(with: [.successWithJSON, .networkFailure])
        sut.requestProcedure()
        sut.requestImage(at: 0)
        
        XCTAssertNotNil(sut.dataList().first?.imageURL)
        XCTAssertNil(sut.dataList().first?.image)
    }
    
    func test_requestImage_jsonNotReceiveYet_shouldBusyWaitingAndDoNotCrash() {
        let (sut, stub) = makeSUT(with: [.successWithImage, .successWithJSON], totalStub: 1, stubWithImage: true)
        DispatchQueue.global().async {
            sut.requestImage(at: 0)
            
            XCTAssertNotNil(sut.dataList().first?.image)
            XCTAssertEqual(sut.dataList().first?.image?.pngData(), stub.first?.image?.pngData())
        }
        sut.requestProcedure()
    }
    
    // MARK: - Helper
    
    func makeSUT(with apiCondition: [APICondition], totalStub: Int = 0, withImageUrl: Bool = true, stubWithImage: Bool = false) -> (ContentViewModel, [PlantData]) {
        var mock = DataLoaderMock()
        if withImageUrl && stubWithImage {
            mock = DataLoaderMock(apiCondition: apiCondition)
        } else if !withImageUrl {
            mock = DataLoaderMock(apiCondition: apiCondition, imageUrl: "")
        } else if !stubWithImage {
            mock = DataLoaderMock(apiCondition: apiCondition, image: nil)
        } else {
            mock = DataLoaderMock(apiCondition: apiCondition, imageUrl: "", image: nil)
        }
        let sut = ContentViewModel(dataLoader: mock)
        
        var stub: [PlantData] = []
        for i in 0..<totalStub {
            stub += [PlantData].init(repeating: PlantData(name: "name\(i)", location: "location\(i)", feature: "feature\(i)", imageURL: URL(string: mock.imageUrl), image: mock.image), count: 20)
        }
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
}
