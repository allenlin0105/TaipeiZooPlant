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
    var dataLoader: DataLoaderProtocol
    var delegate: ContentProtocol?
    
    init (apiString: String, dataLoader: DataLoaderProtocol) {
        self.apiString = apiString
        self.dataLoader = dataLoader
    }
    
    func start() {
        requestPlantData(at: plantDataModel.plantDataList.count)
    }
    
    // MARK: - API Request
    func requestPlantData(at offset: Int) {
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
