//
//  FavoriteMoviesListCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 27/07/2021.
//

import UIKit

class FavoriteMoviesListCoordinator: Coordinator {

    private let presenter: UINavigationController
    private let favoriteMoviesViewController: FavoriteMoviesListViewController

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.favoriteMoviesViewController = FavoriteMoviesListViewController()
        self.favoriteMoviesViewController.delegate = self
    }

    func start() {
        favoriteMoviesViewController.movieEntryList = MovieLocalStore.shared.storedMovies ?? []
        favoriteMoviesViewController.delegate = self

        presenter.pushViewController(favoriteMoviesViewController, animated: true)
    }
}

extension FavoriteMoviesListCoordinator: FavoriteMoviesListDelegate {
    func didSelect(movieDetailsViewModel: MovieDetailsViewController.MovieDetailsViewModel, from controller: UIViewController) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.delegate = self

        movieDetailsViewController.viewModel = movieDetailsViewModel
        controller.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

extension FavoriteMoviesListCoordinator: MovieDetailsDelegate {
    func updateMovieFavoriteStatus(_ movie: MovieDetailsViewController.MovieDetailsViewModel, from controller: UIViewController) {
        if MovieLocalStore.shared.contains(movie) {

            MovieLocalStore.shared.delete(movie)

            let viewController = UIAlertController(title: "Message",
                                                   message: "\(movie.title) was removed from your favorite movies",
                                                   preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            controller.present(viewController, animated: true, completion: nil)

        } else {
            MovieLocalStore.shared.save(movie)

            let viewController = UIAlertController(title: "Message",
                                                   message: "\(movie.title) was saved to your favorite movies",
                                                   preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            controller.present(viewController, animated: true, completion: nil)
        }

        favoriteMoviesViewController.movieEntryList = MovieLocalStore.shared.storedMovies ?? []
    }
}
