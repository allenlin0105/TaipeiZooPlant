//
//  DataMapper.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import UIKit

class DataMapper {
    static func mapTextData(data: Data) -> [PlantData] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DecodedPlantModel.self, from: data)
            let responseResult = decodedData.result.results
            var usableResult: [PlantData] = []
            responseResult.forEach { data in
                usableResult.append(PlantData(name: data.F_Name_Ch, location: data.F_Location, feature: data.F_Feature, imageURL: URL(string: data.F_Pic01_URL) ?? nil, image: nil))
            }
            return usableResult
        } catch {
            return []
        }
    }
    
    static func mapImageData(data: Data?) -> UIImage? {
        if let safeData = data {
            return UIImage(data: safeData)
        }
        return nil
    }
}
