//
//  DataLoader.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation
import Alamofire

class DataLoader {
    func urlConstructor(scheme: String, host: String, path: String, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents.url
    }
    
    func loadData(requestUrl: URL, completionHandler: @escaping ((Data?) -> Void)) {
        AF.request(requestUrl).responseData { response in
            switch response.result {
            case .success:
                completionHandler(response.data)
            case .failure:
                completionHandler(nil)
            }
        }
    }
}
