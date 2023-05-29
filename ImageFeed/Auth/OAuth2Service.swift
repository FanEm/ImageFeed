//
//  OAuth2Service.swift
//  ImageFeed
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }

    private func authTokenRequest(code: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "oauth/token",
            httpMethod: "POST",
            baseUrl: AuthorizeBaseURL,
            queryItems: [
                URLQueryItem(name: "client_id", value: AccessKey),
                URLQueryItem(name: "client_secret", value: SecretKey),
                URLQueryItem(name: "redirect_uri", value: RedirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
        )
    }
}
