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
        let (sut, spy, _) = makeSUT()
        _ = sut.view

        XCTAssertNotNil(spy.delegate, "delegate should not be nil")
        if spy.delegate == nil { return }
        XCTAssertTrue(sut.isEqualTo(spy.delegate!))
    }
    
    func test_viewDidLoad_withNoNetworkFail_receiveCorrectData() {
        let (sut, spy, stub) = makeSUT(totalStub: 1)
        _ = sut.view
        
        XCTAssertEqual(spy.plantDataModel.plantDataList, stub)
    }
    
    func test_viewDidLoad_withNoNetworkFail_renderTwentyCells() {
        let (sut, _, _) = makeSUT()
        _ = sut.view

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 20)
    }

    func test_viewDidLoad_withNoNetworkFail_renderCorrectContentInCell() {
        let (sut, _, _) = makeSUT()
        _ = sut.view
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as! ContentTableViewCell
        
        XCTAssertEqual(cell.plantName.text, "name0")
        XCTAssertEqual(cell.plantLocation.text, "location0")
        XCTAssertEqual(cell.plantFeature.text, "feature0")
    }
    
    
    // MARK: - Helper
    
    func makeSUT(apiCondition: [APICondition] = [.successWithJSON], totalStub: Int = 0,  withImageUrl: Bool = true, stubWithImage: Bool = false) -> (ContentViewController, ContentViewModel, [PlantData]) {
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
        
        let spy = ContentViewModel(dataLoader: mock)
        
        let mainStoryboard = UIStoryboard.init(name: GlobalStrings.mainStoryboardIdentifier, bundle: nil)
        let sut = mainStoryboard.instantiateViewController(withIdentifier: GlobalStrings.mainStoryboardIdentifier) as! ContentViewController
        sut.viewModel = spy
        
        let stub = makeStub(totalStub: totalStub, imageUrl: mock.imageUrl, image: mock.image)
        
        return (sut, spy, stub)
    }
}

// MARK: - Private extension for ContentProtocol

private extension ContentProtocol where Self: Equatable {
    func isEqualTo(_ another: ContentProtocol) -> Bool {
        guard let another = another as? Self else { return false }
        return self == another
    }
}
