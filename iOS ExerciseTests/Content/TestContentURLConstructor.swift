//
//  TestUrlConstructor.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/23.
//

import XCTest
@testable import iOS_Exercise

class TestContentURLConstructor: XCTestCase {
    private func setupQueryDict(query: String) -> [String: String] {
        var dict: Dictionary<String, String> = [:]
        query.split(separator: "&").forEach { subString in
            let key = String(subString.split(separator: "=")[0])
            let value = String(subString.split(separator: "=")[1])
            dict[key] = value
        }
        return dict
    }
    
    func test_createUrl_setupValidAPIUrl() throws {
        let parameters = [
            "scope": "resourceAquire",
            "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14",
            "limit": "20",
            "offset": "0"
        ]
        let responseUrl = URLConstructor.getUrl(scheme: "https", host: "data.taipei", path: "/opendata/datalist/apiAccess", parameters: parameters)!
        let validUrl = URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0")!
        
        XCTAssertEqual(responseUrl.scheme, validUrl.scheme)
        XCTAssertEqual(responseUrl.host, validUrl.host)
        XCTAssertEqual(responseUrl.path, validUrl.path)
        XCTAssertEqual(setupQueryDict(query: responseUrl.query!), setupQueryDict(query: responseUrl.query!))
    }
}
