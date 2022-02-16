//
//  DataMapper.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation

class DataMapper {
    
    static func mapTextData(data: Data) -> [PlantData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PlantModel.self, from: data)
            return decodedData.plantDataList
        } catch {
            return nil
        }
    }
}
