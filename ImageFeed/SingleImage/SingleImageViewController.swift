//
//  SingleImageViewController.swift
//  ImageFeed
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: LightContentViewController {
    private enum Constants {
        static let backButtonWidthAndHeight: CGFloat = 48
        static let shareButtonWidthAndHeight: CGFloat = 50
        static let backButtonTopAndLeadingInset: CGFloat = 8
        static let shareButtonBottomInset: CGFloat = 38
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.accessibilityIdentifier = AccessibilityIdentifier.SingleImageScreen.view
        view.backgroundColor = .ypBlack
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        
        activateConstraints()
    }

    var image: Photo! {
        didSet {
            guard let url = URL(string: image.largeImageUrl) else { return }
            setImage(with: url)
        }
    }
    
    private func setImage(with url: URL) {
        UIBlockingProgressHUD.show()

        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self else { return }
            switch result {
            case .success(let downloadedImage):
                self.rescaleAndCenterImageInScrollView(image: downloadedImage.image)
            case .failure:
                self.showAlertWithFullScreenImageError(url: url)
            }
        }
    }

    // MARK: - View Configuration
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = AccessibilityIdentifier.SingleImageScreen.imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.accessibilityIdentifier = AccessibilityIdentifier.SingleImageScreen.scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(.sharingIcon, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapShareButton),
            for: .touchUpInside
        )
        button.accessibilityIdentifier = AccessibilityIdentifier.SingleImageScreen.shareButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.backwardIcon, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        button.accessibilityIdentifier = AccessibilityIdentifier.SingleImageScreen.backButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Constraints
    private var backButtonConstraints: [NSLayoutConstraint] {
        [
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonWidthAndHeight),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonWidthAndHeight),
            backButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.backButtonTopAndLeadingInset
            ),
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.backButtonTopAndLeadingInset
            )
        ]
    }

    private var shareButtonConstraints: [NSLayoutConstraint] {
        [
            shareButton.widthAnchor.constraint(equalToConstant: Constants.shareButtonWidthAndHeight),
            shareButton.heightAnchor.constraint(equalToConstant: Constants.shareButtonWidthAndHeight),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: shareButton.bottomAnchor,
                constant: Constants.shareButtonBottomInset
            )
        ]
    }

    private var imageViewConstraints: [NSLayoutConstraint] {
        [
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ]
    }

    private var scrollViewConstraints: [NSLayoutConstraint] {
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ]
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate(
            scrollViewConstraints
            + imageViewConstraints
            + shareButtonConstraints
            + backButtonConstraints
        )
    }

    // MARK: - Private functions
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapShareButton() {
        guard let imageToShare = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [imageToShare],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func showAlertWithFullScreenImageError(url: URL) {
        let model = AlertModel.fullScreenImageError(
            primaryButtonCompletion: { [weak self] in
                guard let self else { return }
                self.setImage(with: url)
            },
            secondaryButtonCompletion: {[weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            }
        )
        AlertPresenter.show(in: self, model: model)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }

    private var scrollViewVisibleSize: CGSize {
        let contentInset = scrollView.contentInset
        let scrollViewSize = scrollView.bounds.standardized.size
        let width = scrollViewSize.width - contentInset.left - contentInset.right
        let height = scrollViewSize.height - contentInset.top - contentInset.bottom
        return CGSize(width:width, height:height)
    }

    private var scrollViewCenter: CGPoint {
        let scrollViewSize = scrollViewVisibleSize
        return CGPoint(x: scrollViewSize.width / 2.0,
                       y: scrollViewSize.height / 2.0)
    }

    private func centerScrollViewContents() {
        guard let image = imageView.image else {
            return
        }

        let imgViewSize = imageView.frame.size
        let imageSize = image.size

        var realImgSize: CGSize
        if imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height {
            realImgSize = CGSize(
                width: imgViewSize.width,
                height: imgViewSize.width / imageSize.width * imageSize.height
            )
        } else {
            realImgSize = CGSize(
                width: imgViewSize.height / imageSize.height * imageSize.width,
                height: imgViewSize.height
            )
        }

        var frame = CGRect.zero
        frame.size = realImgSize
        imageView.frame = frame

        let screenSize  = scrollView.frame.size
        let offx = screenSize.width > realImgSize.width ? (screenSize.width - realImgSize.width) / 2 : 0
        let offy = screenSize.height > realImgSize.height ? (screenSize.height - realImgSize.height) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: offy,
                                               left: offx,
                                               bottom: offy,
                                               right: offx)

        // The scroll view has zoomed, so you need to re-center the contents
        let scrollViewSize = scrollViewVisibleSize

        // First assume that image center coincides with the contents box center.
        // This is correct when the image is bigger than scrollView due to zoom
        var imageCenter = CGPoint(x: scrollView.contentSize.width / 2.0,
                                  y: scrollView.contentSize.height / 2.0)

        let center = scrollViewCenter

        // If image is smaller than the scrollView visible size - fix the image center accordingly
        if scrollView.contentSize.width < scrollViewSize.width {
            imageCenter.x = center.x
        }

        if scrollView.contentSize.height < scrollViewSize.height {
            imageCenter.y = center.y
        }

        imageView.center = imageCenter
    }
}
