//
//  ImagesListViewController.swift
//  ImageFeed
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    private let imagesListService = ImagesListService.shared

    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = createImageListServiceObserver()
        imagesListService.fetchPhotosNextPage()
    }

    private func createImageListServiceObserver() -> NSObjectProtocol {
        return NotificationCenter.default
            .addObserver(
                forName: .imagesListServiceDidChange,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
    }

    private func updateTableViewAnimated() {
        let oldPhotosCount = photos.count
        let newPhotosCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldPhotosCount != newPhotosCount {
            tableView.performBatchUpdates() {
                let indexPaths = (oldPhotosCount..<newPhotosCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - Config cell
extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.row] else { return }

        let likeImage: UIImage = photo.isLiked ? .activeLike : .inactiveLike
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.dateLabel.text = (photo.createdAt != nil)
            ? dateFormatter.string(from: photo.createdAt!)
            : ""

        guard let url = URL(string: photo.thumbImageUrl) else { return }

        let placeholder: UIImage = .imageStub
        cell.cellImage.kf.indicatorType = .activity

        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak tableView] _ in
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = photos[safe: indexPath.row] else {
            assertionFailure("There is no photo with index \(indexPath.row)")
            return .zero
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.row] else { return }
        let viewController = SingleImageViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true) {
            viewController.image = photo
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.selectionStyle = .none
        imagesListCell.delegate = self
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: UITableViewCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let photo = photos[safe: indexPath.row],
            let imagesListCell = cell as? ImagesListCell
        else { return }

        UIBlockingProgressHUD.show()

        imagesListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.photos = self.imagesListService.photos
                    imagesListCell.setIsLiked(self.photos[indexPath.row].isLiked)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
}
