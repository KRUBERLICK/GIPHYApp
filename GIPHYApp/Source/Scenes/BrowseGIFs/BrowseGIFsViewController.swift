//
//  BrowseGIFsViewController.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright (c) 2017 KRUBERLICK. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import IGListKit

protocol BrowseGIFsDisplayLogic: class {
    func displayFetchedGIFs(viewModel: BrowseGIFs.FetchGIFs.ViewModel)
}

class BrowseGIFsViewController: ContentViewController, BrowseGIFsDisplayLogic {
    var interactor: BrowseGIFsBusinessLogic?
    var router: (NSObjectProtocol & BrowseGIFsRoutingLogic & BrowseGIFsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = BrowseGIFsInteractor()
        let presenter = BrowseGIFsPresenter()
        let router = BrowseGIFsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter

        let localURLProvider = LocalURLProvider()
        let localStore = GIFsCoreDataStore(localURLProvider: localURLProvider)
        let webService = GIPHYAPIService()
        let gifUpdatesBroadcast = GIFUpdatesBroadcast()

        interactor.worker = BrowseGIFsWorker(cache: GIFsCache(localStore: localStore, localURLProvider: localURLProvider, gifUpdatesBroadcast: gifUpdatesBroadcast), localStore: localStore, webService: webService, localURLProvider: localURLProvider, gifUpdatesBroadcast: gifUpdatesBroadcast)
        
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        let layout = ConcatCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
        collectionView.collectionViewLayout = layout
        adapter.collectionView = collectionView
        reloadFeed()
    }

    // MARK: Subviews

    @IBOutlet weak var collectionView: UICollectionView!

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.tintColor = .white
        return controller
    }()

    // MARK: Properties

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.dataSource = self
        return adapter
    }()

    // MARK: Fetch GIFs

    func reloadFeed() {
        let query = "beer"
        let request = BrowseGIFs.FetchGIFs.Request(query: query)
        interactor?.reloadFeed(request: request)
    }

    func fetchNextPage() {
        interactor?.fetchNextPage()
    }

    func displayFetchedGIFs(viewModel: BrowseGIFs.FetchGIFs.ViewModel) {
        adapter.performUpdates(animated: true, completion: nil)
    }
}

// MARK: ListAdapterDataSource

extension BrowseGIFsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let dataStore = router?.dataStore else {
            return []
        }
        return dataStore.displayedGIFs.displayedItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let object = object as? BrowseGIFs.FetchGIFs.ViewModel.Item {
            let sc = BrowseGIFsSectionController(viewModel: object, dependencies: BrowseGIFsSectionController.Dependencies())
            sc.displayDelegate = self
            return sc
        }
        fatalError("Unexpected object: \(object)")
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel(frame: .zero)
        label.text = "Nothing to show"
        return label
    }
}

extension BrowseGIFsViewController: ListDisplayDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        guard let sc = sectionController as? BrowseGIFsSectionController, sc.viewModel.gif.localURL == nil else {
            return
        }
        interactor?.cacheGIF(sc.viewModel.gif)
    }

    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {

    }

    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {

    }

    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {

    }
}
