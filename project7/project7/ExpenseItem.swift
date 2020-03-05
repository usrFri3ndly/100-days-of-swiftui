//
//  ExpenseItem.swift
//  project7
//
//  Created by Sc0tt on 04/03/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}
