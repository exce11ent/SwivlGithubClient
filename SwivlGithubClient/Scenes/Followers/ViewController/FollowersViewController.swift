//
//  FollowersViewController.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import IGListKit
import SafariServices

class FollowersViewController: RootCollectionViewController {

    var viewModel: FollowersViewModel!

    convenience init(viewModel: FollowersViewModel) {
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

extension FollowersViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.viewModels
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is UsersSectionViewModel {
            let controller = UsersSectionController()
            controller.delegate = self
            return controller
        } else if object is UserSectionViewModel {
            return ShortProfileSectionController(userViewModel: viewModel.userViewModel)
        }
        return ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension FollowersViewController: FollowersViewModelDelegate {
    func didFinishLoading() {
        refreshControl.endRefreshing()
        adapter.reloadData(completion: nil)
    }

    func didFailLoadingWith(error: Error) {
        refreshControl.endRefreshing()
    }
}

extension FollowersViewController: UsersSectionControllerDelegate {
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



