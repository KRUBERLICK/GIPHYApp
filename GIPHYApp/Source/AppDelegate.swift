//
//  AppDelegate.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let dataStore = GIFsCoreDataStore(localURLProvider: LocalURLProvider())
//        let gif = GIF(id: "12345", url: nil, localGIFData: nil)
//        _ = dataStore.addGIF(gif).subscribe()
        _ = dataStore.fetchGIFs()
            .subscribe(onNext: { results in

            }, onError: { error in

            })
        return true
    }
}

