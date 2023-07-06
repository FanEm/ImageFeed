//
//  AlertPresenter.swift
//  ImageFeed
//

import UIKit

final class AlertPresenter {
    static func show(in controller: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        if let primaryButtonText = model.primaryButtonText {
            let primaryButtonAction = UIAlertAction(title: primaryButtonText, style: .cancel) { _ in
                model.primaryButtonCompletion()
            }
            alert.addAction(primaryButtonAction)
        }
        
        if let secondaryButtonText = model.secondaryButtonText {
            let secondaryButtonAction = UIAlertAction(title: secondaryButtonText, style: .default) { _ in
                model.secondaryButtonCompletion()
            }
            alert.addAction(secondaryButtonAction)
        }
        
        controller.present(alert, animated: true, completion: nil)
    }
}
