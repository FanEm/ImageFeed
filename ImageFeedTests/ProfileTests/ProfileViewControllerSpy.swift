//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//

import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false

    func updateAvatar(url: URL?) {
        updateAvatarCalled = true
    }

    func updateProfileDetails(profile: ImageFeed.Profile?) {
        updateProfileDetailsCalled = true
    }
    
    func didTapLogoutButton() { }
}
