//
//  Post.swift
//  Reset
//
//  Created by Prasanjit Panda on 08/12/24.
//

import Foundation

struct Post: Codable {
    var id: UUID
    let profileImageName: String
    let userName: String
    let dateOfPost: String
    let postImageName: String?  // Optional post image
    let postText: String
    var likesCount: Int
    var commentsCount: Int
    var comments: [Comment]
}

var mockPosts = PostDataPersistence.shared.loadPosts()
