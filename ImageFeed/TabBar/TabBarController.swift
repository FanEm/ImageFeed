//
//  TabBarController.swift
//  ImageFeed
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()

        let imagesListViewController = createImagesListViewController()
        let profileViewController = createProfileViewController()

        self.tabBar.accessibilityIdentifier = AccessibilityIdentifier.TabBar.view

        self.viewControllers = [imagesListViewController, profileViewController]
    }

    private func createImagesListViewController() -> ImagesListViewController {
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter()

        imagesListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListPresenter

        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: .tabBarEditorialActive,
            selectedImage: nil
        )
        imagesListViewController.tabBarItem.accessibilityIdentifier = AccessibilityIdentifier.TabBar.imagesListTab
        return imagesListViewController
    }

    private func createProfileViewController() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()

        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController

        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: .tabBarProfileActive,
            selectedImage: nil
        )
        profileViewController.tabBarItem.accessibilityIdentifier = AccessibilityIdentifier.TabBar.profileTab
        return profileViewController
    }

    private func setAppearance() {
        tabBar.backgroundColor = .ypBlack
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.barStyle = .default
        tabBar.clipsToBounds = true
    }
}
