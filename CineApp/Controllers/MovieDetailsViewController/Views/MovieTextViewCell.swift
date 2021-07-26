//
//  MovieTextViewCell.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import UIKit

class MovieTextViewCell: UITableViewCell {

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()

    private let genericTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()

    func configureWith(_ entry: MovieDetailsViewController.MovieDetails) {
        configureGenericTexLabel()

        switch entry {
        case .title(let text):
            genericTextLabel.text = text
            genericTextLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        case .description(let text):
            genericTextLabel.text = text
            genericTextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        case .caption(let text):
            genericTextLabel.text = text
            genericTextLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        default:
            fatalError("Unknown movie details entry")
        }

    }
}

private extension MovieTextViewCell {

    func configureGenericTexLabel() {
        contentView.addSubview(genericTextLabel)

        NSLayoutConstraint.activate([
            genericTextLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constants.margin),
            genericTextLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.margin),
            genericTextLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.margin),
            genericTextLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.margin),

        ])
    }

    struct Constants {
        static let margin: CGFloat = 20
    }
}
