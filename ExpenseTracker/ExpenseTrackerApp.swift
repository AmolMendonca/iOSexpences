//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Amol Mendonca on 27/04/24.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject var transactionistVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionistVM)
        }
    }
}
