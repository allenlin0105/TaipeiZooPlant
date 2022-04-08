//
//  APIStatus.swift
//  iOS Exercise
//
//  Created by allen on 2022/2/16.
//

import Foundation

enum APIStatus: CaseIterable {
    case loading
    case success
    case noData
    case requestFail
    case decodeFail
    
    var description: String {
        switch self {
        case .loading:
            return "Loading..."
        case .success:
            return ""
        case .noData:
            return "End of data..."
        case .requestFail:
            return "Request Fail"
        case .decodeFail:
            return "Decode Fail"
        }
    }
}
