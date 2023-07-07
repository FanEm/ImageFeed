//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//

@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var imagesListService: ImageFeed.ImagesListServiceProtocol?
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var photos: [ImageFeed.Photo] = []

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func syncPhotos() { }
    
    func updateTableViewAnimated() { }
    
    func fetchPhotosNextPageIfNeeded(index: Int) { }
    
    func changeLike(at index: Int, _ completion: @escaping (Result<[ImageFeed.Photo], Error>) -> Void) { }
}
