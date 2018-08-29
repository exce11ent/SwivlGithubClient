//
//  UsersViewController.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Helen Marlen. All rights reserved.
//

import UIKit
import IGListKit

class UsersViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    var viewModel: UsersViewModel!

    convenience init(viewModel: UsersViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
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

extension UsersViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let objects: [ListDiffable] = []
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is UsersSectionViewModel {
            return UsersSectionController()
        }
        return ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension UsersViewController: UIScrollViewDelegate {
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

extension UsersViewController: UsersViewModelDelegate {
    func didFinishLoading() {
        adapter.reloadData(completion: nil)
        refreshControl.endRefreshing()
    }

    func didFailLoadingWith(error: Error) {
        refreshControl.endRefreshing()
    }
}


