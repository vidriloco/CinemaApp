//
//  HomeListCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit

class HomeListCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let repository: MovieRepository

    private let movieDetailsCoordinator: MovieDetailsCoordinator?
    private let favoriteMoviesCoordinator: FavoriteMoviesListCoordinator?

    private var nowPlayingMoviesViewController = MovieCollectionViewController()
    private var popularMoviesViewController = MovieCollectionViewController()

    init(presenter: UINavigationController, repository: MovieRepository) {
        self.presenter = presenter
        self.repository = repository
        
        self.movieDetailsCoordinator = MovieDetailsCoordinator(presenter: presenter)
        self.favoriteMoviesCoordinator = FavoriteMoviesListCoordinator(presenter: presenter)
    }

    func start() {
        let homeListViewController = HomeListViewController()
        homeListViewController.delegate = self

        buildNowPlayingMoviesViewController()
        buildPopularMoviesViewController()

        homeListViewController.configure(viewControllers: [nowPlayingMoviesViewController, popularMoviesViewController])
        presenter.pushViewController(homeListViewController, animated: true)
    }

    private func buildNowPlayingMoviesViewController() {
        nowPlayingMoviesViewController.delegate = self

        repository.getMoviesNowPlaying { [weak self] movies in

            self?.nowPlayingMoviesViewController.movies = movies

        } failure: { error in
            let alertViewControlller = UIAlertController(title: "Ooops",
                                                         message: "We could not load the list of movies now being played",
                                                         preferredStyle: .alert)
            alertViewControlller.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
            alertViewControlller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                self?.buildNowPlayingMoviesViewController()
            }))

        }
    }

    private func buildPopularMoviesViewController() {
        popularMoviesViewController.delegate = self

        repository.getPopularMovies { [weak self] movies in

            self?.popularMoviesViewController.movies = movies

        } failure: { error in
            let alertViewControlller = UIAlertController(title: "Ooops",
                                                         message: "We could not load the list of popular movies",
                                                         preferredStyle: .alert)
            alertViewControlller.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
            alertViewControlller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                self?.buildPopularMoviesViewController()
            }))

        }
    }
}

extension HomeListCoordinator : MovieListDelegate {

    func didSelect(movie: Movie, from controller: UIViewController) {
        movieDetailsCoordinator?.movie = movie
        movieDetailsCoordinator?.start()
    }
    
}

extension HomeListCoordinator: HomeListViewDelegate {

    func willDisplayFavoriteMovies(from controller: UIViewController) {
        favoriteMoviesCoordinator?.start()
    }
    
}
