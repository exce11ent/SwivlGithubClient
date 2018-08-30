//
//  ShortProfileCollectionViewCell.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/30/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import Kingfisher

class ShortProfileCollectionViewCell: UICollectionViewCell {

    struct Model {
        let avatarUrl: URL?
        let title: String
    }

    static let preferredHeight: CGFloat = 150

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var model: Model? {
        didSet {
            if let model = model {
                update(with: model)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.kf.cancelDownloadTask()
    }

    private func update(with model: Model) {
        titleLabel.text = model.title

        if let avatarUrl = model.avatarUrl {
            avatarImageView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: avatarUrl)
            avatarImageView.kf.setImage(with: resource, options: [.transition(.fade(0.1))])
        }
    }
}
