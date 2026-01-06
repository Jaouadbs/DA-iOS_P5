//
//  AuthenticationsModels.swift
//  Aura
//
//  Created by Jaouad on 11/12/2025.
//

import Foundation


struct AuthenticationRequest: Codable {
    let username: String
    let password: String
}

struct AuthenticationResponse: Codable {
    let token: String
}
