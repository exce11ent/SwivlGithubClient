//
//  UserService.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import RxSwift
import Moya

class UserService {
    func getUsers() -> Observable<[User]> {
        return GithubAPIProvider.rx
            .request(.users)
            .asObservable()
            .map(UsersResponse.self)
            .map { $0.users }
    }

    func getFollowers(userName: String) -> Observable<[User]> {
        return GithubAPIProvider.rx
            .request(.followers(userName: userName))
            .asObservable()
            .map(UsersResponse.self)
            .map { $0.users }
    }
}
