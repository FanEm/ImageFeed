//
//  ProfileImageService.swift
//  ImageFeed
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()

    private let urlSession = URLSession.shared
    
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func fetchProfileImageURL(userName: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        if lastToken == token { return }
        task?.cancel()
        lastToken = token

        let request = URLRequests.profileImage(token: token, userName: userName)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                self.avatarURL = body.profileImage.small
                completion(.success(self.avatarURL!))
                postSuccessAvatarUrlReceivingNotification()
            case .failure(let error):
                self.lastToken = nil
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func postSuccessAvatarUrlReceivingNotification() {
        NotificationCenter
            .default
            .post(
                name: .profileImageProviderDidChange,
                object: self,
                userInfo: ["URL": self.avatarURL!])
    }
}
