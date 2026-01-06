//
//  AllTransactionViewModel.swift
//  Aura
//
//  Created by Jaouad on 15/12/2025.
//

import Foundation

@MainActor
final class AllTransactionViewModel: ObservableObject{
    // liste des transactions à afficher
    @Published var transactions : [Transaction] = []
    // Message d'erreur en cas de problème
    @Published var errorMessage: String?
    // chargement de données
    @Published var isLoading: Bool = false
    
    // Repository pour appeler l'API
    private let accountRespository: AccountRepository
    
    
    // Avec preloadedTransactions cela permet une initialisation avec les transations déja chargées
    init(
        accountRepository: AccountRepository = AccountRepository(executeDataRequest: URLSession.shared.data(for:)), preloadedTransactions: [Transaction]? = nil
    ){
        self.accountRespository = accountRepository
        
        // Si transactions déja fournies, on les utilise directement
        if let preloadedTransactions = preloadedTransactions {
            self.transactions = preloadedTransactions
        }
    }
    
    // Fonction pour récuper toutes les transactions depuis l'API
    func loadTransactions(){
        // Si on a des transactions, pas besoin de les recharger
        if !transactions.isEmpty{
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // on lance la tache d'appel de l'API
        Task{
            do{
                let account = try await accountRespository.fetchAccount()
                
                // Maj à jour de l'interface sur le thread principal
                await MainActor.run {
                    self.transactions = account.transactions
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Impossible de charger la transaction"
                    self.isLoading = false
                }
            }
        }
    }
}
