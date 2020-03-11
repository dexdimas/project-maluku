//
//  ViewController.swift
//  Project Maluku
//
//  Created by Andimas Bagaswara on 10/03/20.
//  Copyright © 2020 Andimas Bagaswara. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var totalSentimentLabel: UILabel!
    
    let sentimentClassifier = SentimentModel_Sanders()
    
    var multiples: [Int] = []
    
    var contents: [Content] = [
        Content(date: "March 2nd, 2020", body: "I met someone new that I wanted to know", sentiment: 4),
        Content(date: "March 3rd, 2020", body: "I met no one", sentiment: 2),
        Content(date: "March 6th, 2020", body: "I met that guy again", sentiment: 0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContentCell", bundle: nil), forCellReuseIdentifier: "ReuseableCell")
        
        textField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        textField.delegate = self
        
        let totalSentiment = calculateEmotion()
        totalSentimentLabel.text = "\(totalSentiment)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 40
    }

    @IBAction func postPressed(_ sender: UIButton) {
        var tempContent = ""
        if let contentBody = textField.text {
            tempContent = contentBody
        }

        let date = Date()
        let daySuffix = findDaySuffix(from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d'\(daySuffix)', yyyy"
        
        var tempSentiment = 0
        let prediction = try! sentimentClassifier.prediction(text: tempContent)
        if prediction.label == "Pos" {
            tempSentiment = 4
        } else if prediction.label == "Neutral" {
            tempSentiment = 2
        } else {
            tempSentiment = 0
        }

        contents.append(Content(date: dateFormatter.string(from: date), body: tempContent, sentiment: tempSentiment))
        
        let emotionRating = calculateEmotion()
        totalSentimentLabel.text = "\(emotionRating)"
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func findDaySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func calculateEmotion() -> Int {
        for content in contents {
            if content.sentiment == 4 {
                multiples.append(1)
            } else if content.sentiment == 0 {
                multiples.append(-1)
            }
        }
        
        let sum = multiples.reduce(0, +)
        
        return sum
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath)
        as! ContentCell
        cell.contentLabel.text = contents[indexPath.row].body
        cell.dateLabel.text = contents[indexPath.row].date
        if contents[indexPath.row].sentiment == 4 {
            cell.sentimentBarImageView.image = #imageLiteral(resourceName: "SentimentBar_Positive")
        } else if contents[indexPath.row].sentiment == 2 {
            cell.sentimentBarImageView.image = #imageLiteral(resourceName: "SentimentBar_Neutral")
        } else {
            cell.sentimentBarImageView.image = #imageLiteral(resourceName: "SentimentBar_Negative")
        }
        return cell
    }
}

