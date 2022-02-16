//
//  DataLoaderProtocol.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/24.
//

import Foundation

protocol DataLoaderProtocol {
    typealias resultCallback = (Result<Data, Error>) -> Void
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback)
}
