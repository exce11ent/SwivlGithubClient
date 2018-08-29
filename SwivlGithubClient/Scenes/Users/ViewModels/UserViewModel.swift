//
//  UserViewModel.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation

class UserViewModel {

    let nickname: String
    let avatarUrl: URL?
    let profileLink: URL?
    let id: Int

    init(user: User) {
        self.nickname = user.login
        self.avatarUrl = URL(string: user.avatarURL)
        self.profileLink = URL(string: user.htmlURL)
        self.id = user.id
    }
}
