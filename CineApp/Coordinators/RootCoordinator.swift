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

    let homeListCoordinator: HomeListCoordinator

    let movieRepository = MovieRepository()

    init(window: UIWindow) {
        self.window = window

        self.rootViewController = UINavigationController()
        self.homeListCoordinator = HomeListCoordinator(presenter: rootViewController, repository: movieRepository)
    }

    func start() {
        fetchGenreList()
        
        window.rootViewController = rootViewController
        homeListCoordinator.start()
        window.makeKeyAndVisible()
    }

    func fetchGenreList() {
        movieRepository.getMovieGenres { genres in
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
