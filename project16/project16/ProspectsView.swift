//
//  ProspectsView.swift
//  project16
//
//  Created by Sc0tt on 11/04/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

enum SortBy {
    case name, mostRecent
}

struct ProspectsView: View {
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var isShowingSorting = false
    
    // default sort
    @State private var sortBy: SortBy = .name
    let filter: FilterType
    
    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case.contacted:
                return "Contacted People"
            case .uncontacted:
                return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter { $0.isContacted }
            case .uncontacted:
                return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var sortedProspects: [Prospect] {
        switch sortBy {
            case .name:
            return filteredProspects.sorted(by: { $0.name < $1.name })
          case .mostRecent:
            return filteredProspects.sorted(by: { $0.dateAdded > $1.dateAdded })
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        self.filter == .none ? Image(systemName:(
                            prospect.isContacted ? "checkmark.circle" : "questionmark.diamond"))
                                .foregroundColor(Color(prospect.isContacted ? .green : .orange)) : nil
                            
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading:
                Button(action : {
                    self.isShowingSorting = true
                }) {
                        Image(systemName: "arrow.up.arrow.down.circle")
                        Text("Sort")
                    }, trailing:
                Button(action : {
                    self.isShowingScanner = true
                }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    })
            
            .actionSheet(isPresented: $isShowingSorting) {
                ActionSheet(title: Text("Sort By"), message: nil, buttons: [
                    .default(Text("Name")) { self.sortBy = .name },
                    .default(Text("Most Recent")) { self.sortBy = .mostRecent },
                    .cancel()
                ])
            }
            
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
            case .success(let code):
                let details = code.components(separatedBy: "\n")
                guard details.count == 2 else { return }
                
                let person = Prospect()
                person.name = details[0]
                person.emailAddress = details[1]
                
                //self.prospects.people.append(person)
                //self.prospects.save()
                self.prospects.add(person)
            case .failure(let error):
                print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            //var dateComponents = DateComponents()
            //dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
