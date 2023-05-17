//
//  UIImage+Extensions.swift
//  ImageFeed
//

import UIKit

extension UIImage {
    static var activeLike: UIImage { UIImage(named: "ActiveLike") ?? UIImage() }
    static var inactiveLike: UIImage { UIImage(named: "InactiveLike") ?? UIImage() }
    static var avatarImage: UIImage { UIImage(named: "UserPick") ?? UIImage() }
    static var exit: UIImage { UIImage(named: "Exit") ?? UIImage() }
 }
