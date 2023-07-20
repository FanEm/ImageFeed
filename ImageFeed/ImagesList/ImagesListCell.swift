//
//  ImagesListCell.swift
//  ImageFeed
//

import UIKit
import Kingfisher

// MARK: - ImagesListCellDelegate
protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: UITableViewCell)
}

// MARK: - ImagesListCell
final class ImagesListCell: UITableViewCell {
    private enum Constants {
        static let fontSize13: CGFloat = 13
        static let cellImageCornerRadius: CGFloat = 16
        static let cellImageTopAndBottomInset: CGFloat = 4
        static let cellImageLeadingAndTrailingInset: CGFloat = 16
        static let dateLabelLeadingAndTrailingInset: CGFloat = 8
    }

    static let reuseIdentifier = "ImagesListCell"

    weak var delegate: ImagesListCellDelegate?

    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.Cell.view
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cellImageView)
        contentView.addSubview(gradientImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(iOS 14.0, *)
    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = UIBackgroundConfiguration.clear()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cellImageView.kf.cancelDownloadTask()
    }
    
    func configCell(photo: Photo, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let dateString = (photo.createdAt != nil)
            ? ImagesListCell.dateFormatter.string(from: photo.createdAt!)
            : ""
        let likeImage = getLikeImage(isLiked: photo.isLiked)
        
        likeButton.isSelected = photo.isLiked

        likeButton.setImage(likeImage, for: .normal)
        dateLabel.text = dateString
        
        guard let url = URL(string: photo.thumbImageUrl) else { return }

        let placeholder: UIImage = .imageStub
        let retry = DelayRetryStrategy(
            maxRetryCount: 2,
            retryInterval: .seconds(3)
        )
        cellImageView.kf.indicatorType = .activity

        cellImageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.retryStrategy(retry)]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                self.cellImageView.image = .imageStub
                completion(.failure(error))
            }
        }
    }

    func setIsLiked(_ isLiked: Bool) {
        let likeImage = getLikeImage(isLiked: isLiked)
        likeButton.setImage(likeImage, for: .normal)
        likeButton.isSelected = isLiked
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

    @objc private func likeButtonClicked() {
        delegate?.imagesListCellDidTapLike(self)
    }

    private func getLikeImage(isLiked: Bool) -> UIImage {
        return isLiked ? .activeLike : .inactiveLike
    }

    // MARK: - View elements
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cellImageCornerRadius
        imageView.accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.Cell.imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .gradient
        imageView.accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.Cell.gradientView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: Constants.fontSize13)
        label.textColor = .ypWhite
        label.accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.Cell.dateLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(.inactiveLike, for: .normal)
        button.addTarget(
            nil,
            action: #selector(likeButtonClicked),
            for: .touchUpInside
        )
        button.accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.Cell.likeButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Constraints
    private var cellImageViewConstraints: [NSLayoutConstraint] {
        [
            cellImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.cellImageLeadingAndTrailingInset
            ),
            cellImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.cellImageTopAndBottomInset
            ),
            contentView.trailingAnchor.constraint(
                equalTo: cellImageView.trailingAnchor,
                constant: Constants.cellImageLeadingAndTrailingInset
            ),
            contentView.bottomAnchor.constraint(
                equalTo: cellImageView.bottomAnchor,
                constant: Constants.cellImageTopAndBottomInset
            )
        ]
    }

    private var gradientImageViewConstraints: [NSLayoutConstraint] {
        [
            gradientImageView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            gradientImageView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            gradientImageView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            gradientImageView.topAnchor.constraint(equalTo: dateLabel.topAnchor)
        ]
    }

    private var dateLabelConstraints: [NSLayoutConstraint] {
        [
            cellImageView.bottomAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: Constants.dateLabelLeadingAndTrailingInset
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: cellImageView.leadingAnchor,
                constant: Constants.dateLabelLeadingAndTrailingInset
            ),
            cellImageView.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.trailingAnchor)
        ]
    }

    private var likeButtonConstraints: [NSLayoutConstraint] {
        [
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor)
        ]
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate(
            cellImageViewConstraints +
            gradientImageViewConstraints +
            dateLabelConstraints +
            likeButtonConstraints
        )
    }
}
