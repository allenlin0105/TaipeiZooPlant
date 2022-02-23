//
//  ContentViewDelegateMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/2/23.
//

import Foundation
@testable import iOS_Exercise

class ContentViewDelegateMock: ContentViewProtocol {
    
    var reloadContentTableViewIsCalled = false
    
    func reloadContentTableView() {
        reloadContentTableViewIsCalled = true
    }
}
