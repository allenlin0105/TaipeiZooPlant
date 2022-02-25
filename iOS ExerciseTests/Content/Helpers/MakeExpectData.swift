//
//  StubMaker.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
@testable import iOS_Exercise

public func makeJSONData(at offset: Int = 0) -> Data {
    let singleResult = """
         {
            "F_Location":"location\(String(describing: offset))",
            "F_Pic01_URL":"\(TestingConstant.imageURLString)",
            "F_Name_Ch":"name\(String(describing: offset))",
            "F_Feature":"feature\(String(describing: offset))"
         },
    """
    var allResults = [String].init(repeating: singleResult, count: 20).joined(separator: "")
    allResults = String(allResults.dropLast())
    let jsonString = """
        {
           "result":{
              "results":[
                 \(allResults)
              ]
           }
        }
    """
    let data = jsonString.data(using: .utf8)!
    return data
}

public func makePlantData(totalData: Int, withImageURL: Bool, image: UIImage?) -> [PlantData] {
    var stub: [PlantData] = []
    let imageURL = withImageURL ? URL(string: TestingConstant.imageURLString) : nil
    for i in 0..<(totalData / 20) {
        stub += [PlantData].init(repeating: PlantData(name: "name\(i)",
                                                      location: "location\(i)",
                                                      feature: "feature\(i)",
                                                      imageURL: imageURL,
                                                      image: image),
                                 count: 20)
    }
    
    return stub
}
