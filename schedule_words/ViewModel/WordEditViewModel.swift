//
//  WordEditViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/03.
//

import Foundation

class WordEditViewModel {
    private let id: String
    private var _spelling: String
    private var meanings: [String]
    
    init(word: Word) {
        self.id = word.id
        self._spelling = word.spelling
        var meanings = [String]()
        word.meanings.forEach { meaning in
            meanings.append(meaning.description)
        }
        self.meanings = meanings
    }
    
    var spelling: String {
        return _spelling
    }
    
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
    
    func setSpelling(spelling: String) {
        self._spelling = spelling
    }
    
    func addMeaning(newMeaning: String) throws {
        // 에러: 뜻이 이미 3개 이상일 때
        guard meanings.count < 3 else {
            throw WordInputError.tooManyMeanings
        }
        
        meanings.append(newMeaning)
    }
    
    func removeMeaning(at index: Int) {
        meanings.remove(at: index)
    }
    
    func editWord() throws {
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
        
        let result = WordService.shared.editWord(id: id, wordInput: wordInput)
        
        if !result {
            throw WordInputError.dbError
        }
    }
}
