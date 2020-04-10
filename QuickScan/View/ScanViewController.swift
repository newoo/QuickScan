//
//  ScanViewController.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import UIKit

class ScanViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        view.addSubview(btn)
        
        return btn
    }()
    
    lazy var scanCodeFrameView: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.red.cgColor
        vw.layer.borderWidth = 2
        view.addSubview(vw)
        view.bringSubviewToFront(vw)
        
        return vw
    }()
    
    var viewModel: ScanViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: ScanViewModelType = ScanViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ScanViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
        setScanSession()
    }

}

// MARK: UI
extension ScanViewController {
    func setUI() {
        view.backgroundColor = .black
        
        cancelBtn.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
    }
    
    private func setPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
        view.bringSubviewToFront(cancelBtn)
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        previewLayer?.frame = self.view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let connection =  self.previewLayer?.connection else { return }

        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        let previewLayerConnection : AVCaptureConnection = connection

        if previewLayerConnection.isVideoOrientationSupported {
            switch (orientation) {
            case .portrait:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                break
            case .landscapeRight:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                break
            case .landscapeLeft:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                break
            case .portraitUpsideDown:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                break
            default:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                break
            }
        }
        
    }
    
}

// MARK: Binding
extension ScanViewController {
    func setBinding() {
        
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel.setScene(self ?? UIViewController())
                }
            }).disposed(by: disposeBag)
        
        // MARK: Input
        cancelBtn.rx.tap
            .subscribe(onNext: {
                SceneCoordinator.sharedInstance.dismiss()
            }).disposed(by: disposeBag)
    }
}

// MARK: Scan
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate, ScanType {
    
    func setScanSession() {
        captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes

        } catch {
            print(error)
            return
        }
        
        setPreviewLayer()
        captureSession?.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard metadataObjects.count > 0, let metadataObj = metadataObjects.first
            as? AVMetadataMachineReadableCodeObject else {
                // No code is detcted
                scanCodeFrameView.frame = CGRect.zero
                return
        }
        
        let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
        scanCodeFrameView.frame = barCodeObject!.bounds
        
        captureSession?.stopRunning()
        viewModel.scanResultInput.onNext(metadataObj)
    }
}
