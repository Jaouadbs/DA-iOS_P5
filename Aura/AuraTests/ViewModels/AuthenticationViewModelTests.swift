//
//  AuthenticationViewModelTests.swift
//  Aura
//
//  Created by Jaouad on 30/12/2025.
//

import XCTest
@testable import Aura

@MainActor
final class AuthenticationViewModelTests: XCTestCase{
    
    /// Test : Email invalide
    func test_email_validation_invalid() {
        
        // Given
        // On crée le ViewModel avec un repository mocké
        let viewModel = AuthenticationViewModel(
            authenticationRepository: MockAuthenticationRepository(), onLoginsuccess: {}
        )
        
        viewModel.username = "invalid"
        viewModel.password = "password"
        
        // Then
        // Le formulaire ne doit pas être  valide
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    /// Test :  Mot de passe vide
    func test_password_empty() {
        
        // Given
        let viewModel = AuthenticationViewModel(
            authenticationRepository: MockAuthenticationRepository(), onLoginsuccess: {}
        )
        
        viewModel.username = "test@mail.com"
        viewModel.password = ""
        
        // Then
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    /// Login réussi
    func test_login_success_saves_token() async {
        
        //Given
        // On crée un mock de repository
        let mockRepo = MockAuthenticationRepository()
        mockRepo.shouldSucceed = true
        
        // Permet d'attendre un événement async
        let expectation = expectation(description: "Login success")
        
        let viewModel = AuthenticationViewModel(
            authenticationRepository: mockRepo
        ){
            // appelée quand le login réussit
            expectation.fulfill()
        }
        viewModel.username = "test@mail.com"
        viewModel.password = "password"
        
        // When
        // On déclenche le login
        viewModel.login()
        
        // Then
        // On attend que la callback de succès soit appelée
        await fulfillment(
            of: [expectation],
            timeout: 1
        )
        // Aucune erreur ne doit être affichée
        XCTAssertNil(viewModel.errorMessage)
    }
}
