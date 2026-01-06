//
//  TransactionLineView.swift
//  Aura
//
//  Created by Jaouad on 26/12/2025.
//

import SwiftUI

struct TransactionLineView: View {
    
    let transaction: Transaction
    
    var isCredit: Bool {
        transaction.value >= 0
    }
    
    var body: some View {
        HStack {
            Image(systemName: isCredit
                  ?"arrow.up.right.circle.fill"
                  :"arrow.down.left.circle.fill")
            .foregroundStyle(isCredit ? .green : .red)
            Text(transaction.label)
            
            Spacer()
            
            Text(transaction.amountFormatted)
                .fontWeight(.bold)
                .foregroundStyle(isCredit ? .green : .red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    let sampleTransaction = Transaction(
        value: 40.3,
        label: "Paiement Test"
    )
    TransactionLineView(transaction: sampleTransaction)
}
