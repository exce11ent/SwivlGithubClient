//
//  UserService.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import RxSwift
import Moya

protocol UserService {
    func getUsers(since: Int?) -> Observable<[User]>
    func getFollowers(userName: String) -> Observable<[User]>
}

class GithubUserService: UserService {
    func getUsers(since: Int?) -> Observable<[User]> {
        return GithubAPIProvider.rx
            .request(.users(since: since ?? 0))
            .asObservable()
            .debug()
            .map([User].self).debug()
    }

    func getFollowers(userName: String) -> Observable<[User]> {
        return GithubAPIProvider.rx
            .request(.followers(userName: userName))
            .asObservable()
            .map([User].self)
    }
}
