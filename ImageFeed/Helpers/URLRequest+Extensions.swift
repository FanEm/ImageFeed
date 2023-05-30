//
//  URLRequest+Extensions.swift
//  ImageFeed
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseUrl: URL = DefaultBaseURL,
        queryItems: [URLQueryItem] = []
    ) -> URLRequest {
        var urlComponents = URLComponents(
            url: URL(string: path, relativeTo: baseUrl)!,
            resolvingAgainstBaseURL: true
        )!
        urlComponents.queryItems = queryItems
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod
        return request
    }
}
