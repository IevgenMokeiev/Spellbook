//
//  SpellListView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 08.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

struct SpellListView: View {

    var dataLayer: DataLayer?
    var viewFactory: ViewFactory?
    @State var spells: [SpellDTO] = []

    var body: some View {
        NavigationView {
            List(spells) { spell in
                NavigationLink(destination: self.viewFactory?.provideSpellDetailView(spell: spell)) {
                    Text(spell.name)
                }
            }
            .accessibility(label: Text("Spell Table View"))
            .accessibility(identifier: "SpellTableView")
            .onAppear(perform: loadData)
            .navigationBarTitle("Spell Book", displayMode: .inline)
        }
    }

    // MARK: - Loading
    private func loadData() {
        dataLayer?.retrieveSpellList { result in
            if case .success(let spellList) = result {
                self.spells = spellList
            }
        }
    }
}

struct SpellListView_Previews: PreviewProvider {
    static var previews: some View {
        return SpellListView(dataLayer: AppModule.provideDataLayer())
    }
}
