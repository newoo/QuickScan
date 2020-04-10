//
//  APIService.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

class APIService {
    static let shard = APIService()
    
    let provider: MoyaProvider<BaseAPI>
    var disposeBag = DisposeBag()
    
    private init() {
        provider = MoyaProvider<BaseAPI>()
    }
    
    func rxRequest(_ task: BaseAPI) -> Observable<Response> {
        provider.rx.request(task)
            .asObservable()
    }
}
