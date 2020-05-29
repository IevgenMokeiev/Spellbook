//
//  FakeDataFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData
@testable import SpellBook

/// A collection of fake objects that can be used in the tests
class FakeDataFactory {

    static func provideFakeSpellDTO() -> SpellDTO {
        return fakeSpellDTO(name: "fake", path: "/api/spells/fake")
    }

    static func provideEmptySpellListDTO() -> [SpellDTO] {
        return [
            fakeSpellDTO(name: "fake1", path: "/api/spells/fake1", isEmpty: true),
            fakeSpellDTO(name: "fake2", path: "/api/spells/fake2", isEmpty: true)
        ]
    }

    static func provideFakeSpellListDTO() -> [SpellDTO] {
        return [
            fakeSpellDTO(name: "fake1", path: "/api/spells/fake1"),
            fakeSpellDTO(name: "fake2", path: "/api/spells/fake2")
        ]
    }

    static func provideFakeFavoritesListDTO() -> [SpellDTO] {
        return [fakeSpellDTO(name: "fake", path: "/api/spells/fake", isFavorite: true)]
    }

    static func provideEmptySpell(context: NSManagedObjectContext) -> Spell {
        return fakeSpell(isEmpty: true, context: context)
    }

    static func provideFakeSpell(context: NSManagedObjectContext) -> Spell {
        return fakeSpell(name: "fake", path: "/api/spells/fake", context: context)
    }

    static func provideFakeSpellList(context: NSManagedObjectContext) -> [Spell] {
        return [
            fakeSpell(name: "fake1", path: "/api/spells/fake1", context: context),
            fakeSpell(name: "fake2", path: "/api/spells/fake2", context: context)
        ]
    }

    static func provideFakeFavoritesList(context: NSManagedObjectContext) -> [Spell] {
        return [fakeSpell(name: "fake", path: "/api/spells/fake", isFavorite: true, context: context)]
    }

    static func provideFakeSpellDetailsRawData() -> Data {
        return """
        {
            "_id": "5eb89d6c0b1bb138c5676654",
            "index": "acid-arrow",
            "name": "fake",
            "desc": [
                "fake description"
            ],
            "higher_level": [
                "fake higher level"
            ],
            "range": "90 feet",
            "components": [
                "V",
                "S",
                "M"
            ],
            "material": "Powdered rhubarb leaf and an adder's stomach.",
            "ritual": false,
            "duration": "Instantaneous",
            "concentration": false,
            "casting_time": "fake time",
            "level": 1,
            "school": {
                "name": "Evocation",
                "url": "/api/magic-schools/evocation"
            },
            "classes": [
                {
                    "name": "fake classes",
                    "url": "/api/classes/wizard"
                }
            ],
            "subclasses": [
                {
                    "name": "Lore",
                    "url": "/api/subclasses/lore"
                },
                {
                    "name": "Land",
                    "url": "/api/subclasses/land"
                }
            ],
            "url": "/api/spells/fake"
        }
        """.data(using: .utf8)!
    }

    static func provideFakeSpellListRawData() -> Data {
        return """
        {
            "count": 2,
            "results": [
                {
                    "index": "acid-arrow",
                    "name": "fake1",
                    "url": "/api/spells/fake1"
                },
                {
                    "index": "acid-splash",
                    "name": "fake2",
                    "url": "/api/spells/fake2"
                }
            ]
        }
        """.data(using: .utf8)!
    }

    // MARK: - Private
    private static func fakeSpellDTO(name: String, path: String, isFavorite: Bool = false, isEmpty: Bool = false) -> SpellDTO {
        return SpellDTO(name: name, path: path, level: !isEmpty ? 1: nil, castingTime: !isEmpty ? "fake time" : nil, concentration: !isEmpty ? false : nil, classes: !isEmpty ? "fake classes" : nil, description: !isEmpty ? "fake description" : nil, higherLevel: !isEmpty ? "fake higher level" : nil, isFavorite: isFavorite)
    }

    private static func fakeSpell(name: String = "", path: String = "", isFavorite: Bool = false, isEmpty: Bool = false, context: NSManagedObjectContext) -> Spell {
        let entity = NSEntityDescription.entity(forEntityName: String(describing: Spell.self), in: context)!
        let spell = Spell(entity: entity, insertInto: context)
        guard !isEmpty else { try? context.save(); return spell }

        spell.name = name
        spell.path = path
        spell.level = 1
        spell.casting_time = "fake time"
        spell.concentration = false
        spell.classes = "fake classes"
        spell.desc = "fake description"
        spell.higherLevel = "fake higher level"
        spell.isFavorite = isFavorite
        try? context.save()

        return spell
    }
}
