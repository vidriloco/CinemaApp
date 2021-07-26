//
//  MoviePosterViewCell.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import UIKit

class MoviePosterViewCell: UITableViewCell {

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()

    func configureWithImage(from url: URL?) {

        contentView.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.margin),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.margin),
        ])

        posterImageView.sd_setImage(with: url, completed: nil)
    }
}

private extension MoviePosterViewCell {

    struct Constants {
        static let margin: CGFloat = 20
    }
}

