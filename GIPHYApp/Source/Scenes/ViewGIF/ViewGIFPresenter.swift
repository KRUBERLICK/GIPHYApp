//
//  ViewGIFPresenter.swift
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

protocol ViewGIFPresentationLogic {
    func presentSomething(response: ViewGIF.Something.Response)
}

class ViewGIFPresenter: ViewGIFPresentationLogic {
    weak var viewController: ViewGIFDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: ViewGIF.Something.Response) {
        let viewModel = ViewGIF.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
