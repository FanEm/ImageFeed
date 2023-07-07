//
//  AuthHelper.swift
//  ImageFeed
//

import Foundation

// MARK: - AuthHelperProtocol
protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func authToken(by code: String) -> URLRequest
    func code(from url: URL) -> String?
}

// MARK: - AuthHelper
final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }

    func authRequest() -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "oauth/authorize",
            httpMethod: .get,
            baseUrl: AuthorizeBaseURL,
            queryItems: [
                URLQueryItem(name: "client_id", value: configuration.accessKey),
                URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: configuration.accessScope)
            ]
        )
    }

    func authToken(by code: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "oauth/token",
            httpMethod: .post,
            baseUrl: AuthorizeBaseURL,
            queryItems: [
                URLQueryItem(name: "client_id", value: configuration.accessKey),
                URLQueryItem(name: "client_secret", value: configuration.secretKey),
                URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
        )
    }

    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" } )
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
