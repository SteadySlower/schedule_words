//
//  WordDAO.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/14.
//

import Foundation
import CoreData
import UIKit

// DAO는 만들때 좀 더 범용적인 메소드들을 만들고 구체적인 비지니스 로직은 Service에 가도록 수정

class WordDAO {
    
    // MARK: Properties
    
    static let shared = WordDAO()
    
    // 컨텍스트 appDelegate에서 가져오기
        // 외부에서 주입?
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: Methods
    
    // 단어장 상태에 맞추어 단어장 가져오기
    func fetchWordBooks(status: WordBookStatus) -> [WordBook] {
        
        var wordBooks = [WordBook]()
        
        let fetchRequest: NSFetchRequest<WordBookMO> = WordBookMO.fetchRequest()
        
        let createdAtDesc = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [createdAtDesc]
        
        fetchRequest.predicate = getWordBookPredicate(status: status)
        
        do {
            let wordBookMOs = try self.context.fetch(fetchRequest)
            
            for wordBookMO in wordBookMOs {
                let wordBook = WordBook(MO: wordBookMO)
                wordBooks.append(wordBook)
            }
            
        } catch let error as NSError {
            NSLog("CoreData Error: %s", error.localizedDescription)
        }
        
        return wordBooks
    }
    
    // 임의의 날짜에 임의의 단어장 만들기
    func insertWordBook(wordBook: WordBookInput, status: WordBookStatus) -> Bool {
        let wordBookObject = NSEntityDescription.insertNewObject(forEntityName: "WordBook", into: context) as! WordBookMO
        wordBookObject.createdAt = wordBook.createdAt
        wordBookObject.updatedAt = wordBook.createdAt
        wordBookObject.nextReviewDate = CalendarService.shared.today
        wordBookObject.status = status.rawValue
        wordBookObject.numOfReviews = 0
        
        let wordMOs = createWordMOs(words: wordBook.words, createdAt: wordBook.createdAt)
        wordBookObject.addToWords(wordMOs)
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // 단어를 단어장에 넣기
    func insertWord(word: WordInput, WordBookID id: String) -> Bool {
        guard let wordBookObject = fetchWordBookMOByID(id: id) else {
            return false
        }
        
        let today = CalendarService.shared.today
        let wordObject = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
        
        wordObject.spelling = word.spelling
        wordObject.createdAt = today
        wordObject.updatedAt = today
        wordObject.testResult = WordTestResult.fail.rawValue
        
        let meaningMOs = createMeaningMOs(meanings: word.meanings)
        wordObject.addToMeanings(meaningMOs)
        
        wordBookObject.addToWords(wordObject)
        wordBookObject.updatedAt = today
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // 특정 날짜에 만들어진 단어장의 ID 반환
    func findWordBookID(createdAt: Date) -> String? {
        let fetchRequest: NSFetchRequest<WordBookMO> = WordBookMO.fetchRequest()
        
        var predicate = NSPredicate()
        
        let todayDateRange = CalendarService.shared.getTodayRange()
        let fromPredicate = NSPredicate(format: "%@ <= %K", todayDateRange.dateFrom as NSDate, #keyPath(WordBookMO.createdAt))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(WordBookMO.createdAt), todayDateRange.dateTo as NSDate)
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        fetchRequest.predicate = predicate
        
        do {
            let wordBookMOs = try self.context.fetch(fetchRequest)
            let todayWordBookMO = wordBookMOs[0]
            return todayWordBookMO.objectID.uriRepresentation().absoluteString
            
        } catch let error as NSError {
            NSLog("CoreData Error: %s", error.localizedDescription)
            return nil
        }
    }
    
    // testResult 업데이트 하기
    func updateTestResult(id: String, testResult: WordTestResult) -> Bool {
        guard let wordMO = fetchWordMOByID(id: id) else { return false }
        
        wordMO.testResult = testResult.rawValue
        wordMO.updatedAt = CalendarService.shared.today
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // 단어 오늘로 넘기기
    func moveWordToToday(word: Word) -> Bool {
        // 오늘 단어장 ID와 MO
            // TODO: 오늘 단어장 없으면 만들기
        guard let todayID = findWordBookID(createdAt: CalendarService.shared.today) else { return false }
        guard let todayWordBookMO = fetchWordBookMOByID(id: todayID) else { return false }
        
        // 현재 단어 MO 가져오기
        guard let wordMO = fetchWordMOByID(id: word.id) else { return false }
        
        // 현재 단어 testResult .undefined로 리셋하기
        wordMO.testResult = WordTestResult.undefined.rawValue
        
        // 새로운 단어장 연결하기
        wordMO.wordBook = todayWordBookMO
        
        // 커밋
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // 단어장 finish 하기
    func finishWordBook(wordBookID: String) -> Bool {
        guard let toFinishMO = fetchWordBookMOByID(id: wordBookID) else { return false }
        
        // status와 복습횟수에 맞추어서 nextReviewDate 설정하기
            // 공부 단어장의 경우 status 복습으로 바꾸기
        if toFinishMO.status == 0 {
            toFinishMO.status = WordBookStatus.review.rawValue
            toFinishMO.nextReviewDate = CalendarService.shared.getNextReviewDate(numOfReviews: 0)
            // 복습 단어장일 경우 복습횟수 추가하기
        } else if toFinishMO.status == 1 {
            let newNumOfReviews = toFinishMO.numOfReviews + 1
            // 복습 횟수 3회 초과하면 archive 하기
            if newNumOfReviews > 3 {
                toFinishMO.status = WordBookStatus.archived.rawValue
            } else {
                toFinishMO.numOfReviews = newNumOfReviews
                toFinishMO.nextReviewDate =  CalendarService.shared.getNextReviewDate(numOfReviews: Int(newNumOfReviews))
            }
        } else {
            return false
        }
        
        // 커밋
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // TODO: 날짜 넘어갈 때 status 업데이트 하기
        // 1. 오늘 단어장 만들기
        // 2. 3일차 단어 중에 success가 아닌 단어들은 첫날 단어장으로 옮기기
        // 3. 3일차 단어장 nextReviewDate 바꾸고 invalid 처리
        // 3. 복습단어장 중에 didFinish가 true인 단어장들은 완료 처리
    func updateStatus(id: String, status: WordBookStatus, nextReviewDate: Date) -> Bool {
        guard let wordBookMO = fetchWordBookMOByID(id: id) else { return false }
        
        wordBookMO.status = status.rawValue
        wordBookMO.nextReviewDate = nextReviewDate
        wordBookMO.updatedAt = CalendarService.shared.today
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // MARK: Helpers
    
    // HomeStatus를 불러올 때 사용
    private func getWordBookPredicate(status: WordBookStatus) -> NSPredicate {
        
        var predicate = NSPredicate()
        
        if status == .study {
            predicate = NSPredicate(format: "%K == %d", #keyPath(WordBookMO.status), status.rawValue)
        } else if status == .review {
            let statusPredicate = NSPredicate(format: "%K == %d", #keyPath(WordBookMO.status), status.rawValue)
            let todayDateRange = CalendarService.shared.getTodayRange()
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(WordBookMO.nextReviewDate), todayDateRange.dateTo as NSDate)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, toPredicate])
        }
        
        return predicate
    }
    
    private func fetchWordBookMOByID(id: String) -> WordBookMO? {
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string: id)!) else { return nil }
        
        do {
            return try context.existingObject(with: objectID) as? WordBookMO
        } catch let error as NSError {
            NSLog("CoreData Error: %s", error.localizedDescription)
            return nil
        }
    }
    
    // 단어 내용 업데이트할 때 사용
    private func fetchWordMOByID(id: String) -> WordMO? {
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string: id)!) else { return nil }
        
        do {
            return try context.existingObject(with: objectID) as? WordMO
        } catch let error as NSError {
            NSLog("CoreData Error: %s", error.localizedDescription)
            return nil
        }
    }
    
    // 단어장에 단어 넣을 때 사용
    private func createMeaningMOs(meanings: [MeaningInput]) -> NSOrderedSet {
        let today = CalendarService.shared.today
        var meaningMOs = [MeaningMO]()
        
        for meaning in meanings {
            let meaningObject = NSEntityDescription.insertNewObject(forEntityName: "Meaning", into: context) as! MeaningMO
            meaningObject.content = meaning.description
            meaningObject.createdAt = today
            meaningObject.updatedAt = today
            meaningMOs.append(meaningObject)
        }
        
        return NSOrderedSet(array: meaningMOs)
    }
    
    // 단어장에 단어 넣을 때 사용
    private func createWordMOs(words: [WordInput], createdAt: Date) -> NSOrderedSet {
        var wordMOs = [WordMO]()
        
        for word in words {
            let wordObject = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
            wordObject.createdAt = createdAt
            wordObject.updatedAt = createdAt
            wordObject.spelling = word.spelling
            wordObject.testResult = WordTestResult.undefined.rawValue
            
            let meaningMOs = createMeaningMOs(meanings: word.meanings)
            wordObject.addToMeanings(meaningMOs)
            
            wordMOs.append(wordObject)
        }
        
        return NSOrderedSet(array: wordMOs)
    }
}
