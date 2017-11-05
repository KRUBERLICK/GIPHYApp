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
    private var _scrollDelegate: ListScrollDelegate?
    
    override var scrollDelegate: ListScrollDelegate? {
        get {
            return viewController as? ListScrollDelegate
        }
        set {
            if let viewController = viewController as? ListScrollDelegate {
                _scrollDelegate = viewController
            }
        }
    }

    init(viewModel: BrowseGIFs.FetchGIFs.ViewModel.Item, dependencies: Dependencies) {
        self.viewModel = viewModel
        self.dependencies = dependencies
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width / 2
        return CGSize(width: width, height: width)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "GIFCell", for: self, at: index) as! BrowseGIFCollectionViewCell
        let gifUpdatesBroadcast = dependencies.gifUpdatesBroadcast
        cell.onLocalGIFDataRetrieved = { [weak self] localGIFData in
            guard let strongSelf = self else {
                return
            }
            var updatedGIF = strongSelf.viewModel.gif
            updatedGIF.localGIFData = localGIFData
            gifUpdatesBroadcast.update(gif: updatedGIF)
        }
        cell.gif = viewModel.gif
        return cell
    }

    override func didUpdate(to object: Any) {
        guard let object = object as? BrowseGIFs.FetchGIFs.ViewModel.Item else {
            return
        }
        viewModel = object
    }

    override func didSelectItem(at index: Int) {
        if let vc = viewController as? BrowseGIFsDisplayLogic {
            vc.selectGIF(viewModel: BrowseGIFs.SelectGIF.ViewModel(gif: viewModel.gif))
        }
    }

    struct Dependencies {
        let gifUpdatesBroadcast: GIFUpdatesBroadcast
    }
}
