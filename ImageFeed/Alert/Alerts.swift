//
//  Alerts.swift
//  ImageFeed
//

enum Alert {
    static let authError = AlertModel(
        title: "Что-то пошло не так(",
        message: "Не удалось войти в систему",
        buttonText: "OK",
        completion: { }
    )
}
