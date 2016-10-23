//
//  SummaryCollectionViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/6/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import Firebase
import Charts

private let reuseIdentifier = "chartCell"

class SummaryCollectionViewController: UICollectionViewController {

    let userID = "tester"
    let surveyData = DatabaseConstants.surveyData
    var dataRef: FIRDatabaseReference!
    
    var suppliedData: [String: [String: Int]] = [String: [String: Int]]()
    var categories: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRef = FIRDatabase.database().reference().child("users").child(userID).child(surveyData)
        
        
        guard let path = Bundle.main.path(forResource: "Questions", ofType: "plist"), let questions = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
            return
        }
        
        for quest in questions {
            var choiceHolder = [String: Int]()
            
            guard let choices = quest["questionChoices"] as? [[String: AnyObject]] else {
                return
            }
            
            for choice in choices {
                choiceHolder[choice["choiceTitle"] as! String] = 0
            }
            
            suppliedData[quest["questionCategory"] as! String] = choiceHolder
            categories.append(quest["questionCategory"] as! String)
        }
        
//         deconstruct device day
        let today = Date()
        let usedCalendar = Calendar(identifier: .gregorian)

        let weekAgo = (usedCalendar as NSCalendar).date(byAdding: .weekOfYear, value: -1, to: today, options: .wrapComponents)
        
        DatabaseConstants.fetchSurveyDataForTimePeriod(userID: userID, start: weekAgo!, end: today) { (snapshot) in
            guard let requestedData = snapshot.value as? [String: Any] else {
                return
            }
            
            for (_, record) in requestedData {
                let dayRecord = record as! [String: Any]
                
                for (category, answer) in dayRecord {
                    if let requestedCategory = self.suppliedData[category]?[record as! String] {
                        self.suppliedData[category]?[record as! String] = requestedCategory
                    }
                }
            }
            
        }
        
//        var evaluatedDate = weekAgo!
//        while evaluatedDate.compare(today) != .orderedSame {
//            print(fmt.string(from: evaluatedDate))
//            evaluatedDate = usedCalendar.date(byAdding: .day, value: 1, to: evaluatedDate)!
//            let evaluatedDateComponents = (usedCalendar as NSCalendar).components([.year, .month, .day], from: evaluatedDate)
////            DatabaseConstants.fetchDataForDate(userID: userID, year: evaluatedDateComponents.year!, month: evaluatedDateComponents.month!, day: evaluatedDateComponents.day!, completion: { (snapshot) in
////                debugPrint(snapshot)
////                
////                guard snapshot.value != nil else {
////                    return
////                }
////                
////                guard let requestedDayData = snapshot.value as? NSDictionary else {
////                    return
////                }
////                for (category, value) in requestedDayData {
////                    if let requestedCategory = self.suppliedData[category as! String]?[value as! String] {
////                        print("Requested category found!")
////                        self.suppliedData[category as! String]?[value as! String] = requestedCategory + 1
////                        print("New value for value \(value) as \(requestedCategory)")
////                    }
////                }
////                debugPrint(self.suppliedData)
////            })
//            
//            
//        }
        
        self.collectionView!.backgroundColor = UIColor.init(hexString: "#F9F9F9")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(SummaryChartCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SummaryChartCell
        
        cell.chartTitle.text = NSLocalizedString(categories[indexPath.item], comment: "Localized category of measure")
        
        var dataEntries: [BarChartDataEntry] = []
        var answers: [String?] = []
        
        let dataForCell = suppliedData[categories[indexPath.item]]!
        var xIndex = 0
        
        for (answer, count) in dataForCell {
//            let dataEntry = BarChartDataEntry(value: Double(count), xIndex: xIndex)
            let dataEntry = BarChartDataEntry(x: Double(xIndex), y: Double(count))
            dataEntries.append(dataEntry)
            answers.append(answer)
            xIndex = xIndex + 1
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
//        let chartData = BarChartData(xVals: answers, dataSet: chartDataSet)
        let chartData = BarChartData(dataSet: chartDataSet)
        cell.barChartView.data = chartData

        // Configure the cell
    
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
