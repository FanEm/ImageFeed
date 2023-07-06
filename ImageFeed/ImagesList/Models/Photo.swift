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
    let isLiked: Bool
}
