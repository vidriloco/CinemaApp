//
//  MovieDetailsCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import UIKit

class MovieDetailsCoordinator: Coordinator {

    private let presenter: UINavigationController
    let movieDetailsViewController: MovieDetailsViewController
    var movie: Movie?
    var genreList: [Genre]?

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.movieDetailsViewController = MovieDetailsViewController()
        self.movieDetailsViewController.delegate = self
    }

    func start() {
        guard let movie = movie else { return }
        let movieDetailsVM = MovieDetailsViewController.MovieDetailsViewModel(movie: movie, genresList: Genre.all)
        movieDetailsViewController.viewModel = movieDetailsVM
        
        presenter.pushViewController(movieDetailsViewController, animated: true)
    }
}

extension MovieDetailsCoordinator: MovieDetailsDelegate {
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
    }
}
