//
//  MovieDetailsViewController.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UITableViewController {

    enum MovieDetails {
        case image(url: URL?)
        case title(text: String)
        case description(text: String)
        case caption(text: String)
    }

    private var detailEntries = [MovieDetails]()

    private let movieTextIdentifier = String(describing: MovieTextViewCell.self)
    private let moviePosterIdentifier = String(describing: MoviePosterViewCell.self)

    public init() {
        super.init(nibName: nil, bundle: nil)

        let favoriteButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateMovieFavoriteState))
        self.navigationItem.rightBarButtonItem  = favoriteButton

        tableView.register(MovieTextViewCell.self, forCellReuseIdentifier: movieTextIdentifier)
        tableView.register(MoviePosterViewCell.self, forCellReuseIdentifier: moviePosterIdentifier)
        tableView.allowsSelection = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Movie Details"
    }

    @objc private func updateMovieFavoriteState() {
        
    }

    func configure(with movie: Movie, genres: [Genre]) {

        let movieGenres = genres.compactMap { movie.genreIds.contains($0.id) ? $0.name : nil }

        self.detailEntries = [
            .image(url: movie.url),
            .title(text: movie.title),
            .description(text: movie.overview),
            .caption(text: movie.releaseInfo),
            .caption(text: movie.ratingInfo),
            .caption(text: movieGenres.joined(separator: ", "))
        ]

        tableView.reloadData()
    }
}

extension MovieDetailsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = detailEntries[indexPath.row]

        var cell = UITableViewCell()

        if case let .image(url) = entry {
            if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: moviePosterIdentifier) as? MoviePosterViewCell {
                dequeuedCell.configureWithImage(from: url)
                cell = dequeuedCell
            }
        } else {
            if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: movieTextIdentifier) as? MovieTextViewCell {
                dequeuedCell.configureWith(entry)
                cell = dequeuedCell
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let entry = detailEntries[indexPath.row]

        switch entry {
        case .image:
            return Constants.imageHeight
        default:
            return UITableView.automaticDimension
        }
    }
}

extension MovieDetailsViewController {

    struct Constants {
        static let imageHeight: CGFloat = 400
    }

}
