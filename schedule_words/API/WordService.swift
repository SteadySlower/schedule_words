//
//  WordService.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/03.
//

import Foundation

struct WordService {
    static let shared = WordService()
    
    let dao = WordDAO.shared
    
    // 홈 화면에 표시될 상태 표시
    func fetchTodayWordBookTuple() -> (studyWordBooks: [WordBook], reviewWordBooks: [WordBook]) {
        let studyWordBooks = dao.fetchWordBooks(status: .study)
        let reviewWordBooks = dao.fetchWordBooks(status: .review)
        return  (studyWordBooks: studyWordBooks, reviewWordBooks: reviewWordBooks)
    }
    
    // 오늘 단어장 만들기 -> 앱 실행시 User Default에 저장된 오늘 날짜 확인해보고 다르면 새로운 단어장 만들때 사용
    func createTodayWordBook() -> Bool {
        let today = Date()
        let input = WordBookInput(words: [], createdAt: today)
        return dao.insertWordBook(wordBook: input, status: .study)
    }
    
    // 오늘의 단어장에 단어 넣기
    func insertTodayWord(word: WordInput) -> Bool {
        let today = Date()
        
        guard let todayWordBookID = dao.findWordBookID(createdAt: today) else {
            return false
        }
        
        let result = dao.insertWord(word: word, WordBookID: todayWordBookID)
        
        return result
    }
}
