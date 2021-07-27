//
//  HomeListCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit
import MBProgressHUD

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

        displayLoadingIndicator()
        repository.getMoviesNowPlaying { [weak self] movies in

            self?.nowPlayingMoviesViewController.movies = movies
            self?.hideLoadingIndicator()
        } failure: { [weak self] error in
            self?.hideLoadingIndicator()
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

        displayLoadingIndicator()
        repository.getPopularMovies { [weak self] movies in

            self?.popularMoviesViewController.movies = movies
            self?.hideLoadingIndicator()
        } failure: { [weak self] error in
            self?.hideLoadingIndicator()
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

private extension HomeListCoordinator {
    func displayLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.presenter.view else { return }

            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.presenter.view else { return }

            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
