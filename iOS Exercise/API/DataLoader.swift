//
//  DataLoader.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation

class DataLoader: DataLoaderProtocol {
    func loadData(requestUrl: URL, completionHandler: @escaping resultCallback) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: requestUrl) { data, response, error in
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
