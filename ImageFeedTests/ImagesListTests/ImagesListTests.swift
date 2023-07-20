//
//  ImagesListTests.swift
//  ImageFeedTests
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    private let mockPhoto = Photo(
        id: "1",
        size: CGSize(width: 1.0, height: 1.0),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageUrl: "",
        largeImageUrl: "",
        isLiked: false
    )
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testFetchPhotos() {
        //given
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter()
        presenter.imagesListService = imagesListService
        
        presenter.photos = [mockPhoto]

        //when
        presenter.fetchPhotosNextPageIfNeeded(index: 0)

        //then
        XCTAssertTrue(imagesListService.fetchPhotosNextPageCalled)
    }
    
    func testSyncPhotos() {
        //given
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter()
        presenter.imagesListService = imagesListService

        imagesListService.photos = [mockPhoto]
        
        //when
        XCTAssertEqual(presenter.photos.count, 0)
        presenter.syncPhotos()

        //then
        XCTAssertEqual(presenter.photos.count, 1)
        XCTAssertEqual(presenter.photos[0], imagesListService.photos[0])
    }

    func testChangeLike() {
        //given
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter()
        presenter.imagesListService = imagesListService

        presenter.photos = [mockPhoto]
        
        //when
        presenter.changeLike(at: 0) { _ in }

        //then
        XCTAssertTrue(imagesListService.changeLikeCalled)
    }
    
    func testUpdateTableView() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        let imagesListService = ImagesListServiceSpy()
        presenter.view = viewController
        presenter.imagesListService = imagesListService
        
        imagesListService.photos = [mockPhoto]
        
        //when
        presenter.updateTableViewAnimated()

        //then
        XCTAssertTrue(viewController.insertRowsAnimatedCalled)
    }
}
