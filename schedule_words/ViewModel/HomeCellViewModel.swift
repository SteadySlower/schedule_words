//
//  HomeCellViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import Foundation
import UIKit

struct HomeCellViewModel {
    let wordBook: WordBook
    
    var tagCircleLabelString: String {
        let dateGap = Utilities().getDaysFromToday(date: wordBook.createdAt)
        
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
        let dateGap = Utilities().getDaysFromToday(date: wordBook.createdAt)
        
        switch dateGap {
        case 0:
            return UIColor.green.cgColor
        case 1:
            return UIColor.yellow.cgColor
        case 2:
            return UIColor.red.cgColor
        default:
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
    
    var numOfStudyLabelString: String {
        return "3회독"
    }
}
