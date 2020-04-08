//
//  AstronautView.swift
//  project8
//
//  Created by Sc0tt on 08/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    let missions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .accessibility(hidden: true)
                    
                    VStack(alignment: .leading) {
                        Text(self.astronaut.description)
                            .layoutPriority(1)
                        
                        Text("Missions:")
                            .font(.headline)
                            .padding(.top)
                            .padding(.bottom)
                        
                        ForEach(self.missions, id: \.id) { mission in
                            Text("- \(mission.displayName)")
                        }
                        
                    }
                    .padding()
    
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut, missions: [Mission]) {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        
        self.astronaut = astronaut
        var matches = [Mission]()
        
        
        for mission in missions {
            if let _ = mission.crew.first(where: { $0.name == astronaut.id }) {
                matches.append(mission)
            } else {
                // fatalError()
            }
        }

        self.missions = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let mission: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], missions: mission)
    }
}
