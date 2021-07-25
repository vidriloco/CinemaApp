//
//  MovieCollectionViewCell.swift
//  CineApp
//
//  Created by Alejandro Cruz on 24/07/2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally

        return stackView
    }()

    override public init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(stackView)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeightConstant),
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        imageView.image = movie.image
        titleLabel.text = movie.title
    }
}

extension MovieCollectionViewCell {
    struct Constants {
        static let titleHeightConstant: CGFloat = 30
    }
}
