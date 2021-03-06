//
//  ContentView.swift
//  project4
//
//  Created by Sc0tt on 13/02/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                    
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")) {
                    
                    Stepper(value: $coffeeAmount, in: 0...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
                
                Section(header: Text("Recommended bedtime") .font(.headline)) {
                    Text("\(calculateBedtime)")
                        .font(.title)
                }
            }
                
        .navigationBarTitle("BetterRest")
            
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var calculateBedtime: String {
        
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        // use 0 if hour or minute cant be read
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        var recommendedBedtime: String
        
        do {
            let predition = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
    
            let sleepTime = wakeUp - predition.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            recommendedBedtime = formatter.string(from: sleepTime)
            
            } catch {

                recommendedBedtime = "Sorry, there was a problem calculating your bedtime."
            }
        
        return recommendedBedtime
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
