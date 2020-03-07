//
//  AddView.swift
//  project7
//
//  Created by Sc0tt on 04/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    
    @State private var invalidAmountAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
        .navigationBarTitle("Add new expense")
        .navigationBarItems(trailing:
            Button("Save") {
                if let actualAmount = Int(self.amount)
                {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.invalidAmountAlert = true
                }
            })
            .alert(isPresented: $invalidAmountAlert) {
                Alert(title: Text("Invalid Amount"), message: Text("Please enter a whole number"), dismissButton: .default(Text("Continue")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
