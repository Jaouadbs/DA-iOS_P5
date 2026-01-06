//
//  TransferRepositoryTests.swift
//  Aura
//
//  Created by Jaouad on 30/12/2025.
//


import XCTest
@testable import Aura

final class TransferRepositoryTests: XCTestCase{

    /// Test : Le transfert fonctionne correctement
    func test_transfer_success() async throws{
        // Given
        // Simuler un utilisateur connecté
        AuthenticationToken.shared.token = "fake_token"
        // Réponse JSON vide (le backend ne renvoie rien d'important ici)
        let json = "{}".data(using: .utf8)!

        // Session réseau simulée
        let mockSession = MockURLSession()
        mockSession.result = .success(json)

        // Repository avec la session mockée
        let repository = TransfertRepository(
            executeDataRequest: mockSession.data(for:)
        )

        // When
        // On appelle la fonction transfer
        try await repository.transfer(
            recipient: "test@mail.com",
            amount: 100
        )
        // Then
        // Si aucune erreur n'est levée, le test passe
        XCTAssertTrue(true)

        // nettoyage apres le test
        AuthenticationToken.shared.token = nil
    }

    /// Test : Erreur serveur lors du transfert
    func test_transfer_server_error() async {
        //Given
        let mockSession = MockURLSession()
        mockSession.result = .failure(URLError(.badServerResponse))

        let repository = TransfertRepository(
            executeDataRequest: mockSession.data(for:)
        )

        // When / Then
        do {
            try await repository.transfer(
                recipient: "test",
                amount:100
            )
            XCTFail("Une erreur était attendue mais le transfert à réussi")
        } catch {
            // l'erreur est attendue -> test OK
            XCTAssertTrue(true)
        }

    }
}
