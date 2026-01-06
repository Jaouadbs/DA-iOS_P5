//
//  MockAuthenticationRepository.swift
//  AuraTests
//
//  Created by Jaouad on 31/12/2025.
//

import Foundation
@testable import Aura

/// Mock du MockAuthenticationRepository pour les test
final class MockAuthenticationRepository: AuthenticationRepositoryType {
    
    // Configuration du comportement du mock
    var shouldSucceed: Bool = true
    var shouldThrowNetworkError : Bool = false
    var tokenToReturn: String = "mock_token_123"
    
    func  login(username: String, password: String) async throws -> String {
        if shouldThrowNetworkError{
            throw URLError(.notConnectedToInternet)
        }
        
        if shouldSucceed{
            return tokenToReturn
        } else {
            throw URLError(.userAuthenticationRequired)
        }
    }
}
