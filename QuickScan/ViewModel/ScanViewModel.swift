//
//  ScanViewModel.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import AVFoundation
import Foundation
import RxCocoa
import RxSwift

protocol ScanViewModelType: SceneHelper {
    var scanResultInput: PublishSubject<AVMetadataMachineReadableCodeObject> { get }
    var connectionInput: PublishSubject<AVCaptureConnection> { get }
}

class ScanViewModel: ScanViewModelType {
    
    let scanResultInput: PublishSubject<AVMetadataMachineReadableCodeObject>
    let connectionInput: PublishSubject<AVCaptureConnection>
    var disposeBag = DisposeBag()
    
    var mainViewModel: MainViewModelType?
    
    init() {
        connectionInput = PublishSubject<AVCaptureConnection>()
        scanResultInput = PublishSubject<AVMetadataMachineReadableCodeObject>()
        scanResultInput
            .map { $0.stringValue } 
            .take(1)
            .delay(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.didScan($0)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: Scene
extension ScanViewModel {
    func didScan(_ result: String?) {
        mainViewModel?.scanResultInput.onNext(result)
        SceneCoordinator.sharedInstance.dismiss()
    }
}
