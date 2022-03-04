//
//  WordService.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/03.
//

import Foundation
import CloudKit

struct WordService {
    static let shared = WordService()
    
    private let dao = WordDAO.shared
    
    // 홈 화면에 표시될 상태 표시
    func fetchTodayWordBookTuple() -> (studyWordBooks: [WordBook], reviewWordBooks: [WordBook]) {
        let studyWordBooks = dao.fetchWordBooks(status: .study)
        let reviewWordBooks = dao.fetchWordBooks(status: .review)
        return  (studyWordBooks: studyWordBooks, reviewWordBooks: reviewWordBooks)
    }
    
    // 오늘 단어장 만들기 -> 앱 실행시 User Default에 저장된 오늘 날짜 확인해보고 다르면 새로운 단어장 만들때 사용
    func createTodayWordBook() -> Bool {
        let today = CalendarService.shared.today
        let input = WordBookInput(words: [], createdAt: today)
        return dao.insertWordBook(wordBook: input, status: .study)
    }
    
    // 오늘의 단어장에 단어 넣기
    func insertTodayWord(word: WordInput) -> Bool {
        let today = CalendarService.shared.today
        
        guard let todayWordBookID = dao.findWordBookID(createdAt: today) else {
            return false
        }
        
        let result = dao.insertWord(word: word, WordBookID: todayWordBookID)
        
        return result
    }
    
    // testResult 업데이트하기
    func updateTestResult(word: Word) -> Bool {
        let id = word.id
        let testResult = word.testResult
        return dao.updateTestResult(id: id, testResult: testResult)
    }
    
    // testResult에 맞추어 단어장 처리하기
    func finishWordBook(wordBook: WordBook) -> Bool {
        // 틀린 단어들 오늘 단어장으로 옮기는 작업
        let todayWords = wordBook.words.filter { word in
            word.testResult != .success
        }
        
        // TODO: forEach 도중에 false가 오면 error 처리
        todayWords.forEach { word in
            _ = dao.moveWordToToday(word: word)
        }
        
        // 맞은 단어만 남은 단어장 복습 횟수 및 다음 복습 날짜 수정
        return dao.finishWordBook(wordBookID: wordBook.id)
        
    }
    
    // 날짜 넘어갔을 때 실행할 코드
    func setForNewDay() -> Bool {
        guard CalendarService.shared.isDayChanged else { return false }
        
        // 학습 날짜 지난 단어장은 복습 단어장으로 보내기
        let studyWordBooks = dao.fetchWordBooks(status: .study)
        
       studyWordBooks
            .filter { wordBook in wordBook.isPassedStudyDay }
            .forEach { wordBook in _ = finishWordBook(wordBook: wordBook) }
        
        // 오늘 단어장 만들기
        let todayID = dao.findWordBookID(createdAt: CalendarService.shared.today)
        
        if todayID == nil {
            guard createTodayWordBook() else { return false }
        }
        return true
    }
    
    // 단어 수정하기
    func editWord(id: String, wordInput: WordInput) -> Bool {
        return dao.editWord(id: id, wordInput: wordInput)
    }
    
    // 단어장 by id
    
    func fetchWordBookByID(id: String) -> WordBook? {
        return dao.fetchWordBookByID(id: id)
    }
}
