//
//  URLRequest+Extensions.swift
//  ImageFeed
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: HTTPMethod,
        baseUrl: URL = DefaultBaseURL,
        queryItems: [URLQueryItem] = [],
        headers: [(header: String, value: String)] = []
    ) -> URLRequest {
        var urlComponents = URLComponents(
            url: URL(string: path, relativeTo: baseUrl)!,
            resolvingAgainstBaseURL: true
        )!
        urlComponents.queryItems = queryItems

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod.rawValue
        for (header, value) in headers {
            request.setValue(value, forHTTPHeaderField: header)
        }

        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
