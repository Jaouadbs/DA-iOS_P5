//
//  AccountRepositoryTests.swift
//  Aura
//
//  Created by Jaouad on 30/12/2025.
//

import XCTest
@testable import Aura

final class AccountRepositoryTests : XCTestCase{
    
    /// Test : récupération du compte avec une réponse valide
    func test_fetch_account_success() async throws {
        //Given
        // Réponse JSON valide simulée
        let json = """
            {
            "currentBalance" : 1200.5,
            "transactions": []
            }
            """.data(using: .utf8)!
        
        
        // Mock de la session réseau
        let mockSession = MockURLSession()
        mockSession.result = .success(json)
        
        // Repository utilisant le mock
        let repository = AccountRepository(
            executeDataRequest: mockSession.data(for:)
        )
        // When
        // Appel de la fonction à tester
        let account = try await repository.fetchAccount()
        
        // Then
        // Vérification du résultat
        XCTAssertEqual(account.currentBalance, 1200.5)
        XCTAssertEqual(account.transactions.count, 0)
    }
    
    /// Test : Réponse invalide (JSON incorrect)
    func test_fetch_account_invalid_reponse() async {
        
        // Given
        // JSON invalide il manque solde actuel (CurrentBalance)
        let invalidJson = """
        {}
        """.data(using: .utf8)!
        
        let mockSession = MockURLSession()
        mockSession.result = .success(invalidJson)
        
        let repository = AccountRepository(
            executeDataRequest: mockSession.data(for:)
        )
        // When / Then
        do {
            // on stocke le résultat dans une variable explicite
            let account = try await repository.fetchAccount()
            
            // Si on arrive ici, c'est une erreur ( on ne devrait pas réussir)
            XCTFail("Une erreur était attendue mais le compte à été récupéré : \(account)")
        } catch {
            // Erreur attendue -> test OK
            XCTAssertTrue(true)
        }
    }
    
    /// Test : appel sans token d'authentification
    func test_fetch_account_without_token() async {
        
        // Given
        AuthenticationToken.shared.token = nil
        
        let mockSession = MockURLSession()
        let repository = AccountRepository(
            executeDataRequest: mockSession.data(for:)
        )
        
        // When / Then
        do{
            let account = try await repository.fetchAccount()
            XCTFail("Une erreur était attendue mais un compte à été récupéré : \(account)")
        } catch {
            XCTAssertTrue(true)
        }
    }
}
