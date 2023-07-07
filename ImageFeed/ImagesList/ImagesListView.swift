//
//  ImagesListView.swift
//  ImageFeed
//

import UIKit

// MARK: - ImagesListView
final class ImagesListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .ypBlack
        accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.view

        addSubview(tableView)

        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View elements
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.accessibilityIdentifier = AccessibilityIdentifier.ImagesListScreen.tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Constraints
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
