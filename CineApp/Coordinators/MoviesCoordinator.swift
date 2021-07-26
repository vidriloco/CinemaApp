//
//  MoviesCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit

class MoviesCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let repository: MovieRepository

    init(presenter: UINavigationController, repository: MovieRepository) {
        self.presenter = presenter
        self.repository = repository
    }

    func start() {
        let moviesListViewController = MovieListViewController()
        moviesListViewController.delegate = self

        let nowPlayingVC =  MovieCollectionViewController()
        nowPlayingVC.delegate = self

        repository.getMoviesNowPlaying { movies in
            nowPlayingVC.movies = movies
        } failure: { error in
            print(error)
        }

        let popularVC = MovieCollectionViewController()
        popularVC.delegate = self

        repository.getPopularMovies { movies in
            popularVC.movies = movies
        } failure: { error in
            print(error)
        }

        moviesListViewController.configure(viewControllers: [nowPlayingVC, popularVC])
        presenter.pushViewController(moviesListViewController, animated: true)
    }

}

extension MoviesCoordinator : MovieListDelegate {

    func didSelect(movie: Movie, from controller: UIViewController) {
        let movieDetailsViewController = MovieDetailsViewController()

        movieDetailsViewController.delegate = self

        repository.getMovieGenres { genres in
            DispatchQueue.main.async {
                let movieDetailsVM = MovieDetailsViewController.MovieDetailsViewModel(movie: movie, genresList: genres)
                
                movieDetailsViewController.viewModel = movieDetailsVM
            }
        } failure: { error in
            print(error)
        }

        controller.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
}

extension MoviesCoordinator : MovieDetailsDelegate {
    func updateMovieFavoriteStatus(_ movie: MovieDetailsViewController.MovieDetailsViewModel, from controller: UIViewController) {
        if MovieLocalStore.shared.contains(movie) {

            MovieLocalStore.shared.delete(movie)

            let viewController = UIAlertController(title: "Action",
                                                   message: "\(movie.title) was removed from your favorite movies",
                                                   preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            controller.present(viewController, animated: true, completion: nil)

        } else {
            MovieLocalStore.shared.save(movie)

            let viewController = UIAlertController(title: "Action",
                                                   message: "\(movie.title) was saved to your favorite movies",
                                                   preferredStyle: .alert)
            viewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            controller.present(viewController, animated: true, completion: nil)
        }
    }

}

extension MoviesCoordinator: HomeViewDelegate {
    func willDisplayFavoriteMovies(from controller: UIViewController) {
        guard let movies = MovieLocalStore.shared.storedMovies else {
            return
        }

        let favMoviesListViewController = FavoriteMoviesListViewController()
        favMoviesListViewController.movieEntryList = movies
        favMoviesListViewController.delegate = self

        controller.navigationController?.pushViewController(favMoviesListViewController, animated: true)
    }
}

extension MoviesCoordinator: FavoriteMoviesListDelegate {
    func didSelect(movieDetailsViewModel: MovieDetailsViewController.MovieDetailsViewModel, from controller: UIViewController) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.delegate = self

        movieDetailsViewController.viewModel = movieDetailsViewModel
        controller.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
