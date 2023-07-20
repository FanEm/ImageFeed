//
//  ImagesListPresenter.swift
//  ImageFeed
//

import Foundation

// MARK: - ImagesListPresenterProtocol
protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol? { get set }
    var photos: [Photo] { get set }

    func viewDidLoad()
    func syncPhotos()
    func updateTableViewAnimated()
    func fetchPhotosNextPageIfNeeded(index: Int)
    func changeLike(at index: Int, _ completion: @escaping (Result<[Photo], Error>) -> Void)
}

// MARK: - ImagesListPresenter
final class ImagesListPresenter: ImagesListPresenterProtocol {
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol?
    weak var view: ImagesListViewControllerProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imagesListService = ImagesListService.shared
        imageListServiceObserver = createImageListServiceObserver()
        imagesListService?.fetchPhotosNextPage()
    }

    func updateTableViewAnimated() {
        guard let imagesListService else { return }
        let oldPhotosCount = photos.count
        let newPhotosCount = imagesListService.photos.count
        let indexes = Array(oldPhotosCount..<newPhotosCount)
        syncPhotos()

        if oldPhotosCount != newPhotosCount {
            view?.insertRowsAnimated(at: indexes)
        }
    }
    
    func syncPhotos() {
        guard let imagesListService else { return }
        photos = imagesListService.photos
    }
    
    func fetchPhotosNextPageIfNeeded(index: Int) {
        if index == photos.count - 1 {
            imagesListService?.fetchPhotosNextPage()
        }
    }
    
    func changeLike(at index: Int, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let photo = photos[safe: index] else { return }

        imagesListService?.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.syncPhotos()
                    completion(.success(self.photos))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createImageListServiceObserver() -> NSObjectProtocol {
        return NotificationCenter.default
            .addObserver(
                forName: .imagesListServiceDidChange,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
    }
}
