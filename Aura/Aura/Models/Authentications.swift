//
//  Authentications.swift
//  Aura
//
//  Created by Jaouad on 11/12/2025.
//

import Foundation


struct AuthenticationRequest: Codable {
    let username: String
    let password: String
}

// la réponse de backend lors de l'authentification
struct AuthenticationResponse: Codable {
    let token: String
}
