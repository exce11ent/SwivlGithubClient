//
//  UsersResponse.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation

class UsersResponse: Codable {
    let users: [User]

    enum CodingKeys: String, CodingKey {
        case users = ""
    }
}
