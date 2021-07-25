//
//  MovieCollectionViewController.swift
//  CineApp
//
//  Created by Alejandro Cruz on 24/07/2021.
//

import UIKit

struct Movie {

    let title: String
    let image: UIImage

    var genres = [Genre]()
    var releaseDate: Date?
    var popularity: Int?
    var overview: String?

    struct Genre {
        let name: String
        let id: Int
    }
}

protocol MovieDetailsDelegate {
    func didSelect(movie: Movie, from controller: UIViewController)
}

class MovieCollectionViewController: UIViewController {

    public var delegate: MovieDetailsDelegate?

    private let movies: [Movie]

    private let reuseIdentifier = String(describing: MovieCollectionViewCell.self)

    private var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.itemSpacing, bottom: 0, right: Constants.itemSpacing)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    public init(with movies: [Movie]) {
        self.movies = movies
        super.init(nibName: nil, bundle: nil)

        collectionView.backgroundColor = .white

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false

        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MovieCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-Constants.itemProportion*Constants.itemSpacing,
                      height: collectionView.frame.height-Constants.itemProportion*Constants.itemSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemProportion*Constants.itemSpacing
    }
}

extension MovieCollectionViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let cellWidth = collectionView.frame.width
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidth
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

extension MovieCollectionViewController : UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }

        let movie = movies[indexPath.item]
        cell.configure(with: movie)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        delegate?.didSelect(movie: movie, from: self)
    }
}

extension MovieCollectionViewController {
    struct Constants {
        static let itemSpacing: CGFloat = 25
        static let itemProportion: CGFloat = 2
    }
}
