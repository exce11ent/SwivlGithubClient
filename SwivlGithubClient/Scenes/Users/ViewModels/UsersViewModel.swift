//
//  UsersViewModel.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation
import RxSwift
import IGListKit

protocol RemoteDataLoadingDelegate: class {
    func didFinishLoading()
    func didFailLoadingWith(error: Error)
}

protocol UsersViewModelDelegate: RemoteDataLoadingDelegate {}

class UsersViewModel {
    let userService: UserService

    var viewModels: [ListDiffable] = []
    private var requestDisposable: Disposable?
    var isLoading = false

    var screenTitle: String {
        return "Github users"
    }

    private var usersSectionViewModel: UsersSectionViewModel? {
        return viewModels.first(where: { item in
            item is UsersSectionViewModel
        }) as? UsersSectionViewModel
    }

    weak var delegate: UsersViewModelDelegate?

    init(userService: UserService) {
        self.userService = userService
        viewModels.append(UsersSectionViewModel())
    }

    func loadMore() {
        guard !isLoading else { return }

        isLoading = true
        let lastUserId = usersSectionViewModel?.viewModels.last?.id
        requestDisposable = userService
            .getUsers(since: lastUserId)
            .subscribe { [weak self] event in
                switch event {
                case .next(let users):
                    self?.usersSectionViewModel?.viewModels.append(contentsOf: users.map { UserViewModel(user: $0) })
                    self?.delegate?.didFinishLoading()
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
        viewModels.removeAll()
        viewModels.append(UsersSectionViewModel())
        loadMore()
    }
}


