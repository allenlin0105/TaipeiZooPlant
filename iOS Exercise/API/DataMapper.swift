//
//  DataMapper.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation

class DataMapper {
    
    static func mapTextData(data: Data) -> [PlantData] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DecodedPlantModel.self, from: data)
            let responseResult = decodedData.result.results
            let usableResult = responseResult.map {
                PlantData(name: $0.F_Name_Ch,
                          location: $0.F_Location,
                          feature: $0.F_Feature,
                          imageURL: URL(string: $0.F_Pic01_URL) ?? nil,
                          image: nil)
            }
            return usableResult
        } catch {
            return []
        }
    }
}
