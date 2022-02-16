//
//  DataLoaderProtocol.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/24.
//

import Foundation

typealias APIResult = Result<Data, Error>

protocol DataLoaderProtocol {
    typealias resultCallback = (APIResult) -> Void
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback)
}
