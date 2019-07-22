//
//  FollowersCoordinator.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 7/22/19.
//  Copyright © 2019 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

final class FollowersListCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let userViewModel: UserViewModel

    init(navigationController: UINavigationController, userViewModel: UserViewModel) {
        self.navigationController = navigationController
        self.userViewModel = userViewModel
    }

    override func start() -> Observable<Void> {
        let followersViewModel = FollowersViewModel(userViewModel: userViewModel, coordinator: self)
        let followersViewController = FollowersViewController(viewModel: followersViewModel)
        navigationController.pushViewController(followersViewController, animated: true)

        return Observable.never()
    }
}

extension FollowersListCoordinator: FollowersCoordinating {
    func showProfileUrl(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        navigationController.present(safari, animated: true, completion: nil)
    }

    func showUser(with viewModel: UserViewModel) {
        let _ = coordinate(to: FollowersListCoordinator(
            navigationController: navigationController,
            userViewModel: viewModel
        ))
    }
}

