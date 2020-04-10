//
//  SceneCoordinator.swift
//  QuickScan
//
//  Created by Taeheon Woo on 2020/04/10.
//  Copyright © 2020 newoo. All rights reserved.
//

import UIKit

class SceneCoordinator {
    fileprivate var currentViewController: UIViewController?
    
    static let sharedInstance = SceneCoordinator()
    
    required init() {
        currentViewController = nil
    }
    
    func hasCurrentViewController() -> Bool {
        return self.currentViewController == nil
    }
    
    func getCurrentViewController() -> UIViewController? {
        return currentViewController
    }
    
    func setCurrentViewController(_ viewController: UIViewController?) {
        currentViewController = viewController
    }
    
    func present(scene: Scene) {
        let viewController = scene.viewController()
        viewController.modalPresentationStyle = .fullScreen
        self.currentViewController?.present(viewController, animated: true, completion: nil)
        SceneCoordinator.sharedInstance.setCurrentViewController(viewController)
    }
    
    func dismiss() {
        currentViewController?.dismiss(animated: true, completion: nil)
    }
}
