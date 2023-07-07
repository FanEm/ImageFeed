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
