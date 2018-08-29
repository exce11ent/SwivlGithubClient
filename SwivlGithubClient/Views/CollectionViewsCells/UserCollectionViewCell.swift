//
//  UserCollectionView.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import UIKit
import Kingfisher

protocol UserCollectionViewCellDelegate: class {
    func userDidTapProfile(url: URL)
}

class UserCollectionViewCell: UICollectionViewCell {

    struct Model {
        let avatarUrl: URL?
        let nickname: String?
        let profileUrl: URL?
    }

    static let preferredHeight: CGFloat = 120

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileUrlLabel: UILabel!

    var model: Model? {
        didSet {
            if let model = model {
                update(with: model)
            }
        }
    }

    weak var delegate: UserCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTapProfileLink(sender:)))
        profileUrlLabel.addGestureRecognizer(tap)
        profileUrlLabel.isUserInteractionEnabled = true
    }

    override func prepareForReuse() {
        avatarImageView.kf.cancelDownloadTask()
    }

    @objc func userDidTapProfileLink(sender: Any) {
        if let url = model?.profileUrl {
            delegate?.userDidTapProfile(url: url)
        }
    }

    private func update(with model: Model) {
        if let avatarUrl = model.avatarUrl {
            avatarImageView.kf.setImage(with: ImageResource(downloadURL: avatarUrl))
        }

        nicknameLabel.text = model.nickname
        profileUrlLabel.text = model.profileUrl?.absoluteString
    }
}
