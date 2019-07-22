//
//  UsersListCoordinator.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 7/22/19.
//  Copyright © 2019 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

final class UsersListCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private var rootNavigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let viewModel = UsersViewModel(userService: GithubUserService(), coordinator: self)
        let listViewController = UsersViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: listViewController)

        self.rootNavigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }
}

extension UsersListCoordinator: UsersCoordinating {
    func showProfileUrl(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        rootNavigationController?.present(safari, animated: true, completion: nil)
    }

    func showUser(with viewModel: UserViewModel) {
        guard let navigationController = rootNavigationController else {
            return
        }
        let _ = coordinate(to: FollowersListCoordinator(
            navigationController: navigationController,
            userViewModel: viewModel
        ))
    }
}
