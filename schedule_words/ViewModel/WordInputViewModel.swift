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
    
    mutating func setSpelling(spelling: String) {
        self.spelling = spelling
    }
    
    mutating func addMeaning(newMeaning: String) throws {
        // 에러: 뜻이 이미 3개 이상일 때
        guard meanings.count < 3 else {
            throw WordInputError.tooManyMeanings
        }
        
        // 에러: 한글이 아닌 뜻을 입력할 때
        guard Utilities().validateMeaningInput(input: newMeaning) == true else {
            throw WordInputError.meaningValidationFailure
        }
        
        meanings.append(newMeaning)
    }
    
    mutating func removeMeaning(at index: Int) {
        meanings.remove(at: index)
    }
    
    func addNewWord() throws {
        if spelling == "" {
            throw WordInputError.noWord
        }
        
        if meanings.isEmpty {
            throw WordInputError.noMeaning
        }
        
        let meaningInputs = meanings.map { meaning in
            MeaningInput(description: meaning)
        }
        
        let wordInput = WordInput(spelling: spelling, meanings: meaningInputs)
        
        let result = WordService.shared.insertTodayWord(word: wordInput)
        
        if !result {
            throw WordInputError.dbError
        }
    }
}
