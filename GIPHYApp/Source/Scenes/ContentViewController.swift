//
//  ContentViewController.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarTitleAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = navBarTitleAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = navBarTitleAttributes
    }
}
