//
//  PhotoModel.swift
//  test
//
//  Created by Kanat on 12/1/22.
//

import Foundation
import UIKit

struct PhotoModel: Codable {
    let id: String
    let createdAt: String
    let urls: Urls
    let likes: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case urls
        case likes
        case user
    }
}

struct User: Codable {
    let name: String

}

struct Urls: Codable {
    let small: URL
}

struct Constants {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.galleryMinimumLineSpacing / 2)) / 1
    
}
