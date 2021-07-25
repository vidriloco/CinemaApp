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

    let movieRepository = MovieRepository()

    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController()
        self.moviesCoordinator = MoviesCoordinator(presenter: rootViewController, repository: movieRepository)
    }

    func start() {
        window.rootViewController = rootViewController
        moviesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
