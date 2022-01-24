//
//  TestContentDataMapper.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/24.
//

import XCTest
@testable import iOS_Exercise

class TestContentDataMapper: XCTestCase {
    func test_mapJSON_withDataEqualsNil_receiveEmptyList() {
        let data: Data? = nil
        let expectedCount: Int = 0
        
        let receive = DataMapper.mapTextData(data: data)
        XCTAssertTrue(receive.count == expectedCount)
    }
    
    func test_mapJSON_withData_returnPlantDataList() {
        
        
    }
    
    func test_mapImage_withDataEqualsNil_returnNil() {
        let data: Data? = nil
        let expect: UIImage? = nil
        
        let receive = DataMapper.mapImageData(data: data)
        XCTAssertEqual(receive, expect)
    }
    
    func test_mapImage_withData_returnUIImage() {
        
    }
}
