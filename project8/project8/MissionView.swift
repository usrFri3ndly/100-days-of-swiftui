//
//  MissionView.swift
//  project8
//
//  Created by Sc0tt on 08/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding()
                    
                    Text("Launch Date: \(self.mission.formattedLaunchDate)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role) {
                        CrewMember in
                        NavigationLink(destination: AstronautView(astronaut: CrewMember.astronaut, missions: [Mission]())) {
                            HStack {
                                Image(CrewMember.astronaut.id)
                                .resizable()
                                .frame(width: 83, height:  60)
                                .clipShape(Capsule())
                                .overlay(Capsule()
                                    .stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(CrewMember.astronaut.name)
                                        .font(.headline)
                                    
                                    Text(CrewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
