//
//  ViewGIFRouter.swift
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

@objc protocol ViewGIFRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ViewGIFDataPassing {
    var dataStore: ViewGIFDataStore? { get }
}

class ViewGIFRouter: NSObject, ViewGIFRoutingLogic, ViewGIFDataPassing {
    weak var viewController: ViewGIFViewController?
    var dataStore: ViewGIFDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: ViewGIFViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: ViewGIFDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
