//
//  Photo.swift
//  ImageFeed
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageUrl: String
    let largeImageUrl: String
    var isLiked: Bool
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
            && lhs.size == rhs.size
            && lhs.createdAt == rhs.createdAt
            && lhs.welcomeDescription == rhs.welcomeDescription
            && lhs.thumbImageUrl == rhs.thumbImageUrl
            && lhs.largeImageUrl == rhs.largeImageUrl
            && lhs.isLiked == rhs.isLiked
    }
}
