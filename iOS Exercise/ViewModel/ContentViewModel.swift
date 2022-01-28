//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import Foundation

class ContentViewModel {
    
    private(set) var apiString: String = ""
    private(set) var finishAllAccess: Bool = false
    private(set) var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var alreadyRequestOffset: Int = -20
    private var isWaitingData: Bool = false
    private var dataLoader: DataLoaderProtocol
    private let requestLimit = 20
    weak var delegate: ContentProtocol?
    
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
        guard let url = URL(string: apiString) else { return }
        fireAPI(url: url)
    }
    
    
    
    // MARK: - Image Request
    
    func requestImage(at index: Int) {
        // Prevent json data not loading back yet
        while index >= alreadyRequestOffset + requestLimit {}
        
        // Decides whether to fire API for image
        let target = plantDataModel.plantDataList[index]
        guard target.image == nil, let imageURL = target.imageURL else { return }
        
        // Fire API
        fireAPI(url: imageURL, imageIndex: index)
    }
}

// MARK: - Helpers

extension ContentViewModel {
    
    private func fireAPI(url: URL, imageIndex: Int? = nil) {
        dataLoader.loadData(requestUrl: url) { [weak self] result in
            guard let self = self else { return }
            if let index = imageIndex {
                self.handleImage(result: result, index: index)
            } else {
                self.handleJSON(result: result)
            }
        }
    }
    
    private func handleJSON(result: APIResultType) {
        switch result {
        case .success(let data):
            let newData = DataMapper.mapTextData(data: data)
            if newData.isEmpty {
                finishAllAccess = true
            } else {
                plantDataModel.plantDataList += newData
                alreadyRequestOffset += newData.count
                delegate?.updateContentTableView()
            }
        case .failure(_):
            break
        }
        isWaitingData = false
    }
    
    private func handleImage(result: APIResultType, index: Int) {
        switch result {
        case .success(let data):
            let image = DataMapper.mapImageData(data: data)
            plantDataModel.plantDataList[index].image = image
            delegate?.updateContentTableView()
        case .failure(_):
            break
        }
    }
}
