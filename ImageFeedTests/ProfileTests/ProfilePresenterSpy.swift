//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.ProfileViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func cleanData() { }
}
