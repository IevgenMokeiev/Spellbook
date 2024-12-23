//
//  CustomTypes.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 18.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//
import Combine

typealias SpellListPublisher = AnyPublisher<[SpellDTO], CustomError>
typealias SpellDetailPublisher = AnyPublisher<SpellDTO, CustomError>
typealias NoErrorSpellListPublisher = AnyPublisher<[SpellDTO], Never>
