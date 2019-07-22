//
//  AppCoordinator.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 7/22/19.
//  Copyright © 2019 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let usersListCoordinator = UsersListCoordinator(window: window)
        return coordinate(to: usersListCoordinator)
    }
}
