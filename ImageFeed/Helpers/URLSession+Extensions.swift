//
//  URLSession+Extensions.swift
//  ImageFeed
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = dataTask(with: request) { data, response, error in
            if let data,
               let response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                200..<300 ~= statusCode
                ? fulfillCompletion(.success(data))
                : fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
            } else if let error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
