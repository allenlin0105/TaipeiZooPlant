//
//  URLSessionMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/2/18.
//

import Foundation

class URLSessionMock: URLProtocol {
    
    static var responseDataStub: Data?
    static var errorDescription: String?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let errorDescription = URLSessionMock.errorDescription {
            let error = NSError(domain: "TestingError", code: 1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocol(self, didLoad: URLSessionMock.responseDataStub ?? Data())
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
