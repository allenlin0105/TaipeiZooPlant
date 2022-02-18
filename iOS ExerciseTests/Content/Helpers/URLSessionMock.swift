//
//  URLSessionMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/2/18.
//

import Foundation

class URLSessionMock: URLProtocol {
    
    static var isSuccess: Bool = true
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if URLSessionMock.isSuccess {
            client?.urlProtocol(self, didLoad: Data())
        } else {
            let error = NSError(domain: "TestingError", code: 1, userInfo: nil)
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
