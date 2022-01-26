//
//  DataLoaderProtocol.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/24.
//

import Foundation

enum APIError: Error {
    case requestFail
    case decodeDataFail
}

protocol DataLoaderProtocol {
    typealias resultCallback = (Swift.Result<Data, APIError>) -> Void
    func loadData(requestUrl: URL, completionHandler: @escaping resultCallback)
}
