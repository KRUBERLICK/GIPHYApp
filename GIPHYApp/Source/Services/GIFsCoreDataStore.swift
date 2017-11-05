//
//  GIFsCoreDataStore.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

enum GIFsCoreDataStoreError: Error {
    case gifNotFound(gifID: String)
}

class GIFsCoreDataStore: GIFsStoreProtocol {
    private static let modelName = "GIPHYApp"
    private static let storeName = "GIPHYApp.sqlite"
    private let managedObjectContext: NSManagedObjectContext
    private let localURLProvider: LocalURLProvider

    init(localURLProvider: LocalURLProvider) {
        self.localURLProvider = localURLProvider
        guard let modelURL = Bundle.main.url(forResource: GIFsCoreDataStore.modelName, withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing managed object model from \(modelURL)")
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        let storeURL = localURLProvider.documentsDirectory.appendingPathComponent(GIFsCoreDataStore.storeName)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch let error {
            fatalError("Error migrating store: \(error)")
        }
    }

    deinit {
        do {
            try managedObjectContext.save()
        } catch let error {
            fatalError("Error saving managed object context: \(error)")
        }
    }

    func clearStore() -> Observable<Bool> {
        return performDeleteRequest(fetchRequestPredicate: nil)
    }
    
    func deleteGIFs(withQuery query: String) -> Observable<Bool> {
        let requestPredicate = NSPredicate(format: "query == %@", query)
        return performDeleteRequest(fetchRequestPredicate: requestPredicate)
    }
    
    private func performDeleteRequest(fetchRequestPredicate predicate: NSPredicate?) -> Observable<Bool> {
        return Observable.create { observer in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedGIF.entityName)
            fetchRequest.predicate = predicate
            do {
                let results = try self.managedObjectContext.fetch(fetchRequest) as! [ManagedGIF]
                for managedGIF in results {
                    self.managedObjectContext.delete(managedGIF)
                }
                try self.managedObjectContext.save()
                observer.onNext(true)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func fetchGIFs() -> Observable<[GIF]> {
        return performGIFsFetchRequest(fetchRequestPredicate: nil)
    }

    func fetchGIFs(withQuery query: String) -> Observable<[GIF]> {
        let requestPredicate = NSPredicate(format: "query == %@", query)
        return performGIFsFetchRequest(fetchRequestPredicate: requestPredicate)
    }
    
    func performGIFsFetchRequest(fetchRequestPredicate predicate: NSPredicate?) -> Observable<[GIF]> {
        return Observable.create { observer in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedGIF.entityName)
            fetchRequest.predicate = predicate
            do {
                let results = try self.managedObjectContext.fetch(fetchRequest) as! [ManagedGIF]
                let gifs = results.map { $0.toGIF() }
                observer.onNext(gifs)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func deleteGIF(withID gifID: String) -> Observable<Bool> {
        return Observable.create { observer in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedGIF.entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", gifID)
            do {
                let results = try self.managedObjectContext.fetch(fetchRequest) as! [ManagedGIF]
                if let managedGIFToDelete = results.first {
                    self.managedObjectContext.delete(managedGIFToDelete)
                } else {
                    observer.onError(GIFsCoreDataStoreError.gifNotFound(gifID: gifID))
                }
                try self.managedObjectContext.save()
                observer.onNext(true)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func addGIF(_ gif: GIF) -> Observable<Bool> {
        return Observable.create { observer in
            let managedGIF = NSEntityDescription.insertNewObject(forEntityName: ManagedGIF.entityName, into: self.managedObjectContext) as! ManagedGIF
            managedGIF.fromGIF(gif)
            do {
                try self.managedObjectContext.save()
                observer.onNext(true)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func updateGIF(_ gif: GIF) -> Observable<Bool> {
        return Observable.create { observer in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedGIF.entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", gif.id)
            do {
                let results = try self.managedObjectContext.fetch(fetchRequest) as! [ManagedGIF]
                if let managedGIFToUpdate = results.first {
                    managedGIFToUpdate.fromGIF(gif)
                    try self.managedObjectContext.save()
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onError(GIFsCoreDataStoreError.gifNotFound(gifID: gif.id))
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
