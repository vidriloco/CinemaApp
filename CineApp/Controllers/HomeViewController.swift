//
//  HomeViewController.swift
//  CineApp
//
//  Created by Alejandro Cruz on 24/07/2021.
//

import UIKit

class HomeViewController: UIViewController {
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

        configureChildren()
    }

    private func configureChildren() {
        view.addSubview(stackView)

        let nowPlayingList = [
            Movie(title: "Brave", image: UIImage(named: "brave")!, color: .red),
            Movie(title: "Toy Story", image: UIImage(named: "buzz")!, color: .blue),
            Movie(title: "Finding Nemo", image: UIImage(named: "nemo")!, color: .green)
        ]

        let nowPlayingVC =  MovieCollectionViewController(with: nowPlayingList)

        let popularList = [
            Movie(title: "Monsters INC", image: UIImage(named: "monsters")!, color: .red),
            Movie(title: "Wall-E", image: UIImage(named: "wall-e")!, color: .blue)
        ]

        let popularVC = MovieCollectionViewController(with: popularList)

        addContentController(nowPlayingVC)
        addContentController(popularVC)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Available Films"

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
