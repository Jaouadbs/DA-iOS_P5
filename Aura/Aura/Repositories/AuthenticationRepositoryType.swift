//
//  AuthenticationRepositoryType.swift
//  Aura
//
//  Created by Jaouad on 31/12/2025.
//

import Foundation
// Protocole qui définit les fonctionnalités que doit avoir n'importe quel "repository"
// Pour un faux repository lors des tests
protocol AuthenticationRepositoryType {
    func login(username: String, password: String) async throws -> String
}
