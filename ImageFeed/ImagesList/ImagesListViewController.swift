//
//  ImagesListViewController.swift
//  ImageFeed
//

import UIKit
import Kingfisher

// MARK: - ImagesListViewControllerProtocol
protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }

    func insertRowsAnimated(at indexes: [Int])
}

// MARK: - ImagesListViewController
final class ImagesListViewController: LightContentViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?

    private let imagesListView = ImagesListView()
    
    override func loadView() {
        view = imagesListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imagesListView.tableView.dataSource = self
        imagesListView.tableView.delegate = self
        
        presenter?.viewDidLoad()
    }

    func insertRowsAnimated(at indexes: [Int]) {
        imagesListView.tableView.performBatchUpdates() {
            let indexPaths = indexes.map { IndexPath(row: $0, section: 0)}
            imagesListView.tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

// MARK: - Config cell
extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photos[safe: indexPath.row] else { return }
        
        cell.configCell(photo: photo) { [weak imagesListView] result in
            switch result {
            case .success(_):
                imagesListView?.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard
            let presenter,
            let image = presenter.photos[safe: indexPath.row]
        else {
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
        presenter?.fetchPhotosNextPageIfNeeded(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let photo = presenter?.photos[safe: indexPath.row] else { return }
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
        guard let presenter else {
            assertionFailure("Presenter is nil")
            return 0
        }
        return presenter.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: UITableViewCell) {
        guard
            let indexPath = imagesListView.tableView.indexPath(for: cell),
            let presenter,
            let imagesListCell = cell as? ImagesListCell
        else { return }
        
        let index = indexPath.row

        UIBlockingProgressHUD.show()
        
        presenter.changeLike(at: index) { result in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    imagesListCell.setIsLiked(photos[index].isLiked)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                AlertPresenter.show(in: self, model: .changeLikeError)
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
