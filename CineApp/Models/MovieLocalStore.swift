//
//  MovieLocalStore.swift
//  CineApp
//
//  Created by Alejandro Cruz on 26/07/2021.
//

import Foundation

struct MovieLocalStore {

    static let shared = MovieLocalStore()

    private let key = "Movies"

    public init() { }

    public func save(_ movie: MovieDetailsViewController.MovieDetailsViewModel) {
        do {
            var movies = storedMovies
            movies?.append(movie)

            let encoder = JSONEncoder()
            let data = try encoder.encode(movies)
            UserDefaults.standard.set(data, forKey: key)

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }

    public func delete(_ movie: MovieDetailsViewController.MovieDetailsViewModel) {
        do {
            var movies = storedMovies
            movies?.removeAll(where: { $0 == movie })

            let encoder = JSONEncoder()
            let data = try encoder.encode(movies)
            UserDefaults.standard.set(data, forKey: key)

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }

    public func contains(_ movie: MovieDetailsViewController.MovieDetailsViewModel) -> Bool {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode([MovieDetailsViewController.MovieDetailsViewModel].self, from: data)
                return movies.contains { $0 == movie }
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }

        return false
    }

    public var storedMovies: [MovieDetailsViewController.MovieDetailsViewModel]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([MovieDetailsViewController.MovieDetailsViewModel].self, from: data)
            } catch {
                return nil
            }
        }

        return []
    }
}
