//
//  SearchDescriptor.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation

struct SearchDescriptor {
    let query: String
    let order = "desc"

    func asParameters() -> [String: Any] {
        return [ "q": query,
                 "order": order]
    }
}
