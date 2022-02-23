//
//  DataLoaderMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
import XCTest
@testable import iOS_Exercise

class DataLoaderMock: DataLoaderProtocol {
    
    var runLoadData: Bool = true
    var apiStatus: APIStatus = .success
    var expectations: [XCTestExpectation]?
    private var apiIndex = 0
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        if !runLoadData { return }
        
        switch apiStatus {
        case .loading:
            break
        case .success:
            let data = """
                {
                   "result":{
                      "results":[
                         {
                            "F_Location":"臺灣動物區；蟲蟲探索谷；熱帶雨林區；鳥園；兩棲爬蟲動物館",
                            "F_Pic01_URL":"http://www.zoo.gov.tw/iTAP/04_Plant/Lythraceae/subcostata/subcostata_1.jpg",
                            "F_Name_Ch":"九芎",
                            "F_Feature":"紅褐色的樹皮剝落後呈灰白色，樹幹光滑堅硬。葉有極短的柄，長橢圓形或卵形，全綠，葉片兩端尖，秋冬轉紅。夏季6～8月開花，花冠白色，花數甚多而密生於枝端，花為圓錐花序頂生，花瓣有長柄，邊緣皺曲像衣裙的花邊花絲長短不一。果實為蒴果，橢圓形約6-8公厘，種子有翅。"
                         }
                      ]
                   }
                }
            """.data(using: .utf8)!
            completionHandler(.success(data))
        case .noData:
            let data = "{\"result\":{\"results\":[]}}".data(using: .utf8)!
            completionHandler(.success(data))
        case .requestFail:
            let error = NSError(domain: "TestingError", code: 1, userInfo: nil)
            completionHandler(.failure(error))
        case .decodeFail:
            let data = "{results: []}".data(using: .utf8)!
            completionHandler(.success(data))
        }
        expectations?[apiIndex].fulfill()
    }
}

// MARK: - Private Extension of URL

private extension URL {
    
    func getQueryValue(for key: String) -> String {
        let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems
        let value = queryItems?.first(where: { $0.name == key })?.value
        return value ?? ""
    }
}
