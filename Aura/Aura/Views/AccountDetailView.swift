//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var viewModel: AccountDetailViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Large Header displaying total amount
                VStack(spacing: 10) {
                    Text("Your Balance")
                        .font(.headline)
                    
                    Text(viewModel.totalAmount)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(hex: "#94A684")) // Using the green color you provided
                    
                    Image(systemName: "eurosign.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(Color(hex: "#94A684"))
                }
                .padding(.top)
                
                // Display recent transactions (Max 3)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .padding([.horizontal])
                    
                    ForEach(viewModel.recentTransactions) { transaction in
                        TransactionLineView(transaction: transaction)
                            .padding(.horizontal)
                    }
                }
                
                // Button to see details of transactions
                // Button remplacé par navigation Link
                // on passe les transactions déja chargées (viewModel.allTransactions); pas besoin de refaire l'appel
                NavigationLink (
                    destination: AllTransactionsView(
                        preloadedTransactions: viewModel.allTransactions
                    )
                ) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("See Transaction Details")
                    }
                    .padding()
                    .background(Color(hex: "#94A684"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding([.horizontal, .bottom])
                
                Spacer()
            }
            .navigationTitle("Balance")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                self.endEditing(true)  // This will dismiss the keyboard when tapping outside
            }
            .onAppear{
                // quand la vue apparait, on charge les infos de compte
                viewModel.fetchAccountDetails()
            }
        }
        .tint(.black)
    }
}

#Preview {
    AccountDetailView(viewModel: AccountDetailViewModel())
}
