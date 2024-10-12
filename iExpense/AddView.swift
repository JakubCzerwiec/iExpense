//
//  AddView.swift
//  iExpense
//
//  Created by Mój Maczek on 12/10/2024.
//

import SwiftUI


struct AddView: View {
    @Environment(\.dismiss) var dismiss // this needs to be added for dismiss() to work (line 40)

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses // creating empty arr of expenses conforming to Expenses class
    
    let types = ["Bussines", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss() // exiting view when tapped
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses()) // expenses: Expenses() is like 'import'
}
