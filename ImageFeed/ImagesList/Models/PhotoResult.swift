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
    
    static func convertToPhoto(photoResults: [PhotoResult]) -> [Photo] {
        let dateFormatter = ISO8601DateFormatter()

        return photoResults.map { Photo(
            id: $0.id,
            size: CGSize(width: $0.width, height: $0.height),
            createdAt: dateFormatter.date(from: $0.createdAt),
            welcomeDescription: $0.description,
            thumbImageUrl: $0.urls.thumb,
            largeImageUrl: $0.urls.full,
            isLiked: $0.isLiked
        )}
    }
}

struct UrlResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
