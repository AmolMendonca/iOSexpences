//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Amol Mendonca on 29/04/24.
//

import Foundation
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    init() {
        getTransactions()
    }
    
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Log the URL of the request
            print("Fetching data from URL: \(url.absoluteString)")
            
            // Check for errors or no data
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            // Log the fetched data size
            print("Data fetched, size: \(data.count) bytes")
            
            // Decode the JSON into an array of Transactions
            do {
                let decodedTransactions = try JSONDecoder().decode([Transaction].self, from: data)
                DispatchQueue.main.async {
                    self.transactions = decodedTransactions
                    // Log each transaction in detail
                    //                    self.logTransactions()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume() // Don't forget to call resume() to start the task
        
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        return groupedTransactions
    }

//    private func logTransactions() {
//        transactions.forEach { transaction in
//            print("""
//            Transaction ID: \(transaction.id)
//            Date: \(transaction.date)
//            Institution: \(transaction.institution)
//            Account: \(transaction.account)
//            Merchant: \(transaction.merchant)
//            Amount: \(transaction.amount)
//            Type: \(transaction.type)
//            Category ID: \(transaction.categoryId)
//            Category: \(transaction.category)
//            Pending: \(transaction.isPending)
//            Transfer: \(transaction.isTransfer)
//            Expense: \(transaction.isExpense)
//            Edited: \(transaction.isEdited)
//            """)
//        }
    }
