//
//  ProfilePresenter.swift
//  ImageFeed
//

import Foundation

// MARK: - ProfilePresenterProtocol
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }

    func viewDidLoad()
    func cleanData()
}

// MARK: - ProfilePresenter
final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?

    private var profileImageServiceObserver: NSObjectProtocol?

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private var profileImageURL: URL? {
        guard let profileImageURL = profileImageService.avatarURL else { return nil }
        return URL(string: profileImageURL)
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = createProfileImageObserver()
        view?.updateProfileDetails(profile: profileService.profile)
        view?.updateAvatar(url: profileImageURL)
    }

    func cleanData() {
        WebViewViewController.cleanWKData()
        oauth2TokenStorage.removeToken()
    }

    private func createProfileImageObserver() -> NSObjectProtocol {
        return NotificationCenter.default
            .addObserver(
                forName: .profileImageProviderDidChange,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.view?.updateAvatar(url: self.profileImageURL)
            }
    }
}
