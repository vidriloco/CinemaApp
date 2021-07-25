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

    let moviesCoordinator: MoviesCoordinator

    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController()
        self.moviesCoordinator = MoviesCoordinator(presenter: rootViewController)
    }

    func start() {
        window.rootViewController = rootViewController
        moviesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
