//
//  DummyWords.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

//import Foundation
//import UIKit
//import CoreData
//
//fileprivate let cakeMeaning = MeaningInput(description: "케이크")
//fileprivate let cake = WordInput(spelling: "cake", meanings: [cakeMeaning])
//
//fileprivate let runMeaning1 = MeaningInput(description: "달리다")
//fileprivate let runMeaning2 = MeaningInput(description: "운영하다")
//fileprivate let run = WordInput(spelling: "run", meanings: [runMeaning1, runMeaning2])
//
//fileprivate let goMeaning = MeaningInput(description: "가다")
//fileprivate let go = WordInput(spelling: "go", meanings: [goMeaning])
//
//fileprivate let loveMeaning = MeaningInput(description: "사랑")
//fileprivate let love = WordInput(spelling: "love", meanings: [loveMeaning])
//
//fileprivate let makeMeaning1 = MeaningInput(description: "만들다")
//fileprivate let makeMeaning2 = MeaningInput(description: "해내다")
//fileprivate let makeMeaning3 = MeaningInput(description: "벌다")
//fileprivate let make = WordInput(spelling: "make", meanings: [makeMeaning1, makeMeaning2, makeMeaning3])
//
//fileprivate let complicatedMeaning = MeaningInput(description: "복잡한")
//fileprivate let complicated = WordInput(spelling: "complicated", meanings: [complicatedMeaning])
//
//fileprivate let luckyMeaning = MeaningInput(description: "운이 좋은")
//fileprivate let lucky = WordInput(spelling: "lucky", meanings: [luckyMeaning])
//
//fileprivate let today = CalendarService.shared.today
//fileprivate let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
//fileprivate let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)!
//
//fileprivate let dayPlusWeek = Calendar.current.date(byAdding: .day, value: -7, to: today)!
//fileprivate let dayPlusTwoWeeks = Calendar.current.date(byAdding: .day, value: -14, to: today)!
//fileprivate let dayPlusMonth = Calendar.current.date(byAdding: .day, value: -28, to: today)!
//
//fileprivate let dummyTodayWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: today)
//fileprivate let dummyYesterdayWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: yesterday)
//fileprivate let dummyDayBeforeYesterdayWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayBeforeYesterday)
//
//fileprivate let dummyWeekWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayPlusWeek)
//fileprivate let dummyTwoWeekWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayPlusTwoWeeks)
//fileprivate let dummyMonthWordBook = WordBookInput(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayPlusMonth)
//
//fileprivate let studyDummyBooks = [dummyTodayWordBook, dummyYesterdayWordBook, dummyDayBeforeYesterdayWordBook]
//fileprivate let reviewDummyBooks = [dummyWeekWordBook, dummyTwoWeekWordBook, dummyMonthWordBook]

//class DummyDataWriter {
//
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    private let dao = WordDAO.shared
//
//    func writeDummyData() {
//        resetWordBook()
//        studyDummyBooks.forEach { wordBookInput in
//            _ = dao.insertWordBook(wordBook: wordBookInput, status: .study)
//        }
//        reviewDummyBooks.forEach { wordBookInput in
//            _ = dao.insertWordBook(wordBook: wordBookInput, status: .review)
//        }
//    }
//
//    // wordBook 전부 삭제 메소드
//    func resetWordBook() {
//
//        let fetchRequest: NSFetchRequest<WordBookMO> = WordBookMO.fetchRequest()
//
//        fetchRequest.includesPropertyValues = false
//        // id만 가져오는 방법
//
//        let wordBookMOs = try! context.fetch(fetchRequest)
//
//        for wordBookMO in wordBookMOs {
//            context.delete(wordBookMO)
//        }
//
//        try! context.save()
//    }
//
//    func resetUserDefault() {
//        UserDefaults.standard.removeObject(forKey: "today")
//        UserDefaults.standard.removeObject(forKey: "setting")
//    }
//
//    func insertTodayDummyWord() {
//        let dao = WordDAO.shared
//        let todayID = dao.findWordBookID(createdAt: CalendarService.shared.today)
//        guard let todayWordBookMO = dao.fetchWordBookMOByID(id: todayID!) else { return }
//
//        let wordObject1 = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
//
//        wordObject1.spelling = "Left"
//        wordObject1.createdAt = today
//        wordObject1.updatedAt = today
//        wordObject1.testResult = WordTestResult.success.rawValue
//
//        let meaningObject1 = NSEntityDescription.insertNewObject(forEntityName: "Meaning", into: context) as! MeaningMO
//        meaningObject1.content = "왼쪽"
//        meaningObject1.createdAt = today
//        meaningObject1.updatedAt = today
//
//        wordObject1.addToMeanings(meaningObject1)
//        wordObject1.wordBook = todayWordBookMO
//
//        let wordObject2 = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
//
//        wordObject2.spelling = "Right"
//        wordObject2.createdAt = today
//        wordObject2.updatedAt = today
//        wordObject2.testResult = WordTestResult.fail.rawValue
//
//        let meaningObject2 = NSEntityDescription.insertNewObject(forEntityName: "Meaning", into: context) as! MeaningMO
//        meaningObject2.content = "오른쪽"
//        meaningObject2.createdAt = today
//        meaningObject2.updatedAt = today
//
//        wordObject2.addToMeanings(meaningObject2)
//        wordObject2.wordBook = todayWordBookMO
//
//    }
//}
