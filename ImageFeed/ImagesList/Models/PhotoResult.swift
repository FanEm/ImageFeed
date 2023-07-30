//
//  PhotoResult.swift
//  ImageFeed
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: UrlResult
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
}

extension PhotoResult {
    private static let formatter = ISO8601DateFormatter()

    var toPhoto: Photo {
        Photo(
            id: self.id,
            size: CGSize(width: self.width, height: self.height),
            createdAt: Self.formatter.date(from: self.createdAt),
            welcomeDescription: self.description,
            thumbImageUrl: self.urls.thumb,
            largeImageUrl: self.urls.full,
            isLiked: self.isLiked
        )
    }
}

struct UrlResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
