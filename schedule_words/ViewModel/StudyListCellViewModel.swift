//
//  ListStudyCellViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import Foundation
import UIKit

class StudyListCellViewModel {
    let word: Word
    
    init(word: Word) {
        self.word = word
    }
    
    var wordLabelText: String {
        return word.spelling
    }
    
    var meaningLabelText: String {
        var text = ""
        let numOfMeanings = word.meanings.count
        for i in 0..<numOfMeanings {
            text.append(contentsOf: word.meanings[i].description)
            if i != (numOfMeanings - 1) {
                text.append(contentsOf: "\n")
            }
        }
        return text
    }
    
    var meaningFontSize: CGFloat {
        switch word.meanings.count {
        case 1: return 30
        case 2: return 20
        case 3: return 15
        default: return 10
        }
    }
}
