//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

@MainActor
final class AccountDetailViewModel: ObservableObject {
    // Solde Total du compte
    @Published var totalAmount: String = ""
    // Transaction récentes
    @Published var recentTransactions: [Transaction] = []
    // Message d'erreur
    @Published var errorMessage: String?
    //En cas d'un chargement en cours
    @Published var isLoading: Bool = false
    
    // Toutes les transactions
    private(set) var  allTransactions: [Transaction] = []
    
    private let accountRepository : AccountRepository
    
    
    init(
        accountRepository: AccountRepository = AccountRepository (
            executeDataRequest: URLSession.shared.data(for:)
        )
    ) {
        self.accountRepository = accountRepository
    }
    
    
    // Appelée au changement de la vue
    func fetchAccountDetails() {
        isLoading = true
        errorMessage = nil
        Task{
            do {
                // appel de l'api via le repository
                let account = try await accountRepository.fetchAccount()
                // stockage de solde
                totalAmount = formatAmount(account.currentBalance)
                // Stockage de toutes les transactions
                allTransactions = account.transactions
                // Limitation à 3 transactions récentes
                recentTransactions = Array(account.transactions.prefix(3))
            } catch {
                errorMessage = "Impossible de récuperer les informations du compte"
            }
            isLoading = false
        }
    }
    
    // Formater en double pour le montant monétaire
    private func formatAmount (_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter.string(from: NSNumber(value: amount)) ?? "€0.00"
    }
}
