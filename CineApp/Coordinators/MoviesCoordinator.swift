//
//  MoviesCoordinator.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit

class MoviesCoordinator: Coordinator {
    private let presenter: UINavigationController

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let moviesListViewController = MovieListViewController()

        let nowPlayingList = [
            Movie(title: "Brave", image: UIImage(named: "brave")!, genres: [Movie.Genre(name: "Horror", id: 1), Movie.Genre(name: "Action", id: 2)], releaseDate: Date(), popularity: 2, overview: "Lorem ipsum estu masaquata kinder Lorem ipsum estu masaquata kinder"),
            Movie(title: "Toy Story", image: UIImage(named: "buzz")!),
            Movie(title: "Finding Nemo", image: UIImage(named: "nemo")!)
        ]

        let nowPlayingVC =  MovieCollectionViewController(with: nowPlayingList)
        nowPlayingVC.delegate = self

        let popularList = [
            Movie(title: "Monsters INC", image: UIImage(named: "monsters")!),
            Movie(title: "Wall-E", image: UIImage(named: "wall-e")!)
        ]

        let popularVC = MovieCollectionViewController(with: popularList)
        popularVC.delegate = self

        moviesListViewController.configure(viewControllers: [nowPlayingVC, popularVC])
        presenter.pushViewController(moviesListViewController, animated: true)
    }

}

extension MoviesCoordinator : MovieDetailsDelegate {

    func didSelect(movie: Movie, from controller: UIViewController) {
        let vc = MovieDetailsViewController(with: movie)
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
}
