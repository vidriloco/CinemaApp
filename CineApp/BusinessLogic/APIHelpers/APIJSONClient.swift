//
//  APIJSONClient.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import Foundation

// MARK - Specific error types for resource
enum APIResourceProviderError: Error {
    case undecodableResponseError
    case unexpectedError
}

class APIJSONClient<ResponseType: Decodable> {

    func execute(at endpoint: APIEndpoint, completion: @escaping (Result<ResponseType>) -> Void) {

        guard let url = endpoint.url else {
            completion(.fail(APIError.malformedURL))
            return
        }

        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in

            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {

                do {
                    completion(.success(try JSONDecoder().decode(ResponseType.self, from: data)))
                } catch let error {
                    completion(.fail(error))
                }

            } else if let error = error {
                completion(.fail(error))
            } else {
                completion(.fail(APIResourceProviderError.unexpectedError))
            }

        }
        dataTask.resume()
    }
}
