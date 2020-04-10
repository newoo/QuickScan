//
//  ViewModel.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MainViewModelType: SceneHelper {
    // Output
    var scanResultOutput: BehaviorRelay<String> { get }
    var responseOutput: BehaviorRelay<String?> { get }
    
    // Input
    var scanResultInput: BehaviorSubject<String?> { get }
    
    func onScan()
}

class MainViewModel: MainViewModelType {
    
    let scanResultOutput: BehaviorRelay<String>
    let responseOutput: BehaviorRelay<String?>
    let scanResultInput: BehaviorSubject<String?>
    var disposeBag = DisposeBag()
    
    init() {
        scanResultOutput = BehaviorRelay<String>(value: "")
        responseOutput = BehaviorRelay<String?>(value: nil)
        scanResultInput = BehaviorSubject<String?>(value: nil)
        
        setBinding()
    }
    
}

// MARK: Scene
extension MainViewModel {
    func onScan() {
        let scanViewModel = ScanViewModel()
        scanViewModel.mainViewModel = self
        SceneCoordinator.sharedInstance.present(scene: .scanView(scanViewModel))
    }
}

// MARK: Binding
extension MainViewModel {
    func setBinding() {
        scanResultInput
            .subscribe(onNext: { [weak self] in
                guard let result = $0 else { return }
                self?.scanResultOutput.accept("<스캔결과>\n \(result)")
                self?.sendData(result)
            }).disposed(by: disposeBag)
    }
}

// MARK: Network
extension MainViewModel: SendDataDelegate {
    
    func sendData(_ value: String) {
        
        var params = basicParams
        params["value"] = value
        
        APIService.shard.rxRequest(.send(params))
            .map { return String(bytes: $0.data, encoding: .utf8) }
            .subscribe(onNext: { [weak self] in
                guard let response = $0 else { return }
                self?.responseOutput.accept("<통신결과>\n \(response)")
            }).disposed(by: disposeBag)
    }
}
