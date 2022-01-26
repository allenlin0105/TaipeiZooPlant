//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation

class ContentViewModel {
    
    private(set) var apiString: String
    private(set) var alreadyRequestOffset: Int = -20
    private(set) var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var isWaitingData: Bool = false
    private var dataLoader: DataLoaderProtocol
    var delegate: ContentProtocol?
    
    init (apiString: String, dataLoader: DataLoaderProtocol) {
        self.apiString = apiString
        self.dataLoader = dataLoader
    }
    
    // MARK: - API Request
    
    func requestPlantData(at offset: Int) {
        // Waiting for callback return
        while isWaitingData {}
        
        // Check if it is duplicated request
        if offset == alreadyRequestOffset { return }
        
        // Setup property value for view model
        apiString = "\(GlobalStrings.baseAPIString)&offset=\(offset)"
        alreadyRequestOffset = offset
        isWaitingData = true

        // Fire API
        let url = URL(string: apiString)!
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
