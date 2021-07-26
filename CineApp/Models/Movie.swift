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

    var genreIds = [Int]()
    var releaseDate: Date?
    var rating: Double?
    var overview: String
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
                     genreIds: genres,
                     releaseDate: dateOfRelease,
                     rating: voteAverage,
                     overview: overview)
    }
}
