//
//  ImagesListService.swift
//  ImageFeed
//

import Foundation

// MARK: - ImagesListServiceProtocol
protocol ImagesListServiceProtocol {
    var photos: [Photo] { get set }

    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - ImagesListService
final class ImagesListService: ImagesListServiceProtocol {
    private enum Constants {
        static let photosPerPage: Int = 10
    }
    
    static let shared = ImagesListService()

    private let urlSession = URLSession.shared

    var photos: [Photo] = []

    private var lastLoadedPage: Int = 0
    private var task: URLSessionTask?
    private var token: String? {
        OAuth2TokenStorage.shared.token
    }

    private init() {}

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard
            task == nil,
            let token = token
        else { return }
        
        let nextPage = lastLoadedPage + 1
        
        let request = URLRequests.photos(page: nextPage,perPage: Constants.photosPerPage, token: token)

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }

            switch result {
            case .success(let body):
                DispatchQueue.main.async {
                    let newPhotos = body.map { $0.toPhoto }
                    self.photos.append(contentsOf: newPhotos)
                    self.postSuccessPhotosReceivingNotification()
                    self.lastLoadedPage += 1
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token else { return }

        let request = isLike
        ? URLRequests.addLike(photoId: photoId, token: token)
        : URLRequests.deleteLike(photoId: photoId, token: token)

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self else { return }

            switch result {
            case .success(let body):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        self.photos[index].isLiked = body.photo.isLiked
                    }
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    // MARK: - Private functions
    private func postSuccessPhotosReceivingNotification() {
        NotificationCenter
            .default
            .post(
                name: .imagesListServiceDidChange,
                object: self
            )
    }
}
