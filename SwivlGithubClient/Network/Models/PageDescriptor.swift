//
//  PageDescriptor.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Foundation

struct PageDescriptor {
    let page: Int
    let perPage: Int

    func asParameters() -> [String : Any] {
        return ["page" : page,
                "per_page" : perPage ]
    }
}
