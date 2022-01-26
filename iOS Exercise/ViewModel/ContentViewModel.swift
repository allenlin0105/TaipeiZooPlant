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
    private(set) var finishAllAccess: Bool = false
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
        isWaitingData = true

        // Fire API
        let url = URL(string: apiString)!
        dataLoader.loadData(requestUrl: url) { [weak self] result in
            let strongSelf = self
            strongSelf?.handleResult(result: result)
        }
    }
    
    private func handleResult(result: Swift.Result<Data, APIError>) {
        switch result {
        case .success(let data):
            let newData = DataMapper.mapTextData(data: data)
            plantDataModel.plantDataList += newData
            alreadyRequestOffset += newData.count
            break
        case .failure(let error):
            switch error {
            case .requestFail:
                break
            case .decodeDataFail:
                finishAllAccess = true
                break
            }
            break
        }
        isWaitingData = false
    }
}
