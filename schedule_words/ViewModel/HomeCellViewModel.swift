//
//  HomeCellViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import Foundation
import UIKit

class HomeCellViewModel {
    let wordBook: WordBook
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
    }
    
    var tagCircleLabelString: String {
        let dateGap = CalendarService.shared.getDaysFromToday(date: wordBook.createdAt)
        
        switch dateGap {
        case 0:
            return "오늘"
        case 1:
            return "어제"
        case 2:
            return "그제"
        default:
            return "+\(dateGap)일"
        }
    }
    
    var tagCircleColor: CGColor {
        let dateGap = CalendarService.shared.getDaysFromToday(date: wordBook.createdAt)
        
        if dateGap == 0 {
            return UIColor.green.cgColor
        } else if dateGap == 1 {
            return UIColor.yellow.cgColor
        } else if dateGap == 2 {
            return UIColor.red.cgColor
        } else if dateGap <= 7 {
            return UIColor.green.cgColor
        } else if dateGap <= 14 {
            return UIColor.yellow.cgColor
        } else if dateGap <= 28 {
            return UIColor.red.cgColor
        } else {
            return UIColor.black.cgColor
        }
    }
    
    var dateLabelString: String {
        let date = wordBook.createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: date)
    }
    
    var numOfWordsLabelString: String {
        let numOfWords = wordBook.words.count
        return "\(numOfWords)단어"
    }
    
    var passRatioLabelString: String {
        let numOfPassedWords = wordBook.words.filter { word in
            word.testResult == .success
        }.count
        
        let numOfTotalWords = wordBook.words.count
        
        guard numOfTotalWords != 0 else { return "0%" }
        
        let passRatio = (Double(numOfPassedWords) / Double(numOfTotalWords)) * 100
        
        return "\(Int(passRatio))%"
    }
}
