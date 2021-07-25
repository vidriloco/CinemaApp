//
//  RootCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 24/07/2021.
//

import UIKit

protocol Coordinator {
    func start()
}

class RootCoordinator: Coordinator {

    let window: UIWindow
    let rootViewController: UINavigationController

    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController(rootViewController: HomeViewController())
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
