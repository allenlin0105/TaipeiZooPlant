//
//  ContentViewModel.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

class ContentViewModel: ContentViewModelProtocol {    

    var finishAllAccess: Bool = false
    var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    var requestPlantDataStatus: APIStatus = .success
    var dataCount: Int {
        return plantDataModel.plantDataList.count
    }
    weak var delegate: ContentViewProtocol?
    private var alreadyRequestOffset: Int = -20
    private var dataLoader: DataLoaderProtocol
    
    init (dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - API Request
    
    func makeAPIString(offset: Int) -> String {
        return "\(ContentStrings.baseAPIString)&offset=\(offset)"
    }
    
    func requestPlantData(at offset: Int) {
        // Check if it is duplicated request
        if requestPlantDataStatus == .loading || offset == alreadyRequestOffset { return }
        
        // Setup property value for view model
        let apiString = makeAPIString(offset: offset)
        requestPlantDataStatus = .loading

        // Fire API
        guard let url = URL(string: apiString) else { return }
        dataLoader.loadData(requestURL: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.handleSuccessJSONSituation(data: data)
            case .failure(_):
                self.requestPlantDataStatus = .requestFail
            }
            self.delegate?.reloadContentTableView()
        }
    }
    
    private func handleSuccessJSONSituation(data: Data) {
        guard let newData = DataMapper.mapTextData(data: data) else {
            self.requestPlantDataStatus = .decodeFail
            return
        }
        if newData.isEmpty {
            finishAllAccess = true
            requestPlantDataStatus = .noData
        } else {
            plantDataModel.plantDataList += newData
            alreadyRequestOffset += newData.count
            requestPlantDataStatus = .success
        }
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
                self.delegate?.reloadContentTableView()
            case .failure(_):
                break
            }
        }
    }
}
