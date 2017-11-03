//
//  BrowseGIFsSectionController.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/3/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import IGListKit
import FLAnimatedImage

class BrowseGIFsSectionController: ListSectionController {
    var viewModel: BrowseGIFs.FetchGIFs.ViewModel.Item
    private let dependencies: Dependencies

    init(viewModel: BrowseGIFs.FetchGIFs.ViewModel.Item, dependencies: Dependencies) {
        self.viewModel = viewModel
        self.dependencies = dependencies
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width / 3
        return CGSize(width: width, height: width)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "GIFCell", for: self, at: index) as! BrowseGIFCollectionViewCell
        let url = viewModel.gif.localURL ?? viewModel.gif.url
        if let url = url {
            cell.gifImageView.isHidden = true
            cell.loadingIndicatorView.isHidden = false
            DispatchQueue(label: "com.kruberlick.GIPHYApp.GIFDownloadQueue", qos: .utility).async {
                do {
                    let gifData = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        cell.loadingIndicatorView.isHidden = true
                        cell.gifImageView.animatedImage = FLAnimatedImage(animatedGIFData: gifData)
                        cell.gifImageView.isHidden = false
                    }
                } catch let error {
                    print("Error reading gif data from url \(url), error: \(error)")
                }
            }
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        guard let object = object as? BrowseGIFs.FetchGIFs.ViewModel.Item else {
            return
        }
        viewModel = object
    }

    override func didSelectItem(at index: Int) {

    }

    struct Dependencies {

    }
}
