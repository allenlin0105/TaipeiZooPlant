//
//  APICondition.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/2/16.
//

import Foundation

enum APICondition {
    case successWithJSON
    case successWithJSONButNoData
    case successWithImage
    case networkFailure
    case decodeFailure
}
