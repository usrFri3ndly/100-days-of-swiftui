//
//  FilteredList.swift
//  project12
//
//  Created by Sc0tt on 30/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    //var singers: FetchedResults<T> { fetchRequest.wrappedValue }
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }
    
    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
         fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Singer.firstName, ascending: true)], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}
