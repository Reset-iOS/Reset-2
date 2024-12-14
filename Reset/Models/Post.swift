//
//  Post.swift
//  Reset
//
//  Created by Prasanjit Panda on 08/12/24.
//

import Foundation

struct Post {
    let profileImageName: String
    let userName: String
    let dateOfPost: String
    let postImageName: String?  // Optional post image
    let postText: String
    let likesCount: Int
    let commentsCount: Int
    var comments: [Comment]
}

var mockPosts = [
    Post(
        profileImageName: "Emily",
        userName: "Emily Clark",
        dateOfPost: "Dec 1, 2024",
        postImageName: "Emily",
        postText: "Had a wonderful day exploring nature!",
        likesCount: 128,
        commentsCount: 2,  // Updated to match the comments array count
        comments: [
            Comment(userName: "Emily Clark", profileImage:"Emily", commentText: "I love the holidays! 🎁"),
            Comment(userName: "Emily Clark", profileImage:"Emily", commentText: "I love the holidays! 🎁")
        ]
    ),
    Post(
        profileImageName: "Emily",
        userName: "John Doe",
        dateOfPost: "Dec 2, 2024",
        postImageName: nil,
        postText: "Life is better with a good cup of coffee ☕️",
        likesCount: 210,
        commentsCount: 1,  // Updated to match the comments array count
        comments: [
            Comment(userName: "Emily Clark", profileImage:"Emily", commentText: "I love the holidays! 🎁")
        ]
    ),
    Post(
        profileImageName: "Emily",
        userName: "Sarah Lee",
        dateOfPost: "Dec 3, 2024",
        postImageName: "Emily",
        postText: "Can't wait for the holiday season! 🎄✨",
        likesCount: 340,
        commentsCount: 2,  // Updated to match the comments array count
        comments: [
            Comment(userName: "Emily Clark", profileImage:"Emily", commentText: "I love the holidays! 🎁"),
            Comment(userName: "Emily Clark", profileImage:"Emily", commentText: "I love the holidays! 🎁")
        ]
    )
]
