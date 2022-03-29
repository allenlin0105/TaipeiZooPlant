//
//  ContentViewModelMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/3/1.
//

import Foundation
@testable import iOS_Exercise

class ContentViewModelMock: ContentViewModelProtocol {

    var plantDataModel: PlantModel = PlantModel(plantDataList: [])
    var requestPlantDataStatus: APIStatus = .success
    var dataCount: Int = 0
    var delegate: ContentViewProtocol?
    
    required init(dataLoader: DataLoaderProtocol, delegate: ContentViewProtocol) {
        self.delegate = delegate
    }
    
    func makeAPIString(offset: Int) -> String {
        return ""
    }
    
    func requestPlantData(at offset: Int) {
        dataCount = offset + 20
    }
    
    func requestImage(at index: Int) {
    }
}
