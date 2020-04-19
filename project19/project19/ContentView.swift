//
//  ContentView.swift
//  project19
//
//  Created by Sc0tt on 17/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI


enum FilterBy {
    case none, accommodation, beginners, crossCountry, ecoFriendly, family
}

enum SortBy {
    case name, country, runs
}

struct ContentView: View {
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @ObservedObject var favourites = Favourites()
    
    @State private var isShowingSorting = false
    @State private var isShowingFilter = false
    
    @State private var sortBy: SortBy = .name
    @State var filterBy: FilterBy
    
    var filteredResorts: [Resort] {
        switch filterBy {
            case .none:
                return resorts
            case .accommodation:
                return resorts.filter { $0.facilities.contains("Accommodation") }
            case .beginners:
                return resorts.filter { $0.facilities.contains("Beginners")}
            case .crossCountry:
                return resorts.filter { $0.facilities.contains("Cross-country")}
            case .ecoFriendly:
                return resorts.filter { $0.facilities.contains("Eco-friendly")}
            case .family:
                return resorts.filter { $0.facilities.contains("Family")}
            }
    }
    
    var sortedResorts: [Resort] {
        switch sortBy {
        case .name:
            return filteredResorts.sorted(by: { $0.name < $1.name })
        case .country:
            return filteredResorts.sorted(by: { $0.country < $1.country })
        case .runs:
            return filteredResorts.sorted(by: { $1.runs < $0.runs })
            
        }
    }
    
    var body: some View {
        NavigationView  {
            List(sortedResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favourites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favourite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(leading: Button(action: {
                self.isShowingSorting = true
            }) {
                    Image(systemName: "arrow.up.arrow.down.circle")
                    Text("Sort")
                        .actionSheet(isPresented: $isShowingSorting) {
                            ActionSheet(title: Text("Sort By"), message: nil, buttons: [
                                .default(Text("Name")) { self.sortBy = .name },
                                .default(Text("Country")) { self.sortBy = .country },
                                .default(Text("Runs")) { self.sortBy = .runs },
                                .cancel()
                            ])
                        }
                }, trailing: Button(action: {
                        self.isShowingFilter = true
                    }) {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                            Text("Facilities")
                                .actionSheet(isPresented: $isShowingFilter) {
                                    ActionSheet(title: Text("Filter By"), message: nil, buttons: [
                                        .default(Text("None")) { self.filterBy = .none },
                                        .default(Text("Accommodation")) { self.filterBy = .accommodation },
                                        .default(Text("Beginners")) { self.filterBy = .beginners },
                                        .default(Text("Cross Country")) { self.filterBy = .crossCountry },
                                        .default(Text("Eco-Friendly")) { self.filterBy = .ecoFriendly },
                                        .default(Text("Family")) { self.filterBy = .family },
                                        .cancel()
                                    ])
                                }
                    }
            )
            
            WelcomeView()
        }
    .environmentObject(favourites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(filterBy: .none)
    }
}
