//
//  StubMaker.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
@testable import iOS_Exercise

public func makeStub(totalStub: Int, imageURL: String, image: UIImage?) -> [PlantData] {
    var stub: [PlantData] = []
    for i in 0..<totalStub {
        stub += [PlantData].init(repeating: PlantData(name: "name\(i)", location: "location\(i)", feature: "feature\(i)", imageURL: URL(string: imageURL), image: image), count: 20)
    }
    
    return stub
}
