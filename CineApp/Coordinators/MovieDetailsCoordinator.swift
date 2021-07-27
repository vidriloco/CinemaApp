//
//  MovieDetailsCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import UIKit

class MovieDetailsCoordinator: Coordinator {

    private let presenter: UINavigationController

    private var movieDetailsViewController: MovieDetailsViewController?

    var movie: Movie?
    var genreList: [Genre]?

    private var movieStore = MovieLocalStore()

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.movieDetailsViewController = MovieDetailsViewController(movieStore: movieStore)
        self.movieDetailsViewController?.delegate = self
    }

    func start() {
        guard let movie = movie, let movieDetailsViewController = movieDetailsViewController else { return }
        let movieDetailsVM = MovieDetailsViewController.ViewModel(movie: movie, genresList: Genre.all)
        movieDetailsViewController.viewModel = movieDetailsVM
        
        presenter.pushViewController(movieDetailsViewController, animated: true)
    }
}

extension MovieDetailsCoordinator: MovieDetailsDelegate {
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
    }
}
