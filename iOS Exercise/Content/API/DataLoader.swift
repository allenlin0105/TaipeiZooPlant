//
//  DataLoader.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation

class DataLoader: DataLoaderProtocol {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        let task = urlSession.dataTask(with: requestURL) { data, _, error in
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
