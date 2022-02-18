//
//  DataLoaderMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
@testable import iOS_Exercise

class DataLoaderMock: DataLoaderProtocol {
    
    private var currentRequestIndex: Int = 0
    private let apiConditions: [APICondition]
    let imageURL: String
    let image: UIImage?
    
    init(apiCondition: [APICondition], withImageURL: Bool, withImage: Bool) {
        self.apiConditions = apiCondition
        self.imageURL = withImageURL ? "http://www.zoo.gov.tw/image.jpg" : ""
        self.image = withImage ? UIImage(named: "TestImage") : nil
    }
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        switch apiConditions[currentRequestIndex] {
        case .successWithJSON:
            let offset = (Int(requestURL.getQueryValue(for: "offset")) ?? 0) / 20
            let data = createValidationData(at: offset)
            completionHandler(.success(data))
        case .successWithJSONButNoData:
            let data = createValidationData(withNoData: true)
            completionHandler(.success(data))
        case .successWithImage:
            completionHandler(.success(image!.pngData()!))
        case .networkFailure:
            let error = NSError(domain: "", code: 404, userInfo: nil)
            completionHandler(.failure(error))
        case .decodeFailure:
            let data = "{\"Wrong\": {}}".data(using: .utf8)
            completionHandler(.success(data!))
        }
        
        currentRequestIndex += 1
    }
    
    private func createValidationData(at offset: Int = 0, withNoData: Bool = false) -> Data {
        let singleResult = """
             {
                "F_Location":"location\(String(describing: offset))",
                "F_Pic01_URL":"\(imageURL)",
                "F_Name_Ch":"name\(String(describing: offset))",
                "F_Feature":"feature\(String(describing: offset))"
             },
        """
        let totalDataCount = withNoData ? 0 : 20
        var allResults = [String].init(repeating: singleResult, count: totalDataCount).joined(separator: "")
        allResults = String(allResults.dropLast())
        let jsonString = """
            {
               "result":{
                  "results":[
                     \(allResults)
                  ]
               }
            }
        """
        let data = jsonString.data(using: .utf8)
        
        return data!
    }
}

// MARK: - Private Extension of URL

private extension URL {
    
    func getQueryValue(for key: String) -> String {
        let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems
        let value = queryItems?.first(where: { $0.name == key })?.value
        return value ?? ""
    }
}
