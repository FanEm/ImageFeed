//
//  Array+Extensions.swift
//  ImageFeed
//

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
