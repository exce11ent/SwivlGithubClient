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

class FollowersViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()


    var viewModel: FollowersViewModel!

    convenience init(viewModel: FollowersViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        refreshControl.beginRefreshing()
        viewModel.reloadData()

        navigationItem.title = viewModel.screenTitle
    }


    private func setupCollectionView() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshControlFired),
                                 for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true

        self.automaticallyAdjustsScrollViewInsets = false
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    @objc func refreshControlFired() {
        viewModel.reloadData()
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

extension FollowersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > scrollView.frame.height else {
            return
        }
        let screenHeigh = UIScreen.main.bounds.height
        let distance = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.height)

        if distance < screenHeigh {
            viewModel.loadMore()
        }
    }
}

extension FollowersViewController: FollowersViewModelDelegate {
    func didFinishLoading() {
        refreshControl.endRefreshing()
        adapter.reloadData(completion: nil)
    }

    func didFailLoadingWith(error: Error) {

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



