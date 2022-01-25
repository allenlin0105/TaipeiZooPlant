//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation

class ContentViewModel {
    var apiString: String
    var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var alreadyRequestOffset: Int = -1
    
    var dataLoader: DataLoaderProtocol
    var delegate: ContentProtocol?
    
    init (apiString: String, dataLoader: DataLoaderProtocol) {
        self.apiString = apiString
        self.dataLoader = dataLoader
    }
    
    func start() {
        let startOffset = 0
        if startOffset != alreadyRequestOffset {
            requestPlantData(at: startOffset)
        }
    }
    
    // MARK: - API Request
    func requestPlantData(at offset: Int) {
        alreadyRequestOffset = offset
        
        apiString = "\(apiString)&offset=\(offset)"
        let url = URL(string: apiString)!
        dataLoader.loadData(requestUrl: url) { result in
            switch result {
            case .success(let data):
                let newData = DataMapper.mapTextData(data: data)
                self.plantDataModel.plantDataList += newData
                break
            case .failure(_):
                break
            }
        }
    }
}
