//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit
import Alamofire

class ContentViewModel {
    var delegate: ContentProtocol?
    private var plantDataModel: PlantModel = PlantModel(plantDataList: [], finishAllAccess: false)
    private var notValidOffset: Int = -1
    
    // MARK: - Response to ContentViewController
    func getTotalDataSize() -> Int {
        return self.plantDataModel.plantDataList.count
    }
    
    func getCertainDataForTableViewCellWithIndex(index: Int) -> PlantData {
        return self.plantDataModel.plantDataList[index]
    }
    
    // MARK: - API Request
    func requestPlantData() {
        if plantDataModel.finishAllAccess || plantDataModel.plantDataList.count == notValidOffset {
            return
        }
        
        notValidOffset = plantDataModel.plantDataList.count
        let requestDataCount = 20
        let requestUrl = "https://data.taipei/opendata/datalist/apiAccess"
        let parameters = [
            "scope": "resourceAquire",
            "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14",
            "limit": String(requestDataCount),
            "offset": String(self.plantDataModel.plantDataList.count)
        ]
        AF.request(requestUrl, parameters: parameters).responseData { response in
            switch response.result {
            case .success:
                let newData = self.parseJSON(response.data)
                if newData.count == 0 {
                    self.plantDataModel.finishAllAccess = true
                    break
                }
                let startIndex = self.plantDataModel.plantDataList.count
                let endIndex = startIndex + requestDataCount
                self.plantDataModel.plantDataList += newData
                self.delegate?.updateContentTableView(plantContent: self.plantDataModel)
                self.requestImage(from: startIndex, to: endIndex)
                break
            case .failure:
                break
            }
        }
    }
    
    func requestImage(from startIndex: Int, to endIndex: Int) {
        for i in startIndex..<endIndex {
            let data = self.plantDataModel.plantDataList[i]
            guard let safeImageUrl = data.imageURL else {
                continue
            }
            AF.request(safeImageUrl).responseData { response in
                switch response.result {
                case .success:
                    guard let safeData = response.data else {
                        return
                    }
                    self.plantDataModel.plantDataList[i].image = UIImage(data: safeData)
                    self.delegate?.updateContentTableView(plantContent: self.plantDataModel)
                    break
                case .failure:
                    break
                }
            }
        }
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
            usableResult.append(PlantData(name: data.F_Name_Ch, location: data.F_Location, feature: data.F_Feature, imageURL: URL(string: data.F_Pic01_URL) ?? nil, image: nil))
        }
        
        return usableResult
    }
}
