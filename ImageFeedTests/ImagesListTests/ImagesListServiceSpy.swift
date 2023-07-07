//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//

@testable import ImageFeed

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false

    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
    }
}
