//
//  RootCollectionViewController.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import IGListKit

class RootCollectionViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshControlFired),
                                 for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true

        self.automaticallyAdjustsScrollViewInsets = false
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
    }

    @objc func refreshControlFired() {
    }

    func loadMoreData() {

    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > scrollView.frame.height else {
            return
        }
        let screenHeigh = UIScreen.main.bounds.height
        let distance = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.height)

        if distance < screenHeigh {
            loadMoreData()
        }
    }

    func showError(error: Error) {
        let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}


