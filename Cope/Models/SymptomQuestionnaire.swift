//
//  SymptomQuestionnaire.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/17/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation

struct SymptomQuestionnaire {
    let question: [SymptomQuestion]
}

struct SymptomQuestion {
    let category: String
    let title: String
    let subtitle: String
    let icon: String // subject to changes
    let choices: [choiceFormat]
}

enum choiceFormat {
    case Title(String, Float)
    case TitleSubtitle(String, String, Float)
}
