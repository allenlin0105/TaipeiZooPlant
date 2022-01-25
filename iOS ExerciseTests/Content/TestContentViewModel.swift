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
}

class TestContentViewModel: XCTestCase {
    private let testingImageUrlString = "http://www.zoo.gov.tw/image.jpg"
    
    func test_start_withOneRequest_setupUrlWithOffsetEqualsZero() {
        let sut = makeSUT(with: [.success])
        sut.start()
        
        XCTAssertEqual(sut.apiString, "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")
    }
    
    func test_start_withOneRequest_receiveCorrectData() {
        let sut = makeSUT(with: [.success])
        sut.start()
        
        let stub = [PlantData].init(repeating: PlantData(name: "name0", location: "location0", feature: "feature0", imageURL: URL(string: testingImageUrlString), image: nil), count: 20)
        
        XCTAssertEqual(sut.plantDataModel.plantDataList, stub)
    }
    
    func test_start_withOneRequestButInternetFail_receiveNetworkError() {
        let sut = makeSUT(with: [.networkFailure])
        sut.start()
        
        XCTAssertEqual(sut.alreadyRequestOffset, -1)
    }
    
    func test_startTwice_withTwoSameRequest_onlyReceiveDataOneTime() {
        let sut = makeSUT(with: [.success])
        sut.start()
        sut.start()
        
        let stub = [PlantData].init(repeating: PlantData(name: "name0", location: "location0", feature: "feature0", imageURL: URL(string: testingImageUrlString), image: nil), count: 20)
        
        XCTAssertEqual(sut.plantDataModel.plantDataList, stub)
    }
    
    // MARK: - Helper
    
    func makeSUT(with apiCondition: [APICondition]) -> ContentViewModel {
        let mock: DataLoaderProtocol = DataLoaderMock(apiCondition: apiCondition)
        let sut = ContentViewModel(apiString: GlobalStrings.baseAPIString, dataLoader: mock)
        return sut
    }
    
    private class DataLoaderMock: DataLoaderProtocol {
        private let apiCondition: [APICondition]
        
        init(apiCondition: [APICondition]) {
            self.apiCondition = apiCondition
        }

        func loadData(requestUrl: URL, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
            let offset = Int(URLComponents(url: requestUrl, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == "offset" })?.value ?? "0") ?? 0
            switch apiCondition[offset] {
            case .success:
                let data = createValidationData(at: offset)
                completionHandler(.success(data))
                break
            case .networkFailure:
                completionHandler(.failure(.requestFail))
                break
            }
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
