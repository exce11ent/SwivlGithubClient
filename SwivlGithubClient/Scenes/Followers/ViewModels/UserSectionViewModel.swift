//
//  UserSectionViewModel.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation
import IGListKit

class UserSectionViewModel {
    let sectionId = UUID().uuidString
    let userViewModel: UserViewModel

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
}

extension UserSectionViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return sectionId as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UserSectionViewModel else {
            return false
        }
        return sectionId == object.sectionId
    }
}
