//
//  TestContentViewModel.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/24.
//

import XCTest
@testable import iOS_Exercise

enum APICondition {
    case success
    case networkFailure
    case decodeFailure
}

class TestContentViewModel: XCTestCase {
    
    private let testingImageUrlString = "http://www.zoo.gov.tw/image.jpg"
    
    func test_setupUrl_withOneRequest_receiveUrlWithOffsetEqualsZero() {
        let (sut, _) = makeSUT(with: [.success], totalStub: 0)
        sut.requestPlantData(at: 0)
        
        XCTAssertEqual(sut.apiString, "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")
    }
        
    func test_requestDataTwice_withTwoSameRequestsAndNoFail_onlyReceiveDataOnce() {
        let (sut, stub) = makeSUT(with: [.success, .success], totalStub: 1)
        sut.requestPlantData(at: 0)
        sut.requestPlantData(at: 0)

        XCTAssertEqual(sut.plantDataModel.plantDataList, stub)
        XCTAssertEqual(sut.alreadyRequestOffset, 0)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsAndNoFail_receiveCorrectData() {
        let (sut, stub) = makeSUT(with: [.success, .success], totalStub: 2)
        sut.requestPlantData(at: 0)
        sut.requestPlantData(at: 20)
        
        XCTAssertEqual(sut.plantDataModel.plantDataList, stub)
        XCTAssertEqual(sut.alreadyRequestOffset, 20)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsButOneNetworkFail_onlyReceiveDataOnce() {
        let (firstSUT, stub) = makeSUT(with: [.success, .networkFailure], totalStub: 1)
        firstSUT.requestPlantData(at: 0)
        firstSUT.requestPlantData(at: 20)
        
        let (secondSUT, _) = makeSUT(with: [.networkFailure, .success], totalStub: 1)
        secondSUT.requestPlantData(at: 0)
        secondSUT.requestPlantData(at: 0)
        
        XCTAssertEqual(firstSUT.plantDataModel.plantDataList, stub)
        XCTAssertEqual(secondSUT.plantDataModel.plantDataList, stub)
        XCTAssertEqual(firstSUT.alreadyRequestOffset, 0)
        XCTAssertEqual(secondSUT.alreadyRequestOffset, 0)
    }
    
    func test_requestDataTwice_withTwoDifferentRequestsButBothFail_receiveNetworkError() {
        let (sut, _) = makeSUT(with: [.networkFailure, .networkFailure], totalStub: 0)
        sut.requestPlantData(at: 0)
        sut.requestPlantData(at: 0)
        
        XCTAssertEqual(sut.plantDataModel.plantDataList, [])
        XCTAssertEqual(sut.alreadyRequestOffset, -20)
    }
    
    func test_lastRequest_withAllDataReceived_setFinishAllAccessToTrue() {
        let (sut, _) = makeSUT(with: [.decodeFailure], totalStub: 0)
        sut.requestPlantData(at: 1000)
        
        XCTAssertTrue(sut.finishAllAccess)
    }
    
    // MARK: - Helper
    
    func makeSUT(with apiCondition: [APICondition], totalStub: Int) -> (ContentViewModel, [PlantData]) {
        let mock: DataLoaderProtocol = DataLoaderMock(apiCondition: apiCondition)
        let sut = ContentViewModel(apiString: GlobalStrings.baseAPIString, dataLoader: mock)
        var stub: [PlantData] = []
        for i in 0..<totalStub {
            stub += [PlantData].init(repeating: PlantData(name: "name\(i)", location: "location\(i)", feature: "feature\(i)", imageURL: URL(string: testingImageUrlString), image: nil), count: 20)
        }
        return (sut, stub)
    }
    
    private class DataLoaderMock: DataLoaderProtocol {
        private let apiCondition: [APICondition]
        private var requestCount: Int = 0
        
        init(apiCondition: [APICondition]) {
            self.apiCondition = apiCondition
        }

        func loadData(requestUrl: URL, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
            switch apiCondition[requestCount] {
            case .success:
                let offsetString = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == "offset" })?.value ?? "0"
                let offset = (Int(offsetString) ?? 0) / 20
                let data = createValidationData(at: offset)
                completionHandler(.success(data))
                break
            case .networkFailure:
                completionHandler(.failure(.requestFail))
                break
            case .decodeFailure:
                completionHandler(.failure(.decodeDataFail))
                break
            }
            
            requestCount += 1
        }
        
        private func createValidationData(at offset: Int) -> Data {
            let singleResult = """
                 {
                    "F_Location":"location\(String(describing: offset))",
                    "F_Pic01_URL":"http://www.zoo.gov.tw/image.jpg",
                    "F_Name_Ch":"name\(String(describing: offset))",
                    "F_Feature":"feature\(String(describing: offset))",
                 },
            """
            var allResults = ""
            for _ in 0..<20 {
                allResults += singleResult
            }
            let jsonString = """
                {
                   "result":{
                      "results":[
                         \(allResults)
                      ]
                   }
                }
            """
            let data: Data? = jsonString.data(using: .utf8)
            return data!
        }
    }
}
