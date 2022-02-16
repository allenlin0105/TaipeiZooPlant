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
        let task = session.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let data = data {
                completionHandler(.success(data))
            }
        }
        task.resume()
    }
}
