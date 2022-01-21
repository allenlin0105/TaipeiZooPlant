//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation
import Alamofire

class ContentViewModel {
    private var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var finishAllAccess: Bool = false
    private var notValidOffset: Int = -1
    var delegate: ContentProtocol?
    var dataLoader: DataLoader
    
    init (dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - Response to ContentViewController
    func getTotalDataSize() -> Int {
        return self.plantDataModel.plantDataList.count
    }
    
    func getCertainDataForTableViewCellWithIndex(index: Int) -> PlantData {
        let data = plantDataModel.plantDataList[index]
        if data.image == nil && data.imageURL != nil {
            dataLoader.loadData(requestUrl: data.imageURL!) { data in
                guard let image = DataMapper.mapImageData(data: data) else {
                    return
                }
                self.plantDataModel.plantDataList[index].image = image
                self.delegate?.updateContentTableView(plantContent: self.plantDataModel)
            }
        }
        return data
    }
    
    // MARK: - API Request
    func requestPlantData() {
        if finishAllAccess || plantDataModel.plantDataList.count == notValidOffset {
            return
        }
        
        notValidOffset = plantDataModel.plantDataList.count
        let parameters = [
            "scope": "resourceAquire",
            "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14",
            "limit": "20",
            "offset": String(plantDataModel.plantDataList.count)
        ]
        if let url = URLConstructor.getUrl(scheme: "https", host: "data.taipei", path: "/opendata/datalist/apiAccess", parameters: parameters) {
            dataLoader.loadData(requestUrl: url) { data in
                let newData = DataMapper.mapTextData(data: data)
                if newData.count == 0 {
                    self.finishAllAccess = true
                    return
                }
                self.plantDataModel.plantDataList += newData
                self.delegate?.updateContentTableView(plantContent: self.plantDataModel)
            }
        }
    }
}
