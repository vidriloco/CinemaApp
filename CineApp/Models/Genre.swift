//
//  MovieGenre.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import Foundation

struct Genre {
    let id: Int
    let name: String
}

// MARK:- Struct DTOs transformation helpers

extension MovieRepository.GenreCollection.Genre {
    func toGenre() -> Genre {
        return Genre(id: id, name: name)
    }
}
