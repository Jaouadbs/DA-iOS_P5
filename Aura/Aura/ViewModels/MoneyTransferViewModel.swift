//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    @Published var isLoading : Bool = false
    
    private let transferRepository: TransfertRepository
    
    init(transferRepository: TransfertRepository = TransfertRepository()) {
        self.transferRepository = transferRepository
    }
    
    // fonction de bouton send
    func sendMoney() {
        // Réinitialisation du message
        transferMessage = ""
        
        // Vérifier si le destinataire est correct ( email ou num tel FR)
        guard isRecipientValid() else {
            transferMessage = "Le destinataire doit etre un email valide ou un numéro de tel français"
            return
        }
        
        
    }
    
    // Validation du destinataire
    
    /// Vérifier si le destinataire est un email valide ou un numero de tel FR valide
    private func isRecipientValid() -> Bool{
        // le destinataire doit être soit un email, soit un tél
        return isEmailValid(recipient) || isPhoneNumberValid(recipient)
    }
    
    /// Vérifier si c'est un email valide
    private func isEmailValid(_ email:String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Vérifier si c'est un numero de tel FR
    private func isPhoneNumberValid(_ phone: String) -> Bool {
        // Gestion de format de numero
        // garder uniquement les chiffres
        let digitsOnly = phone.filter{ $0.isNumber}
        
        // normaliser indicatif FR
        let normalized: String
        if digitsOnly.hasPrefix("33"){
            normalized = "0" + digitsOnly.dropFirst(2)
        } else if digitsOnly.hasPrefix("0033"){
            normalized = "0" + digitsOnly.dropFirst(4)
        } else {
            normalized = digitsOnly
        }
        
        // Verifie si 10 chiffres
        let phoneRegex = "^0[1-9][0-9]{8}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            .evaluate(with: normalized)
    }
    // Validation de montant
    /// Verifier si le montant est valide et de type double
    
    private func isAmountValid() -> Double? {
        // Remplacer la virgule par un point pour la conversion
        let normalizedAmount = amount.replacingOccurrences(of: ",", with: ".")
        
        // Convertir en double
        guard let value = Double(normalizedAmount) else {
            return nil
        }
        // le montant doit etre positif et supérieur à 0
        guard  value > 0 else {
            return nil
        }
        return value
    }
}
