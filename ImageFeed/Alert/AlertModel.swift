//
//  AlertModel.swift
//  ImageFeed
//

struct AlertModel {
    let title: String
    let message: String
    let primaryButtonText: String?
    let secondaryButtonText: String?
    let primaryButtonCompletion: () -> Void
    let secondaryButtonCompletion: () -> Void
}


