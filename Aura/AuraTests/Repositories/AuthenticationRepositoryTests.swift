//
//  AuthenticationRepositoryTests.swift
//  Aura
//
//  Created by Jaouad on 30/12/2025.
//
import XCTest
@testable import Aura

final class AuthenticationRepositoryTests: XCTestCase{

    func test_login_success() async throws {
        // Given : Fausse réponse JSON comme si elle venait du backend
        let json = """
            {"token":"fake_token_123"}
            """.data(using: .utf8)!

        // On crée une fausse session réseau
        let mockSession = MockURLSession()
        // Quand on l'appelle, renvoie ce JSON
        mockSession.result = .success(json)

        // Le répository utilisera notre fausse session au lieu d'Internet
        let repository = AuthenticationRepository(
            executeDataRequest: mockSession.data(for:)
        )

        // When : On appelle la méthode login
        let token = try await repository.login(
            username: "test@mail.com",
            password: "passWord"
        )

        // Then: On vérifie que le token retourné est correct
        XCTAssertEqual(token, "fake_token_123")
    }

    func test_login_invalid() async {
        // Given : Simuler erreur  de mauvais indentifiant
        let mockSession = MockURLSession()
        mockSession.result = .failure(URLError(.userAuthenticationRequired))

        let repository = AuthenticationRepository(
            executeDataRequest: mockSession.data(for:)
        )
        // When / Then
        // On s'attend à une erreur, donc on utilise do/catch
        do {
            // On stock le résultat même si on ne l'utilise pas
            let token = try await repository.login(
                username: "Wrong",
                password: "Wrong"
            )

            // Si on arrive ici, c'est une erreur
            XCTFail("Expected error but got token: \(token)")
        } catch {
            // Une erreur est bien levée; test OK
            XCTAssertTrue(true)
        }
    }

    func test_login_network_error() async {
        //Given : Erreur réseau simulée
        let mockSession = MockURLSession()
        mockSession.result = .failure(URLError(.notConnectedToInternet))

        let repository = AuthenticationRepository(
            executeDataRequest: mockSession.data(for:)
        )

        // When / Then
        do {
            let token = try await repository.login(
                username: "test",
                password: "test"
            )
            XCTFail("Expected network error but got token: \(token)")
        } catch {
            XCTAssert(true)
        }

    }
}

