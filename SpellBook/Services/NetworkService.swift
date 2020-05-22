//
//  NetworkService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import Combine

typealias NetworkSpellPublisher = AnyPublisher<[SpellDTO], NetworkServiceError>
typealias NetworkSpellDetailPublisher = AnyPublisher<SpellDTO, NetworkServiceError>

struct Response: Codable {
    public let results: [SpellDTO]
}

private enum Endpoints: String {
    case spellList = "http://dnd5eapi.co/api/spells"
    case spellDetails = "http://dnd5eapi.co"
}

public enum NetworkServiceError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponseStatusCode
    case sessionFailed(Error)
    case other(Error)
}

/// Service responsible for network communication
protocol NetworkService {
    func spellListPublisher() -> NetworkSpellPublisher
    func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher
}

class NetworkServiceImpl: NetworkService {

    let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func spellListPublisher() -> NetworkSpellPublisher {
        guard let url = URL(string: Endpoints.spellList.rawValue) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return networkClient.endpointPublisher(for: url, decodingType: Response.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher {
        guard let url = URL(string: Endpoints.spellDetails.rawValue + path) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return networkClient.endpointPublisher(for: url, decodingType: SpellDTO.self)
    }
}
