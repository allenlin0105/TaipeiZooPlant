//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

class ContentViewModel {
    
    private(set) var finishAllAccess: Bool = false
    private(set) var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    private var alreadyRequestOffset: Int = -20
    private var isWaitingData: Bool = false
    private var dataLoader: DataLoaderProtocol
    weak var delegate: ContentViewProtocol?
    var dataCount: Int {
        return plantDataModel.plantDataList.count
    }
    
    init (dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - API Request
    
    func requestPlantData(at offset: Int) {
        // Check if it is duplicated request
        if isWaitingData || offset == alreadyRequestOffset { return }
        
        // Setup property value for view model
        let apiString = makeAPIString(offset: offset)
        isWaitingData = true

        // Fire API
        guard let url = URL(string: apiString) else { return }
        dataLoader.loadData(requestURL: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let newData = DataMapper.mapTextData(data: data) else { return }
                if newData.isEmpty {
                    self.finishAllAccess = true
                } else {
                    self.plantDataModel.plantDataList += newData
                    self.alreadyRequestOffset += newData.count
                    self.delegate?.updateContentTableView()
                }
            case .failure(_):
                break
            }
            self.isWaitingData = false
        }
    }
    
    func makeAPIString(offset: Int) -> String {
        return "\(GlobalStrings.baseAPIString)&offset=\(offset)"
    }
    
    // MARK: - Image Request
    
    func requestImage(at index: Int) {
        // Prevent json data not loading back yet
        guard index < plantDataModel.plantDataList.count else { return }
        
        // Decides whether to fire API for image
        let target = plantDataModel.plantDataList[index]
        guard target.image == nil, let imageURL = target.imageURL else { return }
        
        // Fire API
        dataLoader.loadData(requestURL: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.plantDataModel.plantDataList[index].image = UIImage(data: data)
                self.delegate?.updateContentTableView()
            case .failure(_):
                break
            }
        }
    }
}
