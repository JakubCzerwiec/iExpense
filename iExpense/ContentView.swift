//
//  ContentView.swift
//  iExpense
//
//  Created by Mój Maczek on 11/10/2024.
//

import SwiftUI
// Identifiable - need property id and will be Identifiable across app. Codable - allowes to save and read to/from UserDefaults
struct ExpenseItem: Identifiable, Codable {
    var id = UUID() // creates unice id 
    let name: String
    let type: String
    let amount: Double
}

// Observable - class can be shared across the views
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {        // if something changes, it will safe it to UserDefaults
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {    // when app starts, it will read from UserDefaults
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []  // if there's nothing in UserDefaults, it will return empty arr
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false // condtion for showing second view
        
    var body: some View {
        NavigationStack {
            List {
                Section{           // this id: \.id can be deleted when struct of items is Identifiable
                    ForEach(expenses.items, id: \.id) { item in
                        if item.type == "Personal" {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundColor(item.amount < 20 ? .green : item.amount > 90 ? .red : .orange)
                            }
                        }
                    }
                    .onDelete(perform: removeItems) // triggers deleting elements from list
                }
                Section {
                    ForEach(expenses.items, id: \.id) { item in
                        if item.type == "Bussines" {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundColor(item.amount < 20 ? .green : item.amount > 90 ? .red : .orange)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }


            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: expenses)
                } label: {
                    Image(systemName: "plus")
                }
//                Button("Add epxence", systemImage: "plus") {
//                    showingAddExpense = true // changing condition for showing second View
//
//                }
            }

            
            
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)  // showing second view and sends data from expenses var
            }
        }
    }
    // function to remove elements from list on an index
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
