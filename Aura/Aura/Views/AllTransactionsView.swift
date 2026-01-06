//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Jaouad on 15/12/2025.
//

import SwiftUI

struct AllTransactionsView: View {
    // le viewModel qui contient les data
    @StateObject  var viewModel : AllTransactionViewModel
    
    let gradientStart = Color(hex: "#94A684").opacity(0.7)
    let gradientEnd = Color(hex: "#94A684").opacity(0.0)
    
    // initialisation pour accépter ou non les transaction pré-rechargées
    init(preloadedTransactions: [Transaction]? = nil) {
        _viewModel = StateObject(
            wrappedValue: AllTransactionViewModel(preloadedTransactions: preloadedTransactions)
        )
    }
    
    var body: some View {
        ZStack{
            // le font avec le dégradé en vert
            LinearGradient(
                gradient: Gradient(colors: [gradientStart, gradientEnd]),
                startPoint: .top,
                endPoint: .bottomLeading
            )
            
            .ignoresSafeArea()
            
            // changement de contenu selon la situation
            Group {
                // En cours de chargement
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                }
                // Si erreur
                else if let errorMessage = viewModel.errorMessage{
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .foregroundStyle(.secondary)
                        Button("Réessayer"){
                            viewModel.loadTransactions()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                // Si pas de transactions
                else if viewModel.transactions.isEmpty {
                    ContentUnavailableView(
                        "Aucune transaction",
                        systemImage: "tray",
                        description: Text("affichage des transactions")
                    )
                }
                else {
                    // On affiche la liste des transactions
                    VStack{
                        // le Header
                        VStack{
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 40))
                                .foregroundColor(Color(hex: "#94A684"))
                            
                            Text("All Transactions")
                                .font(.headline)
                                .padding([.horizontal])
                            
                            Text("\(viewModel.transactions.count) transactions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        
                        // La list des transactions
                        List(viewModel.transactions){ transaction in
                            TransactionLineView(transaction: transaction)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                    }
                }
            }
        }
        //  .navigationTitle("All Transactions")
        //  .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            // Quand la vue apparait, on essaie de charger les transactions
            viewModel.loadTransactions()
        }
    }
}


#Preview {
    NavigationView{
        AllTransactionsView()
    }
}
