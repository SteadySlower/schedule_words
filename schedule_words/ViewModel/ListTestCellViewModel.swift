//
//  ListTestCellViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

struct ListTestCellViewModel {
    let word: Word
    
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
}
