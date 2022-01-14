//
//  DecodedPlantModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation

struct DecodedPlantModel: Decodable {
    let result: PlantResult
}

struct PlantResult: Decodable {
    let results: [DecodedPlantData]
}

struct DecodedPlantData: Decodable {
    let F_Name_Ch: String
    let F_Location: String
    let F_Feature: String
    let F_Pic01_URL: URL
}
