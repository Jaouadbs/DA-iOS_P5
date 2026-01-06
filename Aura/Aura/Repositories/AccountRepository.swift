//
//  AccountRepository.swift
//  Aura
//
//  Created by Jaouad on 15/12/2025.
//

import Foundation

struct AccountRepository {
    // fonction injectée pour faciliter les tests unitaires
    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)
    
    init(executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse)) {
        self.executeDataRequest = executeDataRequest
    }
    
    // Récupère les informations  du compte utilisateur
    func fetchAccount() async throws -> Account{
        guard let url = URL(string: "http://127.0.0.1:8080/account") else {
            throw URLError(.badURL)
        }
        // token obligatoire pour se connecter
        guard let token = AuthenticationToken.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let request = try URLRequest(
            url: url,
            method: .GET,
            headers: ["token": token]
        )
        let (data, _) = try await executeDataRequest(request)
        let account = try JSONDecoder().decode(Account.self, from: data)
        return account
        
    }
}
