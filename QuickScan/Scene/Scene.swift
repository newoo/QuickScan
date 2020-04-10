//
//  File.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import UIKit

enum Scene {
    case scanView(ScanViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .scanView(let viewModel):
            let viewController = ScanViewController()
            viewController.viewModel = viewModel
            
            return viewController
        }
    }
}
