//
//  TestContentViewController.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/27.
//

import XCTest
@testable import iOS_Exercise

class TestContentViewController: XCTestCase {
    
    var sut: ContentViewController!
    var storyboard: UIStoryboard!
    var viewModelMock: ContentViewModelMock!
    var dataLoaderMock: DataLoaderMock!
    
    override func setUp() {
        storyboard = UIStoryboard.init(name: GlobalStrings.mainStoryboardIdentifier, bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: GlobalStrings.mainStoryboardIdentifier) as? ContentViewController
        dataLoaderMock = DataLoaderMock()
        viewModelMock = ContentViewModelMock(dataLoader: dataLoaderMock, delegate: sut)
        sut.viewModel = viewModelMock
        
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        storyboard = nil
        dataLoaderMock = nil
        viewModelMock = nil
        sut = nil
    }
    
    func test_registerContentCell_whenViewDidLoad_contentCellCanBeReused() {
        // Given
        // When
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: ContentStrings.contentCellIdentifier) as? ContentTableViewCell
        
        // Then
        XCTAssertNotNil(cell)
    }
    
    func test_registerErrorCell_whenViewDidLoad_errorCellCanBeReused() {
        // Given
        // When
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: ContentStrings.errorCellIdentifier) as? ErrorTableViewCell
        
        // Then
        XCTAssertNotNil(cell)
    }
    
    func test_firstRequest_whenViewDidLoad_shouldRequestData() {
        // Given
        // When
        // Then
        XCTAssertTrue(viewModelMock.requestPlantDataIsCalled)
        XCTAssertEqual(viewModelMock.requestOffset, 0)
    }
        
        // Then
        XCTAssertEqual(sut.viewModel?.dataCount, 20)
    }
}
