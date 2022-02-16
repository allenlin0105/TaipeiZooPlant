//
//  PlantData.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

struct PlantModel: Decodable {
    var plantDataList: [PlantData]
    
    enum ResultKey: CodingKey {
        case result
    }
    
    enum ResultsKey: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKey.self)
        let resultContainer = try container.nestedContainer(keyedBy: ResultsKey.self, forKey: .result)
        self.plantDataList = try resultContainer.decode([PlantData].self, forKey: .results)
    }
    
    init(plantDataList: [PlantData]) {
        self.plantDataList = plantDataList
    }
}

struct PlantData: Equatable, Decodable {
    let name: String
    let location: String
    let feature: String
    let imageURL: URL?
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case name = "F_Name_Ch"
        case location = "F_Location"
        case feature = "F_Feature"
        case imageURL = "F_Pic01_URL"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.location = try container.decode(String.self, forKey: .location)
        self.feature = try container.decode(String.self, forKey: .feature)
        let urlString = try container.decode(String.self, forKey: .imageURL)
        self.imageURL = URL(string: urlString)
    }
    
    init(name: String, location: String, feature: String, imageURL: URL?, image: UIImage?) {
        self.name = name
        self.location = location
        self.feature = feature
        self.imageURL = imageURL
        self.image = image
    }
}
