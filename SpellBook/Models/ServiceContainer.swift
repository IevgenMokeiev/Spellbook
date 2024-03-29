//
//  ServiceContainer.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import UIKit
import Combine

/// Provides services
protocol ServiceContainer {
  var spellProviderService: SpellProviderService { get }
  var refinementsService: RefinementsService { get }
}

struct ServiceContainerImpl: ServiceContainer {
  let spellProviderService: SpellProviderService
  let refinementsService: RefinementsService
  
  init() {
    let translationService = TranslationServiceImpl()
    let coreDataStack = CoreDataStackImpl()
    let databaseClient = DatabaseClientImpl(coreDataStack: coreDataStack)
    let databaseService = DatabaseServiceImpl(databaseClient: databaseClient, translationService: translationService)
    let networkService = NetworkServiceImpl(networkClient: NetworkClientImpl())
    spellProviderService = SpellProviderServiceImpl(databaseService: databaseService, networkService: networkService)
    refinementsService = RefinementsServiceImpl()
    
    if CommandLine.arguments.contains("enable-testing") {
      coreDataStack.cleanupStack()
    }
  }
}
