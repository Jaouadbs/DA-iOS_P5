//
//  AuthenticationRepositories.swift
//  Aura
//
//  Created by Jaouad on 11/12/2025.
//

import Foundation

struct AuthenticationRepository {
    // injecetion de la couche réseau (testable)
    
    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)
    
    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.executeDataRequest = executeDataRequest
    }
    // Appel API pour authentifier l'utilisateur
    // Return le token
    func login(username: String, password: String  ) async throws -> String {
        guard let url = URL(string: "http://127.0.0.1:8080/auth") else {
            throw URLError(.badURL)
        }
        //
        let request  = try URLRequest(
            url: url,
            method: .POST,
            parameters: [
                "username" : username,
                "password" : password
            ]
        )
        let (data, _) = try await executeDataRequest(request)
        
        let reponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
        return reponse.token
        
        
    }
}

extension AuthenticationRepository: AuthenticationRepositoryType {}
