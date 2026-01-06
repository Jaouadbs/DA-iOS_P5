//
//  AuthenticationToken.swift
//  Aura
//
//  Created by Jaouad on 19/12/2025.
//  Stocker le token d'authentification
//

import Foundation

final class AuthenticationToken {
    static let shared = AuthenticationToken()
    
    // token retourné par l'API
    var token: String?
    
    private init(token: String? = nil) {
        self.token = token
    }
    
}
