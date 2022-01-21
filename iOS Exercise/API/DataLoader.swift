//
//  DataLoader.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/20.
//

import Foundation
import Alamofire

class DataLoader {
    func loadData(requestUrl: URL, completionHandler: @escaping ((Data?) -> Void)) {
        AF.request(requestUrl).responseData { response in
            switch response.result {
            case .success:
                completionHandler(response.data)
            case .failure:
                completionHandler(nil)
            }
        }
    }
}
