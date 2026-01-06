//
//  TransfertRepository.swift
//  Aura
//
//  Created by Jaouad on 15/12/2025.
//

import Foundation

struct TransfertRepository {
    // fonction injectée pour les test unitaires
    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)
    
    init(executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)) {
        self.executeDataRequest = executeDataRequest
    }
    
    // effectuer un transfert d'argent
    func transfer(recipient: String, amount: Double) async throws {
        guard let url = URL(string: "http://127.0.0.1.8080/account/transfer") else {
            throw URLError(.badURL)
        }
        // token obligatoire pour effectuer un transfert
        guard let token = AuthenticationToken.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }
        let request = try URLRequest(
            url: url,
            method: .POST,
            parameters: [
                "recipient": recipient,
                "amount": amount
            ],
            headers: ["token": token]
        )
        
        let (_, response) = try await executeDataRequest(request)
        
        // Vérifier que le reponse est  un code 200
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
