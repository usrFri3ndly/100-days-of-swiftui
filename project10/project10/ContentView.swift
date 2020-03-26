//
//  ContentView.swift
//  project10
//
//  Created by Sc0tt on 25/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type",
                           selection: $order.type) {
                            ForEach(0..<Order.types.count, id: \.self) {
                                Text(Order.types[$0])
                            }
                    }
                    
                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn:$order.specialRquestEnabled.animation()) {
                        Text("Any specicial requests?")
                    }
                    
                    if order.specialRquestEnabled {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn:$order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
        .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
