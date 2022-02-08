//
//  WordInputViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/08.
//

import Foundation

struct WordInputViewModel {
    private var spelling: String = ""
    private var meanings: [String] = []
    
    var numOfMeanings: Int {
        return meanings.count
    }
    
    var meaningLabelText: (String?, String?, String?) {
        var meaningsSlice = meanings[meanings.indices]
        
        let firstMeaning = meaningsSlice.popFirst()
        let secondMeaning = meaningsSlice.popFirst()
        let thirdMeaning = meaningsSlice.popFirst()
        
        return (firstMeaning, secondMeaning, thirdMeaning)
    }
    
    mutating func addMeaning(newMeaning: String) -> WordInputError? {
        // 에러: 뜻이 이미 3개 이상일 때
        guard meanings.count < 3 else { return .tooManyMeanings }
        
        // 에러: 한글이 아닌 뜻을 입력할 때
        guard Utilities().validateMeaningInput(input: newMeaning) == true else { return .meaningValidationFailure }
        
        meanings.append(newMeaning)
        return nil
    }
    
    mutating func removeMeaning(at index: Int) {
        meanings.remove(at: index)
    }
}
