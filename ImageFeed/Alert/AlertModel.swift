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
    
    static var authError: AlertModel {
        AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            primaryButtonText: "OK",
            secondaryButtonText: nil,
            primaryButtonCompletion: {},
            secondaryButtonCompletion: {}
        )
    }
    
    static var changeLikeError: AlertModel {
        AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось поставить/снять лайк",
            primaryButtonText: "OK",
            secondaryButtonText: nil,
            primaryButtonCompletion: {},
            secondaryButtonCompletion: {}
        )
    }
    
    static func logOutAlert(primaryButtonCompletion: @escaping () -> Void) -> AlertModel {
        return AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            primaryButtonText: "Да",
            secondaryButtonText: "Нет",
            primaryButtonCompletion: primaryButtonCompletion,
            secondaryButtonCompletion: {}
        )
    }
    
    static func fullScreenImageError(
        primaryButtonCompletion: @escaping () -> Void,
        secondaryButtonCompletion: @escaping () -> Void
    ) -> AlertModel {
        return AlertModel(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            primaryButtonText: "Повторить",
            secondaryButtonText: "Не надо",
            primaryButtonCompletion: primaryButtonCompletion,
            secondaryButtonCompletion: secondaryButtonCompletion
        )
    }
}
