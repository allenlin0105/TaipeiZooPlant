//
//  ContentViewModelProtocol.swift
//  iOS Exercise
//
//  Created by allen on 2022/2/16.
//

import Foundation

protocol ContentViewModelProtocol {
    init(dataLoader: DataLoaderProtocol, delegate: ContentViewProtocol)
    
    var plantDataModel: PlantModel { get }
    var requestPlantDataStatus: APIStatus { get }
    var dataCount: Int { get }
    var delegate: ContentViewProtocol? { get set }
    
    func makeAPIString(offset: Int) -> String
    func requestPlantData(at offset: Int)
    func requestImage(at index: Int)
}
