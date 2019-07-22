//
//  FollowersViewModel.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

protocol FollowersViewModelDelegate: RemoteDataLoadingDelegate {}

protocol FollowersCoordinating {
    func showProfileUrl(_ url: URL)
    func showUser(with viewModel: UserViewModel)
}

class FollowersViewModel {

    let userViewModel: UserViewModel
    let userService: UserService
    var screenTitle: String {
        return userViewModel.nickname
    }

    weak var delegate: FollowersViewModelDelegate?
    var viewModels: [ListDiffable] = []

    private var requestDisposable: Disposable?
    var isLoading = false
    var hasLoadedAll = false
    var currentPage: Int = 1

    private var usersSectionViewModel: UsersSectionViewModel? {
        return viewModels.first(where: { item in
            item is UsersSectionViewModel
        }) as? UsersSectionViewModel
    }

    private let coordinator: FollowersCoordinating

    init(userViewModel: UserViewModel, coordinator: FollowersCoordinating, userService: UserService = GithubUserService()) {
        self.userViewModel = userViewModel
        self.coordinator = coordinator
        self.userService = userService
        reloadViewModels()
    }

    private func reloadViewModels() {
        viewModels.removeAll()
        viewModels.append(UserSectionViewModel(userViewModel: userViewModel))
        viewModels.append(UsersSectionViewModel())
    }

    func loadMore() {
        guard !isLoading && !hasLoadedAll else { return }

        isLoading = true

        let paginator = PageDescriptor(page: currentPage, perPage: 20)

        requestDisposable = userService
            .getFollowers(userName: userViewModel.nickname, paginator: paginator)
            .subscribe { [weak self] event in
                switch event {
                case .next(let users):
                    if users.count < paginator.perPage {
                        self?.hasLoadedAll = true
                    }

                    self?.usersSectionViewModel?.viewModels.append(contentsOf: users.map { UserViewModel(user: $0) })
                    self?.delegate?.didFinishLoading()
                    self?.currentPage += 1
                case .completed:
                    break
                case .error(let error):
                    self?.delegate?.didFailLoadingWith(error: error)
                }

                self?.isLoading = false
        }
    }

    func reloadData() {
        requestDisposable?.dispose()
        reloadViewModels()
        hasLoadedAll = false
        currentPage = 1
        loadMore()
    }

    func selectUser(with viewModel: UserViewModel) {
        coordinator.showUser(with: viewModel)
    }

    func selectProfileUrl(_ url: URL) {
        coordinator.showProfileUrl(url)
    }
}
