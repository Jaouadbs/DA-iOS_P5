//
//  MockURLSession.swift
//  Aura
//
//  Created by Jaouad on 30/12/2025.
//

import Foundation

/// Mock pour simuler URLSession
final class MockURLSession {
    enum MockResult {
        case success (Data)
        case failure (Error)
    }
    /// Résultat simulé de la requête réseau
    var result: MockResult?

    /// Méthode qui imite URLSession.data
    func data(for request: URLRequest) async throws -> (Data,URLResponse){
        // Si aucun résultat n'est pas défini renvoi une erreur
        guard let result = result else {
            throw URLError(.badServerResponse)
        }

        switch result {
        case .success(let data):
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data, response)
            
        case .failure(let error):
            throw error
        
        }
    }
}
