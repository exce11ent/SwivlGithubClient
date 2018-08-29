//
//  UsersSectionController.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import IGListKit

class UsersSectionController: ListSectionController {

    var viewModels: [UserViewModel] = []

    override func numberOfItems() -> Int {
        return viewModels.count
    }

    override func didUpdate(to object: Any) {
        if let object = object as? UsersSectionViewModel {
            self.viewModels = object.viewModels
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else { return UICollectionViewCell() }
        let cell = context.dequeueReusableCell(of: UserCollectionViewCell.self, for: self, at: index) as! UserCollectionViewCell
        let viewModel = viewModels[index]
        cell.model = UserCollectionViewCell.Model(avatarUrl: viewModel.avatarUrl,
                                                  nickname: viewModel.nickname,
                                                  profileUrl: viewModel.profileLink)
        cell.delegate = self
        return cell
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = self.collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: UserCollectionViewCell.preferredHeight)
    }
}

extension UsersSectionController: UserCollectionViewCellDelegate {
    func userDidTapProfile(url: URL) {

    }
}
