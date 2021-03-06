//
//  ContentView.swift
//  project8
//
//  Created by Sc0tt on 07/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(mission.formattedLaunchDate)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("Mission Name: \(mission.displayName). Launch Date: \(mission.formattedLaunchDate)"))
                }
            }
            .navigationBarTitle("Moonshoot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
