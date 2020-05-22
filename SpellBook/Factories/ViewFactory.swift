//
//  ViewFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import SwiftUI

typealias SpellListViewConstructor = () -> SpellListView
typealias FavoritesViewConstructor = () -> FavoritesView
typealias SpellDetailViewConstructor = (_ path: String) -> SpellDetailView

/// Factory to construct SwiftUI views
protocol ViewFactory {
    func createTabbarView() -> TabbarView
    func createSpellListView() -> SpellListView
    func createSpellDetailView(path: String) -> SpellDetailView
    func createFavoritesView() -> FavoritesView
}

class ViewFactoryImpl: ViewFactory {

    let interactor: Interactor

    init(interactor: Interactor) {
        self.interactor = interactor
    }

    func createTabbarView() -> TabbarView {
        let viewModel = TabbarViewModel(spellListConstructor: { self.createSpellListView()
        }) { self.createFavoritesView()
        }
        return TabbarView(viewModel: viewModel)
    }

    func createSpellListView() -> SpellListView {
        let viewModel = SpellListViewModel(publisherConstructor: { self.interactor.spellListPublisher() }, refinementsBlock: { self.interactor.refine(spells: $0, sort: $1, searchTerm: $2)
        }) { self.createSpellDetailView(path: $0) }
        return SpellListView(viewModel: viewModel)
    }

    func createSpellDetailView(path: String) -> SpellDetailView {
        let viewModel = SpellDetailViewModel(publisher: interactor.spellDetailsPublisher(for: path), saveBlock: { self.interactor.saveSpell($0) })
        return SpellDetailView(viewModel: viewModel)
    }

    func createFavoritesView() -> FavoritesView {
        let viewModel = FavoritesViewModel(publisherConstructor: { self.interactor.favoritesPublisher()
        }, spellDetailViewConstructor: { self.createSpellDetailView(path: $0)
        })
        return FavoritesView(viewModel: viewModel)
    }
}
