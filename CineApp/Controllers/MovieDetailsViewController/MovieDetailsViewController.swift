//
//  MovieDetailsViewController.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit
import SDWebImage

protocol MovieDetailsDelegate {
    func updateMovieFavoriteStatus(_ movie: MovieDetailsViewController.ViewModel, from controller: UIViewController)
}

class MovieDetailsViewController: UITableViewController {

    public var delegate: MovieDetailsDelegate?

    enum MovieDetailEntries {
        case image(url: URL?)
        case title(text: String)
        case description(text: String)
        case caption(text: String)
    }

    private var detailEntries = [MovieDetailEntries]()
    private let movieStore: MovieLocalStore

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(with: viewModel)
        }
    }

    private let movieTextIdentifier = String(describing: MovieTextViewCell.self)
    private let moviePosterIdentifier = String(describing: MoviePosterViewCell.self)

    public init(movieStore: MovieLocalStore) {
        self.movieStore = movieStore

        super.init(nibName: nil, bundle: nil)
        title = "Movie Details"

        tableView.register(MovieTextViewCell.self, forCellReuseIdentifier: movieTextIdentifier)
        tableView.register(MoviePosterViewCell.self, forCellReuseIdentifier: moviePosterIdentifier)
        tableView.allowsSelection = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationItems()
    }

    @objc private func updateMovieFavoriteStatus() {
        guard let viewModel = viewModel else { return }
        
        delegate?.updateMovieFavoriteStatus(viewModel, from: self)
        updateNavigationItems()
    }

    private func updateNavigationItems() {
        guard let movieDetails = viewModel else { return }

        let title = movieStore.contains(movieDetails) ? "Unfavorite" : "Favorite"

        let favoriteButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(updateMovieFavoriteStatus))
        self.navigationItem.rightBarButtonItem  = favoriteButton
    }

    private func configure(with viewModel: ViewModel) {

        self.detailEntries = [
            .image(url: viewModel.imageURL),
            .title(text: viewModel.title),
            .description(text: viewModel.description),
            .caption(text: viewModel.releaseInfo),
            .caption(text: viewModel.ratingInfo),
            .caption(text: viewModel.genres)
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

    struct ViewModel: Codable, Hashable {

        let title: String
        let description: String
        let ratingInfo: String
        let genres: String
        let imageURL: URL?

        var releaseDate: Date?

        var releaseInfo: String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let releaseDate = releaseDate else { return "Date of release not available" }
            let dateOfRelease = dateFormatter.string(from: releaseDate)

            return "Released on: \(dateOfRelease)"
        }

        init(movie: Movie, genresList: [Genre]) {
            self.title = movie.title
            self.description = movie.overview
            self.ratingInfo = "Rating: \(movie.rating?.description ?? "0")"
            self.imageURL = URL(string: movie.imagePath)
            self.releaseDate = movie.releaseDate

            self.genres = genresList
                .compactMap { movie.genreIds.contains($0.id) ? $0.name : nil }
                .joined(separator: ", ")
        }
    }
}
