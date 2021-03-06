//
//  FavoriteMoviesListViewController.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import UIKit

protocol FavoriteMoviesListDelegate {
    func didSelect(movieDetailsViewModel: MovieDetailsViewController.ViewModel, from controller: UIViewController)
}

class FavoriteMoviesListViewController: UITableViewController {

    public var delegate: FavoriteMoviesListDelegate?

    let emptyView: EmptyListView = {
        let view = EmptyListView(with: "No movies to display",
                                 message: "Explore the app and fav some :)")
        return view
    }()

    var movieEntryList = [MovieDetailsViewController.ViewModel]() {
        didSet {
            if movieEntryList.isEmpty {
                setEmptyView()
            } else {
                clearEmptyView()
            }
            tableView.reloadData()
        }
    }

    private let reuseIdentifier = String(describing: UITableViewCell.self)

    public init() {
        super.init(nibName: nil, bundle: nil)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Favorite Movies"
    }
}

extension FavoriteMoviesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieEntryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieEntry = movieEntryList[indexPath.row]

        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            dequeuedCell.textLabel?.text = movieEntry.title
            return dequeuedCell
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieEntry = movieEntryList[indexPath.row]

        delegate?.didSelect(movieDetailsViewModel: movieEntry, from: self)
    }
}

extension FavoriteMoviesListViewController {
    func setEmptyView() {
        tableView.backgroundView = emptyView
        tableView.separatorStyle = .none
    }
    func clearEmptyView() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}
