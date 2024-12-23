//
//  AppCoordinator.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

class AppCoordinator {
    let viewFactory: ViewFactory

    init(configureForTesting: Bool = false) {
        let translationServiceImpl = TranslationServiceImpl()
        let coreDataStackImpl = CoreDataStackImpl()
        let databaseClientImpl = DatabaseClientImpl(coreDataStack: coreDataStackImpl)
        let databaseServiceImpl = DatabaseServiceImpl(databaseClient: databaseClientImpl, translationService: translationServiceImpl)
        let networkServiceImpl = NetworkServiceImpl(networkClient: NetworkClientImpl())
        let refinementsServiceImpl = RefinementsServiceImpl()
        let interactor = InteractorImpl(databaseService: databaseServiceImpl, networkService: networkServiceImpl, refinementsService: refinementsServiceImpl)
        viewFactory = ViewFactory(interactor: interactor)

        if configureForTesting {
            coreDataStackImpl.cleanupStack()
        }
    }
}
