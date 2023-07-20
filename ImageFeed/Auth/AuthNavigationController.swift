//
//  AuthNavigationController.swift
//  ImageFeed
//

import UIKit

// MARK: - AuthNavigationController
final class AuthNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? { return visibleViewController }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
    }
}
