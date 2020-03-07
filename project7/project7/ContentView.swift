//
//  ContentView.swift
//  project7
//
//  Created by Sc0tt on 03/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try?
                encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items")
        {
            let decoder = JSONDecoder()
            
            if let decoded = try?
                decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    
    // watch object for changes
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("£\(item.amount)")
                            .foregroundColor(self.expenseColor(item.amount))
                            // .foregroundColor(item.amount < 10 ? .green : .none)
                    }
                }
            .onDelete(perform: removeItems)
            }
        .navigationBarTitle("iExpense")
        .navigationBarItems(leading: EditButton(), trailing:
            Button(action: {
                self.showingAddExpense = true
            }) {
                    Image(systemName: "plus")
                }
            )
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: self.expenses)
                }
        }
    }
    
    func expenseColor(_ amount: Int) -> Color {
        if amount > 100 {
            return .red
        } else if amount > 50 {
            return .orange
        } else if amount > 10 {
            return .yellow
        }
            return .green
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
