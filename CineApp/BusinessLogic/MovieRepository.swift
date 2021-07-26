//
//  MovieRepository.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import Foundation

class MovieRepository {

    private let providerURL = "api.themoviedb.org"
    private let apiKey = "ca0319597162f943b322be58974014c5"

    typealias ImagePathMapper = (String) -> String

    private let moviePosterURLMapper: ImagePathMapper = { imagePath in
        return "http://image.tmdb.org/t/p/original/\(imagePath)"
    }

    func getMovieGenres(completion: @escaping ([Genre]) -> Void, failure: @escaping (Error) -> Void) {
        let apiClient = APIJSONClient<GenreCollection>()

        let params = ["api_key": apiKey]
        let endpoint = APIEndpoint(host: providerURL, path: "/3/genre/movie/list").with(params: params)

        apiClient.execute(at: endpoint) { response in
            switch response {
            case .success(let genreCollection):
                completion(genreCollection.genres.map { $0.toGenre() })
            case .fail(let error):
                failure(error)
            }
        }
    }

    func getMoviesNowPlaying(completion: @escaping ([Movie]) -> Void, failure: @escaping (Error) -> Void) {
        let params = ["api_key": apiKey]
        let endpoint = APIEndpoint(host: providerURL, path: "/3/movie/now_playing").with(params: params)
        fethMovieCollection(endpoint: endpoint, completion: completion, failure: failure)
    }

    func getPopularMovies(completion: @escaping ([Movie]) -> Void, failure: @escaping (Error) -> Void) {
        let params = ["api_key": apiKey]
        let endpoint = APIEndpoint(host: providerURL, path: "/3/movie/popular").with(params: params)
        fethMovieCollection(endpoint: endpoint, completion: completion, failure: failure)
    }
}

// MARK: - Struct DTOs representing API resources

extension MovieRepository {
    typealias MovieInMovieCollection = MovieRepository.MovieCollection.Movie

    struct MovieCollection: Decodable {
        let page: Int
        let results: [Movie]

        struct Movie: Decodable {
            var imagePathMapper: ImagePathMapper?

            let posterPath: String
            let overview: String
            let releaseDate: String
            let id: Int
            let originalTitle: String
            let voteAverage: Double
            let genres: [Int]

            private enum CodingKeys : String, CodingKey {
                case posterPath = "poster_path"
                case releaseDate = "release_date"
                case originalTitle = "original_title"
                case voteAverage = "vote_average"
                case genres = "genre_ids"
                case overview, id
            }
        }
    }

    struct GenreCollection: Decodable {
        let genres: [Genre]

        struct Genre: Decodable {
            let id: Int
            let name: String
        }
    }
}

// MARK: - MovieRepository class private methods

private extension MovieRepository {

    func fethMovieCollection(endpoint: APIEndpoint, completion: @escaping ([Movie]) -> Void, failure: @escaping (Error) -> Void) {
        let apiClient = APIJSONClient<MovieCollection>()

        apiClient.execute(at: endpoint) { [weak self] response in

            guard let self = self else { return }

            switch response {
            case .success(let movieCollection):
                let movies = movieCollection.results.map { $0.toMovie(using: self.moviePosterURLMapper) }
                completion(movies)
            case .fail(let error):
                failure(error)
            }
        }
    }

}


