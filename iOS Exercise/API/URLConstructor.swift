//
//  URLConstructor.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/21.
//

import Foundation

class URLConstructor {
    static func getUrl(scheme: String, host: String, path: String, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents.url
    }
}
