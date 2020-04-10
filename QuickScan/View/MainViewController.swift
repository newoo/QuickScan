//
//  ViewController.swift
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

class MainViewController: UIViewController {
    
    var viewModel: MainViewModelType
    var disposeBag = DisposeBag()
    
    lazy var scanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("스캔하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        view.addSubview(btn)
        
        return btn
    }()
    
    lazy var scanResultLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        view.addSubview(lbl)
        
        return lbl
    }()
    
    lazy var responseLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        view.addSubview(lbl)
        
        return lbl
    }()
    
    init(viewModel: MainViewModelType = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = MainViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBinding()
    }
    
}

// MARK: UI
extension MainViewController {
    func setUI() {
        view.backgroundColor = .black
        
        scanBtn.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        scanResultLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scanBtn.snp.bottom).offset(88)
        }
        
        responseLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scanResultLabel.snp.bottom).offset(88)
        }
    }
}

// MARK: Binding
extension MainViewController {
    func setBinding() {
        // MARK: Scene
        self.rx.isVisible
            .subscribe(onNext: { [weak self] in
                if $0 { self?.viewModel.setScene(self ?? UIViewController()) }
            })
            .disposed(by: disposeBag)
        
        // MARK: Output
        scanBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onScan()
            }).disposed(by: disposeBag)
        
        // MARK: Input
        viewModel.scanResultOutput
            .asDriver()
            .drive(scanResultLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.responseOutput
            .asDriver()
            .drive(responseLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


