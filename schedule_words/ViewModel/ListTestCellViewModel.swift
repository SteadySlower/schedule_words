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
}
