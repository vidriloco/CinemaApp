//
//  MovieListViewController.swift
//  CineApp
//
//  Created by Alejandro Cruz on 24/07/2021.
//

import UIKit

class MovieListViewController: UIViewController {
    private var nowPlayingViewController: MovieCollectionViewController?
    private var popularViewController: MovieCollectionViewController?

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        title = "List of movies"

        view.addSubview(stackView)
    }

    func configure(viewControllers: [UIViewController]) {
        viewControllers.forEach { viewController in
            addContentController(viewController)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let nowPlayingVC = children.first as? MovieCollectionViewController else  {
            fatalError("NowPlayingViewController wasn't set")
        }

        guard let popularVC = children.last as? MovieCollectionViewController else {
            fatalError("PopularViewController wasn't set")
        }

        nowPlayingViewController = nowPlayingVC
        popularViewController = popularVC

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func addContentController(_ child: UIViewController) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
        child.view.translatesAutoresizingMaskIntoConstraints = false
    }
}
