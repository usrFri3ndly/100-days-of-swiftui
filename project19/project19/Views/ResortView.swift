//
//  ResortView.swift
//  project19
//
//  Created by Sc0tt on 17/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var favourites: Favourites
    
    @State private var selectedFacility: Facility?
    
    let resort: Resort
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                        .overlay(ImageCredit(resort: resort), alignment: .bottomTrailing)
                }
                
                Group {
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            VStack {
                                ResortDetailsView(resort: resort)
                            }
                            VStack {
                                SkiDetailsView(resort: resort)
                            }
                            Spacer()
                        } else {
                            ResortDetailsView(resort: resort)
                            Spacer().frame(height: 0)
                            SkiDetailsView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                    
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    //Text(resort.facilities.joined(separator: ", "))
                    //Text(ListFormatter.localizedString(byJoining: resort.facilities))
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                                    //print(self.selectedFacility)
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            Button(favourites.contains(resort) ? "Remove from Favourites" : "Add to Favourites") {
                    if self.favourites.contains(self.resort) {
                        self.favourites.remove(self.resort)
                    } else {
                        self.favourites.add(self.resort)
                    }
            }
            .padding()
        }
        .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
        
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
