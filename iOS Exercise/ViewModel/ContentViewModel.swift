//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation

class ContentViewModel {
    
    private(set) var apiString: String = ""
    private(set) var alreadyRequestOffset: Int = -20
    private(set) var finishAllAccess: Bool = false
    private(set) var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var isWaitingData: Bool = false
    private var dataLoader: DataLoaderProtocol
    private let requestLimit = 20
    var delegate: ContentProtocol?
    
    init (dataLoader: DataLoaderProtocol) {
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
    
    private func handleResult(result: APIResultType) {
        switch result {
        case .success(let data):
            let newData = DataMapper.mapTextData(data: data)
            if newData.count == 0 {
                finishAllAccess = true
            } else {
                plantDataModel.plantDataList += newData
                alreadyRequestOffset += newData.count
            }
            break
        case .failure(_):
            break
        }
        isWaitingData = false
    }
    
    // MARK: - Image Request
    
    func requestImage(at index: Int) {
        // Prevent json data not loading back yet
        while index >= alreadyRequestOffset + requestLimit {}
        
        let target = plantDataModel.plantDataList[index]
        if target.imageURL == nil || target.image != nil { return }
        
        dataLoader.loadData(requestUrl: target.imageURL!) { [weak self] result in
            let strongSelf = self
            strongSelf?.handleImage(result: result, index: index)
        }
    }
    
    private func handleImage(result: APIResultType, index: Int) {
        switch result {
        case .success(let data):
            let image = DataMapper.mapImageData(data: data)
            plantDataModel.plantDataList[index].image = image
            break
        case .failure(_):
            break
        }
    }
}
