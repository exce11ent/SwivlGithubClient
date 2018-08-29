//
//  UsersSectionViewModel.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation
import IGListKit

class UsersSectionViewModel {
    var sectionId = UUID().uuidString
    var viewModels: [UserViewModel] = []
}

extension UsersSectionViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return sectionId as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UsersSectionViewModel else {
            return false
        }
        return sectionId == object.sectionId
    }
}
