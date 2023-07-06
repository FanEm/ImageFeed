//
//  ImagesListCell.swift
//  ImageFeed
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: UITableViewCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!

    weak var delegate: ImagesListCellDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()

        cellImage.kf.cancelDownloadTask()
    }

    func setIsLiked(_ isLiked: Bool) {
        let likeImage: UIImage = isLiked ? .activeLike : .inactiveLike
        likeButton.setImage(likeImage, for: .normal)
        likeButton.layer.add(pulseAnimation, forKey: "pulse")
    }

    private var pulseAnimation: CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")

        animation.values = [1.0, 1.2, 1.0]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 0.7
        animation.repeatCount = 2
        return animation
    }

    @IBAction private func likeButtonClicked() {
        delegate?.imagesListCellDidTapLike(self)
    }
}
