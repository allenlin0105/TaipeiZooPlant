//
//  TestContentViewController.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/27.
//

import XCTest
@testable import iOS_Exercise

class TestContentViewController: XCTestCase {
    
    func test_viewDidLoad_setupViewModelDelegate() {
        let mock = DataLoaderMock(apiCondition: [.successWithJSON], image: nil)
        let spy = ContentViewModel(dataLoader: mock)
        let sut = ContentViewController(viewModel: spy)
        
        _ = sut.view
        
        XCTAssertTrue(sut.isEqualTo(spy.delegate!))
    }
    
    func test_viewDidLoad_withNoNetworkFail_receiveCorrectData() {
        let mock = DataLoaderMock(apiCondition: [.successWithJSON], image: nil)
        let spy = ContentViewModel(dataLoader: mock)
        let sut = ContentViewController(viewModel: spy)
        
        _ = sut.view
        
        let stub = makeStub(totalStub: 1, imageUrl: mock.imageUrl, image: mock.image)
        XCTAssertEqual(spy.plantDataModel.plantDataList, stub)
    }
    
    // MARK: - Helper
}

// MARK: - Private extension for ContentProtocol

private extension ContentProtocol where Self: Equatable {
    func isEqualTo(_ another: ContentProtocol) -> Bool {
        guard let another = another as? Self else { return false }
        return self == another
    }
}
