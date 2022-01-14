//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation

class ContentViewModel {
    private var url = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=3&offset=0"
    var delegate: ContentProtocol?
    
    func requestPlantData() {
        if let url = URL(string: self.url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                let content = self.parseJSON(data)
                guard let safeContent = content else {
                    return
                }
                self.delegate?.updateContentTableView(plantContent: safeContent)
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data?) -> PlantModel? {
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                let decodedData = try decoder.decode(DecodedPlantModel.self, from: safeData)
                let responseResult = decodedData.result.results
                return changeDecodedDataIntoUsableData(responseResult)
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func changeDecodedDataIntoUsableData(_ result: [DecodedPlantData]) -> PlantModel {
        var changedResultList: [PlantData] = []
        result.forEach { data in
            changedResultList.append(PlantData(name: data.F_Name_Ch, location: data.F_Location, feature: data.F_Feature, imageURL: data.F_Pic01_URL))
        }
        
        let usable_result = PlantModel(plantResultList: changedResultList)
        return usable_result
    }
}
