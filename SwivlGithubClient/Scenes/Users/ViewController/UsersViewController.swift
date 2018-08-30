//
//  UsersViewController.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Helen Marlen. All rights reserved.
//

import UIKit
import IGListKit
import SafariServices

class UsersViewController: RootCollectionViewController {

    var viewModel: UsersViewModel!

    convenience init(viewModel: UsersViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.beginRefreshing()
        viewModel.reloadData()

        navigationItem.title = viewModel.screenTitle
    }


    override func setupCollectionView() {
        super.setupCollectionView()
        adapter.dataSource = self
    }

    override func refreshControlFired() {
        super.refreshControlFired()
        viewModel.reloadData()
    }

    override func loadMoreData() {
        super.loadMoreData()
        viewModel.loadMore()
    }
}

extension UsersViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.viewModels
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is UsersSectionViewModel {
            let controller = UsersSectionController()
            controller.delegate = self
            return controller
        }
        return ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension UsersViewController: UsersViewModelDelegate {
    func didFinishLoading() {
        adapter.reloadData(completion: nil)
        refreshControl.endRefreshing()
    }

    func didFailLoadingWith(error: Error) {
        refreshControl.endRefreshing()
    }
}

extension UsersViewController: UsersSectionControllerDelegate {
    func didTapProfileLink(url: URL) {
        let safari = SFSafariViewController(url: url)
        navigationController?.present(safari, animated: true, completion: nil)
    }

    func didSelectUser(with viewModel: UserViewModel) {
        let followersViewModel = FollowersViewModel(userViewModel: viewModel,
                                                    userService: self.viewModel.userService)
        let followersViewController = FollowersViewController(viewModel: followersViewModel)
        navigationController?.pushViewController(followersViewController, animated: true)
    }
}


