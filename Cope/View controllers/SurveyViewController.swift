//
//  SurveyViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/6/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

struct SurveyQuestion {
    var questionTitle: String
    var questionSubtitle: String
    var choices: [String: (String, Float)]
}


private let surveyHeaderReuseIdentifier = "SurveyHeaderView"
private let surveyCellReuseIdentifier = "SurveyOptionCell"

class SurveyViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    var surveyQuestion: SurveyQuestion?
    var questionnaire: SymptomQuestionnaire?
    var surveyQuestion: SymptomQuestion?
    var currentQuestion: Int?
    
//    var results: [String: (String, Float)] = [String: (String, Float)]()
    var answers: [SymptomAnswer] = [SymptomAnswer]()
    
    var delegate: SurveyViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        questionnaire = SymptomQuestionnaire()
        if questionnaire != nil {
            surveyQuestion = questionnaire?.questions.first
            currentQuestion = 0
        }
        
        collectionView?.delegate = self
        self.navigationItem.title = NSLocalizedString(surveyQuestion!.category, comment: "Question title for \(surveyQuestion!.category)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveyQuestion!.choices.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: surveyCellReuseIdentifier, for: indexPath) as! SurveyOptionCell
        
        switch surveyQuestion!.choices[(indexPath as NSIndexPath).item] {
        case .Title(let title, _):
            cell.titleLabel.text = NSLocalizedString(title, comment: "Choice label for \(title)")
        case .TitleSubtitle(let title, _, _):
             cell.titleLabel.text = NSLocalizedString(title, comment: "Choice label for \(title)")
        }
    
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.15
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SurveyHeaderView", for: indexPath) as! SurveyHeaderReusableView
            headerView.headerTitle.text = NSLocalizedString(surveyQuestion!.title, comment: "Question title for \(surveyQuestion!.title)")
            headerView.headerSubtitle.text = NSLocalizedString(surveyQuestion!.subtitle, comment: "Question title for \(surveyQuestion!.subtitle)")
            headerView.iconView.image = UIImage(named: surveyQuestion!.icon)!
            return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 2.5
        return CGSize(width: picDimension, height: picDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 12
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let chosenChoice = surveyQuestion!.choices[indexPath.item]
        
        switch chosenChoice {
        case .Title(let title, let value):
            answers.append(SymptomAnswer(category: surveyQuestion!.category, answer: title, value: value))
        
        case .TitleSubtitle(let title, _, let value):
            answers.append(SymptomAnswer(category: surveyQuestion!.category, answer: title, value: value))
        }
        
        if currentQuestion != questionnaire!.questions.count - 1 {
            currentQuestion = (questionnaire?.questions.index(after: currentQuestion!))!
            surveyQuestion = questionnaire?.questions[currentQuestion!]
            self.navigationItem.title = NSLocalizedString(surveyQuestion!.category, comment: "Question title for \(surveyQuestion!.category)")

            collectionView.reloadData()
        } else {
            // send data back
            delegate?.surveyFinished(answers: answers)
        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


}

protocol SurveyViewControllerDelegate {
    func surveyFinished(answers: [SymptomAnswer])
}
