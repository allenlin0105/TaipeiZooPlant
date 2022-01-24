//
//  PlantData.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

struct PlantModel {
    var plantDataList: [PlantData]
}

struct PlantData {
    let name: String
    let location: String
    let feature: String
    let imageURL: URL?
    var image: UIImage?
}
