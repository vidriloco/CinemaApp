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

    private let window: UIWindow

    private let repository = MovieRepository()

    private var homeListCoordinator: HomeListCoordinator?

    private let rootViewController: UINavigationController

    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController()
        self.homeListCoordinator = HomeListCoordinator(presenter: rootViewController, repository: repository)
    }

    func start() {
        fetchGenreList()
        
        window.rootViewController = rootViewController
        homeListCoordinator?.start()
        window.makeKeyAndVisible()
    }

    func fetchGenreList() {
        repository.getMovieGenres { genres in
            Genre.all = genres
        } failure: { _ in
            let alertViewControlller = UIAlertController(title: "We could not load the list of movie genres",
                                                         message: "Please check your connection and try again.",
                                                         preferredStyle: .alert)
            alertViewControlller.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
            alertViewControlller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                self?.fetchGenreList()
            }))
        }
    }
}
