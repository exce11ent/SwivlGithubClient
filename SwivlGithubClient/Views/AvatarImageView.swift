//
//  AvatarImageView.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import UIKit

class AvatarImagView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = bounds.height / 2
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }

}

