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

class FollowersViewModel {

    let userViewModel: UserViewModel
    let userService: UserService

    weak var delegate: FollowersViewModelDelegate?
    var viewModels: [ListDiffable] = []

    private var requestDisposable: Disposable?
    var isLoading = false
    var currentPage: Int = 1

    private var usersSectionViewModel: UsersSectionViewModel? {
        return viewModels.first(where: { item in
            item is UsersSectionViewModel
        }) as? UsersSectionViewModel
    }

    init(userViewModel: UserViewModel, userService: UserService) {
        self.userViewModel = userViewModel
        self.userService = userService
        reloadViewModels()
    }

    private func reloadViewModels() {
        viewModels.removeAll()
        viewModels.append(UserSectionViewModel(userViewModel: userViewModel))
        viewModels.append(UsersSectionViewModel())
    }

    func loadMore() {
        guard !isLoading else { return }

        isLoading = true

        let paginator = PageDescriptor(page: currentPage, perPage: 20)

        requestDisposable = userService
            .getFollowers(userName: userViewModel.nickname, paginator: paginator)
            .subscribe { [weak self] event in
                switch event {
                case .next(let users):
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
        currentPage = 1
        loadMore()
    }
}
