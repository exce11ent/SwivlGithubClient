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
    func getFollowers(userName: String, paginator: PageDescriptor) -> Observable<[User]>
}

class GithubUserService: UserService {
    func getUsers(since: Int?) -> Observable<[User]> {
        return GithubAPIProvider.rx
            .request(.users(since: since ?? 0))
            .asObservable()
            .map([User].self)
    }

    func getFollowers(userName: String, paginator: PageDescriptor) -> Observable<[User]> {
        return GithubAPIProvider.rx
            .request(.followers(userName: userName, paginator: paginator))
            .asObservable()
            .map([User].self)
    }
}
