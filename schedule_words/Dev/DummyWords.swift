//
//  DummyWords.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation
import UIKit
import CoreData

fileprivate let cakeMeaning = MeaningInput(description: "케이크")
fileprivate let cake = WordInput(spelling: "cake", meanings: [cakeMeaning])

fileprivate let runMeaning1 = MeaningInput(description: "달리다")
fileprivate let runMeaning2 = MeaningInput(description: "운영하다")
fileprivate let run = WordInput(spelling: "run", meanings: [runMeaning1, runMeaning2])

fileprivate let goMeaning = MeaningInput(description: "가다")
fileprivate let go = WordInput(spelling: "go", meanings: [goMeaning])

fileprivate let loveMeaning = MeaningInput(description: "사랑")
fileprivate let love = WordInput(spelling: "love", meanings: [loveMeaning])

fileprivate let makeMeaning1 = MeaningInput(description: "만들다")
fileprivate let makeMeaning2 = MeaningInput(description: "해내다")
fileprivate let makeMeaning3 = MeaningInput(description: "벌다")
fileprivate let make = WordInput(spelling: "make", meanings: [makeMeaning1, makeMeaning2, makeMeaning3])

fileprivate let complicatedMeaning = MeaningInput(description: "복잡한")
fileprivate let complicated = WordInput(spelling: "complicated", meanings: [complicatedMeaning])

fileprivate let luckyMeaning = MeaningInput(description: "운이 좋은")
fileprivate let lucky = WordInput(spelling: "lucky", meanings: [luckyMeaning])

fileprivate let today = Date()
fileprivate let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
fileprivate let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)!

fileprivate let dayPlusWeek = Calendar.current.date(byAdding: .day, value: -7, to: today)!
fileprivate let dayPlusTwoWeeks = Calendar.current.date(byAdding: .day, value: -14, to: today)!
fileprivate let dayPlusMonth = Calendar.current.date(byAdding: .day, value: -28, to: today)!

fileprivate let dummyTodayWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: today)
fileprivate let dummyYesterdayWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: yesterday)
fileprivate let dummyDayBeforeYesterdayWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayBeforeYesterday)

fileprivate let dummyWeekWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayPlusWeek)
fileprivate let dummyTwoWeekWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayPlusTwoWeeks)
fileprivate let dummyMonthWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayPlusMonth)

fileprivate let studyDummyBooks = [dummyTodayWordBook, dummyYesterdayWordBook, dummyDayBeforeYesterdayWordBook]
fileprivate let reviewDummyBooks = [dummyWeekWordBook, dummyTwoWeekWordBook, dummyMonthWordBook]

class DummyDataWriter {
    let dao = WordDAO.shared
    
    func writeDummyData() {
        resetCoreData()
        
        studyDummyBooks.forEach { wordBookInput in
            _ = dao.insertWordBook(wordBook: wordBookInput, status: .study)
        }
        reviewDummyBooks.forEach { wordBookInput in
            _ = dao.insertWordBook(wordBook: wordBookInput, status: .review)
        }
    }
    
    // 코어데이터 리셋
    private func resetCoreData() {
        // container 가져오기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storeContainer =
        appDelegate.persistentContainer.persistentStoreCoordinator

        for store in storeContainer.persistentStores {
            try! storeContainer.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
        }
        
        // 컨테이너 다시 만들기
        appDelegate.persistentContainer = NSPersistentContainer(
            name: "schedule_words"
        )
        
        // 로드하면 다시 만들어짐
        appDelegate.persistentContainer.loadPersistentStores {
            (store, error) in
        }
    }
}
