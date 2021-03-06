//
//  Medication.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/17/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation

struct Medication {
    let name: String
    var reminder: Bool
    var dosage: String?
    // time.
}


struct Dosage {
    let quantity: Int
}

extension Dosage: Hashable {
    var hashValue: Int {
        return quantity.hashValue
    }
}

extension Dosage: Equatable {
    static func ==(lhs: Dosage, rhs: Dosage) -> Bool {
        return lhs.quantity == rhs.quantity
    }
}
