//
//  APIServiceTests.swift
//  QuickScanTests
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import Moya
import RxBlocking 
import RxSwift
import RxTest
import XCTest
@testable import QuickScan

class APIServiceTests: XCTestCase {
    
    var service: APIService!
    var disposeBag: DisposeBag!
    var params: [String:String] = [:]

    override func setUpWithError() throws {
        service = APIService.shard
        disposeBag = DisposeBag()
        params["value"] = "value"
        params["name"] = "name"
        params["phone"] = "010-1234-1234"
    }

    override func tearDownWithError() throws {
        disposeBag = DisposeBag()
    }

    func testStatusCode() throws {
        var result: Response!
        let expect = expectation(description: #function)
        
        service.rxRequest(.send(params))
            .subscribe(onNext: {
                result = $0
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            print("CHK", String(bytes: result.data, encoding: .utf8))
            
            XCTAssertEqual(200, result.statusCode)
        }
    }
    
    func testResponseIsOK() {
        var result: Response!
        let expect = expectation(description: #function)
        
        service.rxRequest(.send(params))
            .subscribe(onNext: {
                result = $0
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            XCTAssertEqual("OK", String(bytes: result.data, encoding: .utf8))
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
