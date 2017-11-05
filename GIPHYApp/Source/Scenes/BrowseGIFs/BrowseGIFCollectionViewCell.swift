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
    var onLocalGIFDataRetrieved: ((Data) -> ())?

    var gif: GIF? {
        didSet {
            guard let gif = gif else {
                return
            }
            if let localGIFData = gif.localGIFData {
                DispatchQueue.main.async {
                    self.gifImageView.animatedImage = FLAnimatedImage(animatedGIFData: localGIFData)
                    self.loadingIndicatorView.isHidden = true
                    self.gifImageView.isHidden = false
                }
            }
            else {
                DispatchQueue.main.async {
                    self.gifImageView.isHidden = true
                    self.loadingIndicatorView.isHidden = false
                }
                DispatchQueue(label: "com.kruberlick.GIPHYApp.GIFDownloadQueue", qos: .utility).async {
                    do {
                        let gifData = try Data(contentsOf: gif.url!)
                        let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
                        DispatchQueue.main.async {
                            self.onLocalGIFDataRetrieved?(gifData)
                            self.loadingIndicatorView.isHidden = true
                            self.gifImageView.animatedImage = animatedImage
                            self.gifImageView.isHidden = false
                        }
                    } catch let error {
                        print("Error reading gif data from url \(gif.url!), error: \(error)")
                    }
                }
            }
        }
    }

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
