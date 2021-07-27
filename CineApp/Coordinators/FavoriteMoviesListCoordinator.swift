//
//  FavoriteMoviesListCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 27/07/2021.
//

import UIKit

class FavoriteMoviesListCoordinator: Coordinator {

    private let presenter: UINavigationController
    private var favoriteMoviesViewController: FavoriteMoviesListViewController?

    private var movieStore = MovieLocalStore()

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.favoriteMoviesViewController = FavoriteMoviesListViewController()
        self.favoriteMoviesViewController?.delegate = self
    }

    func start() {
        guard let favoriteMoviesViewController = favoriteMoviesViewController else {
            return
        }

        favoriteMoviesViewController.movieEntryList = movieStore.storedMovies ?? []
        favoriteMoviesViewController.delegate = self

        presenter.pushViewController(favoriteMoviesViewController, animated: true)
    }
}

extension FavoriteMoviesListCoordinator: FavoriteMoviesListDelegate {
    func didSelect(movieDetailsViewModel: MovieDetailsViewController.ViewModel, from controller: UIViewController) {
        let movieDetailsViewController = MovieDetailsViewController(movieStore: movieStore)
        movieDetailsViewController.delegate = self

        movieDetailsViewController.viewModel = movieDetailsViewModel
        controller.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

extension FavoriteMoviesListCoordinator: MovieDetailsDelegate {
    func updateMovieFavoriteStatus(_ movie: MovieDetailsViewController.ViewModel, from controller: UIViewController) {
        if movieStore.contains(movie) {

            movieStore.delete(movie)

            let viewController = UIAlertController(title: "Message",
                                                   message: "\(movie.title) was removed from your favorite movies",
                                                   preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            controller.present(viewController, animated: true, completion: nil)

        } else {
            movieStore.save(movie)

            let viewController = UIAlertController(title: "Message",
                                                   message: "\(movie.title) was saved to your favorite movies",
                                                   preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            controller.present(viewController, animated: true, completion: nil)
        }

        favoriteMoviesViewController?.movieEntryList = movieStore.storedMovies ?? []
    }
}
