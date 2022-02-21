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
    
    var runLoadData: Bool = true
    var apiStatus: APIStatus = .success
    var expectation: XCTestExpectation?
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        if !runLoadData { return }
        
        switch apiStatus {
        case .loading:
            break
        case .success:
            break
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
        expectation?.fulfill()
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
