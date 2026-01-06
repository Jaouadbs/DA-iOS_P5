//
//  Account.swift
//  Aura
//
//  Created by Jaouad on 15/12/2025.
//

import Foundation


// Account

struct Account: Codable {
    // solde actuel du compte
    let currentBalance: Double
    // Liste complète des transactions
    let transactions : [Transaction]
}

// Transation
struct Transaction: Codable, Identifiable {
    let id = UUID()

    // Montant de la transaction
    let value: Double
    // Libellé de la transation
    let label : String

    // On indique ce qui vient du JSON
    enum CodingKeys: String, CodingKey {
        case value
        case label
    }

    // Formatage du montant
    var amountFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter.string(from: NSNumber(value: value)) ?? "€0.00"
    }
}
