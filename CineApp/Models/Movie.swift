//
//  Movie.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import UIKit

struct Movie {
    let id: Int
    let title: String
    var imagePath: String

    var genres = [Genre]()
    var releaseDate: Date?
    var popularity: Double?
    var overview: String?

    struct Genre {
        let name: String
        let id: Int
    }
}

extension Movie {
    var url: URL? {
        return URL(string: imagePath)
    }
}

// MARK:- Struct DTOs transformation helpers

extension MovieRepository.MovieCollection.Movie {
    func toMovie(using movieImagePathMapper: MovieRepository.ImagePathMapper) -> Movie {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateOfRelease = dateFormatter.date(from: releaseDate)

        return Movie(id: id,
                     title: originalTitle,
                     imagePath: movieImagePathMapper(self.posterPath),
                     genres: [],
                     releaseDate: dateOfRelease,
                     popularity: popularity,
                     overview: overview)
    }
}
