//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

class ContentViewModel {
    private var url = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=0"
    var delegate: ContentProtocol?
    private var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    
    func requestPlantData() {
        if let url = URL(string: self.url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                let content = self.parseJSON(data)
                self.saveNewContent(content)
                self.delegate?.updateContentTableView(plantContent: self.plantDataModel, updateKey: "content")
                self.requestImage()
            }
            task.resume()
        }
    }
    
    func saveNewContent(_ newContent: [PlantData]) {
        self.plantDataModel.plantDataList += newContent
    }
    
    func requestImage() {
        for i in 0..<self.plantDataModel.plantDataList.count {
            let data = self.plantDataModel.plantDataList[i]
            if data.image == nil {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: data.imageURL) { data, response, error in
                    guard let safeData = data else {
                        return
                    }
                    self.plantDataModel.plantDataList[i].image = UIImage(data: safeData)
                    self.delegate?.updateContentTableView(plantContent: self.plantDataModel, updateKey: "img")
                }
                task.resume()
            }
        }
    }
    
    func getTotalDataSize() -> Int {
        return self.plantDataModel.plantDataList.count
    }
    
    func getCertainDataForTableViewCellWithIndex(index: Int) -> PlantData {
        return self.plantDataModel.plantDataList[index]
    }
    
    func parseJSON(_ data: Data?) -> [PlantData] {
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                let decodedData = try decoder.decode(DecodedPlantModel.self, from: safeData)
                let responseResult = decodedData.result.results
                return changeDecodedDataIntoUsableData(responseResult)
            } catch {
                return []
            }
        }
        return []
    }
    
    func changeDecodedDataIntoUsableData(_ result: [DecodedPlantData]) -> [PlantData] {
        var usableResult: [PlantData] = []
        result.forEach { data in
            usableResult.append(PlantData(name: data.F_Name_Ch, location: data.F_Location, feature: data.F_Feature, imageURL: data.F_Pic01_URL, image: nil))
        }
        
        return usableResult
    }
}
