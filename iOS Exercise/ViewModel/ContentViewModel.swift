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
    
    var dataLoader: DataLoader
    
    init (dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
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
        let parameters = [
            "scope": "resourceAquire",
            "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14",
            "limit": "20",
            "offset": String(plantDataModel.plantDataList.count)
        ]
        if let url = dataLoader.urlConstructor(scheme: "https", host: "data.taipei", path: "/opendata/datalist/apiAccess", parameters: parameters) {
            dataLoader.loadData(requestUrl: url) { data in
                let newData = DataMapper.mapTextData(data: data)
                if newData.count == 0 {
                    self.plantDataModel.finishAllAccess = true
                    return
                }
                let startIndex = self.plantDataModel.plantDataList.count
                let endIndex = startIndex + newData.count
                self.plantDataModel.plantDataList += newData
                self.delegate?.updateContentTableView(plantContent: self.plantDataModel)
                self.requestImage(from: startIndex, to: endIndex)
            }
        }
    }
    
    func requestImage(from startIndex: Int, to endIndex: Int) {
        for i in startIndex..<endIndex {
            let data = self.plantDataModel.plantDataList[i]
            guard let url = data.imageURL else {
                continue
            }
            dataLoader.loadData(requestUrl: url) { data in
                guard let image = DataMapper.mapImageData(data: data) else {
                    return
                }
                self.plantDataModel.plantDataList[i].image = image
                self.delegate?.updateContentTableView(plantContent: self.plantDataModel)
            }
        }
    }
}
