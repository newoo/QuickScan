//
//  SceneHelper.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import UIKit

protocol SceneHelper {
    func setScene(_ viewController: UIViewController)
}

extension SceneHelper {
    func setScene(_ viewController: UIViewController) {
        guard SceneCoordinator.sharedInstance.getCurrentViewController()
            != viewController else { return }
        SceneCoordinator.sharedInstance.setCurrentViewController(viewController)
    }
}
