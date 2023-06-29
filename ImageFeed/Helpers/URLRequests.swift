//
//  URLRequests.swift
//  ImageFeed
//

import Foundation

enum URLRequests {
    static func profile(token: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "me",
            httpMethod: .get,
            headers: [("Authorization", "Bearer \(token)")]
        )
    }

    static func profileImage(token: String, userName: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "users/\(userName)",
            httpMethod: .get,
            headers: [("Authorization", "Bearer \(token)")]
        )
    }

    static func authPage() -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "oauth/authorize",
            httpMethod: .get,
            baseUrl: AuthorizeBaseURL,
            queryItems: [
                URLQueryItem(name: "client_id", value: AccessKey),
                URLQueryItem(name: "redirect_uri", value: RedirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: AccessScope)
            ]
        )
    }

    static func authToken(by code: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "oauth/token",
            httpMethod: .post,
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
    
    static func photos(page: Int, perPage: Int, token: String, orderBy: String = "latest") -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "photos",
            httpMethod: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage)),
                URLQueryItem(name: "order_by", value: orderBy)
            ],
            headers: [("Authorization", "Bearer \(token)")]
        )
    }
    
    static func addLike(photoId: String, token: String) -> URLRequest {
        return URLRequests.likeRequest(photoId: photoId, method: .post, token: token)
    }
    
    static func deleteLike(photoId: String, token: String) -> URLRequest {
        return URLRequests.likeRequest(photoId: photoId, method: .delete, token: token)
    }
    
    static private func likeRequest(photoId: String, method: HTTPMethod, token: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: method,
            headers: [("Authorization", "Bearer \(token)")]
        )
    }
}
