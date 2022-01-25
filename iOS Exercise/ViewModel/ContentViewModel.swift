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
    var alreadyRequestOffset: Int = -20
    private var isWaitingData: Bool = false
    
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
        print("offset: \(offset), already: \(alreadyRequestOffset)")
        while isWaitingData {}
        
        alreadyRequestOffset = offset
        
        apiString = "\(GlobalStrings.baseAPIString)&offset=\(offset)"
        let url = URL(string: apiString)!
        isWaitingData = true
            
        dataLoader.loadData(requestUrl: url) { result in
            switch result {
            case .success(let data):
                let newData = DataMapper.mapTextData(data: data)
                self.plantDataModel.plantDataList += newData
                self.isWaitingData = false
                break
            case .failure(let error):
                if error == .requestFail {
                    self.alreadyRequestOffset = offset - 20
                }
                self.isWaitingData = false
                break
            }
        }
    }
}
