//
//  DataLoaderProtocol.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/24.
//

import Foundation

protocol DataLoaderProtocol {
    func loadData(requestUrl: URL, completionHandler: @escaping ((Data?) -> Void))
}
