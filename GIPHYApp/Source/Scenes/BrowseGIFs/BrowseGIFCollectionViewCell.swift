//
//  BrowseGIFCollectionViewCell.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/3/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import UIKit
import FLAnimatedImage

class BrowseGIFCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gifImageView: FLAnimatedImageView!

    private(set) lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        contentView.addSubview(loadingIndicatorView)
        loadingIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
