//
//  ShortProfileSectionController.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import IGListKit

class ShortProfileSectionController: ListSectionController {

    let userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else { return UICollectionViewCell() }
        let cell = context.dequeueReusableCell(withNibName: ShortProfileCollectionViewCell.nibName,
                                               bundle: nil,
                                               for: self,
                                               at: index) as! ShortProfileCollectionViewCell

        cell.model = ShortProfileCollectionViewCell.Model(avatarUrl: userViewModel.avatarUrl,
                                                          title: "\(userViewModel.nickname)'s followers")
        return cell
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = self.collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: ShortProfileCollectionViewCell.preferredHeight)
    }
}
