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
        let movieDetails = MovieDetailsViewController()

        repository.getMovieGenres { genres in
            DispatchQueue.main.async {
                movieDetails.configure(with: movie, genres: genres)
            }
        } failure: { error in
            print(error)
        }

        controller.navigationController?.pushViewController(movieDetails, animated: true)
    }
    
}
