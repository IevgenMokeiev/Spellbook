//
//  AppCoordinator.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Entry point for app's data layer and view factory
/// Uses dependency injection to instantiate all services in a single place
class AppCoordinator {
    let viewFactory: ViewFactory

    init(configureForTesing: Bool = false) {
        let translationServiceImpl = TranslationServiceImpl()
        let coreDataStackImpl = CoreDataStackImpl()
        let databaseServiceImpl = DatabaseServiceImpl(coreDataStack: coreDataStackImpl, translationService: translationServiceImpl)
        let networkServiceImpl = NetworkServiceImpl()
        let refinementsServiceImpl = RefinementsServiceImpl()
        let interactor = InteractorImpl(databaseService: databaseServiceImpl, networkService: networkServiceImpl, refinementsService: refinementsServiceImpl)
        self.viewFactory = ViewFactoryImpl(interactor: interactor)

        if configureForTesing {
            coreDataStackImpl.cleanupStack()
        }
    }
}
