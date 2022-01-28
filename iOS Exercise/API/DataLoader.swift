//
//  DataLoader.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation

class DataLoader: DataLoaderProtocol {
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: requestURL) { data, response, error in
            if error != nil {
                completionHandler(.failure(.requestFail))
            }
            if let data = data {
                completionHandler(.success(data))
            }
        }
        task.resume()
    }
}
