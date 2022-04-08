//
//  DataLoaderMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
import XCTest
@testable import iOS_Exercise

class DataLoaderMock: DataLoaderProtocol {
    
    var runLoadData = true
    var apiStatuses: [APIStatus] = [.success]
    var isRequestImage = false
    var withImageURL = true
    var loadDataIsCalled = false
    var expectations: [XCTestExpectation]?
    private var apiIndex = 0
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        if !runLoadData { return }
        
        loadDataIsCalled = true
        switch apiStatuses[apiIndex] {
        case .loading:
            break
        case .success:
            var data = Data()
            if isRequestImage {
                data = TestingConstant.successImage?.pngData()! ?? Data()
            } else {
                let offset = (Int(requestURL.getQueryValue(for: "offset")) ?? 0) / 20
                data = makeJSONData(at: offset, withImageURL: withImageURL)
            }
            completionHandler(.success(data))
        case .noData:
            let data = "{\"result\":{\"results\":[]}}".data(using: .utf8)!
            completionHandler(.success(data))
        case .requestFail:
            let error = NSError(domain: "TestingError", code: 1, userInfo: nil)
            completionHandler(.failure(error))
        case .decodeFail:
            let data = "{results: []}".data(using: .utf8)!
            completionHandler(.success(data))
        }
        expectations?[apiIndex].fulfill()
        apiIndex += 1
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
