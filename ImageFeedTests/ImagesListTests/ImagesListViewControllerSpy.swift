//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//

@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var insertRowsAnimatedCalled = false

    func insertRowsAnimated(at indexes: [Int]) {
        insertRowsAnimatedCalled = true
    }
}
