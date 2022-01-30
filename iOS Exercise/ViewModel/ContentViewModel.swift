//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

class ContentViewModel {
    
    private(set) var apiString: String = ""
    private(set) var finishAllAccess: Bool = false
    private(set) var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var alreadyRequestOffset: Int = -20
    private var isWaitingData: Bool = false
    private var dataLoader: DataLoaderProtocol
    weak var delegate: ContentProtocol?
    
    init (dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - API Request
    
    func requestPlantData(at offset: Int) {
        // Check if it is duplicated request
        if isWaitingData || offset == alreadyRequestOffset { return }
        
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
        guard index < plantDataModel.plantDataList.count else { return }
        
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
        dataLoader.loadData(requestURL: url) { [weak self] result in
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
            guard let newData = newData else { return }
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
            plantDataModel.plantDataList[index].image = UIImage(data: data)
            delegate?.updateContentTableView()
        case .failure(_):
            break
        }
    }
}
