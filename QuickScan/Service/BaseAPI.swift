//
//  BaseAPI.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import Alamofire
import Foundation
import Moya

enum BaseAPI {
    case send(_ params: [String:String])
}

extension BaseAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://eq0lwb7e8e.execute-api.ap-northeast-2.amazonaws.com")!
    }
    
    var path: String {
        switch self {
        case .send:
            return "/default/android-dev-recruit"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .send:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .send(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
