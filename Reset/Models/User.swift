//
//  User.swift
//  Reset
//
//  Created by Prasanjit Panda on 30/11/24.
//


import Foundation

struct User: Codable {
    var id: UUID
    var name: String
    var age: Int
    var memberSince: Date
    var soberSince: Date
    var resets: Int
    var streak: Int
    var bloodGroup: String
    var sex: String
    var profileImage: String
    var sponsorID: UUID?
    var friends: [UUID]
}
