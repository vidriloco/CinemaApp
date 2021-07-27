//
//  RootCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 24/07/2021.
//

import UIKit
import MBProgressHUD

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
}

private extension RootCoordinator {
    func fetchGenreList() {
        displayLoadingIndicator()

        repository.getMovieGenres { [weak self] genres in
            Genre.all = genres
            self?.hideLoadingIndicator()
        } failure: { [weak self] _ in
            self?.hideLoadingIndicator()

            let alertViewControlller = UIAlertController(title: "We could not load the list of movie genres",
                                                         message: "Please check your connection and try again.",
                                                         preferredStyle: .alert)
            alertViewControlller.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
            alertViewControlller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                self?.fetchGenreList()
            }))
        }
    }
    
    func displayLoadingIndicator() {
        let localWindow = window
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: localWindow, animated: true)
        }
    }

    func hideLoadingIndicator() {
        let localWindow = window
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: localWindow, animated: true)
        }
    }
}
