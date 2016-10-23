//
//  SymptomQuestionnaire.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/17/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation

struct SymptomQuestion {
    let category: String
    let title: String
    let subtitle: String
    let icon: String // subject to changes
    let choices: [choiceFormat]
    
    init(category: String, title: String, subtitle: String, icon: String, choices: [choiceFormat]) {
        self.category = category
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.choices = choices
    }
}

struct SymptomAnswer {
    let category: String
    let answer: String
    let value: Float
}

struct SurveyRecord {
    let date: Date
    var answers: [SymptomAnswer]?
    let score: Double
}

enum choiceFormat {
    case Title(String, Float)
    case TitleSubtitle(String, String, Float)
}


struct SymptomQuestionnaire {
    let questions: [SymptomQuestion]
    
    init?() {
        guard let path = Bundle.main.path(forResource: "Questions", ofType: "plist"), let questions = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
            return nil
        }
        
        var tempQuestions = [SymptomQuestion]()
        
        for quest in questions {
            var cF = [choiceFormat]()
            guard let choices = quest["questionChoices"] as? [[String: AnyObject]] else {
                return nil
            }
            
            for choice in choices {
                if choice["choiceSubtitle"] != nil {
                    cF.append(choiceFormat.TitleSubtitle(choice["choiceTitle"] as! String, choice["choiceSubtitle"] as! String, Float(choice["choiceValue"]! as! NSNumber)))
                } else {
                    cF.append(choiceFormat.Title(choice["choiceTitle"] as! String, Float(choice["choiceValue"]! as! NSNumber)))
                }
            }
            
            tempQuestions.append(SymptomQuestion(category: quest["questionCategory"] as! String,
                                                  title: quest["questionTitle"] as! String,
                                                  subtitle: quest["questionSubtitle"] as! String,
                                                  icon: quest["questionIcon"] as! String,
                                                  choices: cF))
        }
        
        self.questions = tempQuestions
        
    }
}
