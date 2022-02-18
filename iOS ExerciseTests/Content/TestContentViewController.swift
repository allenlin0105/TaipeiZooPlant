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

    func test_viewDidLoad_withNoNetworkFail_renderTwentyCellsWithCorrectContent() {
        let (sut, _, stub) = makeSUT(apiCondition: [.successWithJSON, .successWithImage], totalStub: 1, withImage: true)
        _ = sut.view

        XCTAssertEqual(sut.tableView.totalRows(), 20)

        let cell = sut.tableView.cell(at: 0)
        XCTAssertEqual(cell.plantName.text, stub.first?.name)
        XCTAssertEqual(cell.plantLocation.text, stub.first?.location)
        XCTAssertEqual(cell.plantFeature.text, stub.first?.feature)
        XCTAssertNotNil(cell.plantImage.image)
    }
    
    func test_secondRequest_whenAtTheEndOfPage_renderFourtyCellsWithCorrectData() {
        let (sut, _, stub) = makeSUT(apiCondition: [.successWithJSON, .successWithJSON, .successWithImage], totalStub: 2, withImage: true)
        _ = sut.view
        sut.tableView.willDisplayCell(at: 19)
        
        XCTAssertEqual(sut.tableView.totalRows(), 40)

        let cell = sut.tableView.cell(at: 20)
        XCTAssertEqual(cell.plantName.text, stub[20].name)
        XCTAssertEqual(cell.plantLocation.text, stub[20].location)
        XCTAssertEqual(cell.plantFeature.text, stub[20].feature)
        XCTAssertNotNil(cell.plantImage.image)
    }
    
    func test_lastRequest_withNoNewData_doNotCallRequestPlantData() {
        let (sut, spy, _) = makeSUT(apiCondition: [.successWithJSONButNoData])
        _ = sut.view
        sut.tableView.willDisplayCell(at: 1000)
        
        XCTAssertEqual(spy.requestPlantDataStatus, .noData)
    }
    
    // MARK: - Helper
    
    func makeSUT(apiCondition: [APICondition] = [.successWithJSON], totalStub: Int = 0, withImage: Bool = false) -> (ContentViewController, ContentViewModel, [PlantData]) {
        let mock = DataLoaderMock(apiCondition: apiCondition, withImageURL: true, withImage: withImage)
        let spy = ContentViewModel(dataLoader: mock)
        let stub = makeStub(totalStub: totalStub, imageURL: mock.imageURL, image: mock.image)
        
        let mainStoryboard = UIStoryboard.init(name: GlobalStrings.mainStoryboardIdentifier, bundle: nil)
        let sut = mainStoryboard.instantiateViewController(withIdentifier: GlobalStrings.mainStoryboardIdentifier) as! ContentViewController
        sut.viewModel = spy
        
        return (sut, spy, stub)
    }
}

// MARK: - Private extension for ContentProtocol

private extension ContentViewProtocol where Self: Equatable {
    func isEqualTo(_ another: ContentViewProtocol) -> Bool {
        guard let another = another as? Self else { return false }
        return self == another
    }
}

// MARK: - Private extension for UITableView

private extension UITableView {
    
    func totalRows(at section: Int = 0) -> Int {
        return self.dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
    }
    
    func cell(at row: Int, section: Int = 0) -> ContentTableViewCell {
        let indexPath = IndexPath(row: row, section: section)
        let cell = dataSource?.tableView(self, cellForRowAt: indexPath) as! ContentTableViewCell
        return cell
    }
    
    func willDisplayCell(at row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        delegate?.tableView?(self, willDisplay: ContentTableViewCell(), forRowAt: indexPath)
    }
}
