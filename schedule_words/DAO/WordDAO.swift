//
//  WordDAO.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/14.
//

import Foundation
import CoreData
import UIKit

// TODO: 더미데이터 끝나면 file private으로 바꾸기
enum WordBookStatus: Int16 {
    case study = 0, review, invalid
}

class WordDAO {
    
    static let shared = WordDAO()
    
    // 컨텍스트 appDelegate에서 가져오기
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    // 홈 화면에 표시될 단어장들을 표시하기
    func fetchHomeStatus() -> HomeStatus {
        let studyWordBooks = fetchWordBooks(status: .study)
        let reviewWordBooks = fetchWordBooks(status: .review)
        return HomeStatus(studyWordBooks: studyWordBooks, reviewWordBooks: reviewWordBooks)
    }
    
    // 오늘 단어장 만들기 -> 앱 실행시 User Default에 저장된 오늘 날짜 확인해보고 다르면 새로운 단어장 만들때 사용
    func insertTodayWordBook() -> Bool {
        let today = Date()
        let object = NSEntityDescription.insertNewObject(forEntityName: "WordBook", into: context) as! WordBookMO
        object.createdAt = today
        object.updatedAt = today
        object.status = 0
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // 임의의 날짜에 임의의 단어장 만들기 (for dev)
        // TODO: 더미데이터 만들기용 -> 삭제
    func insertWordBook(wordBook: WordBook, status: WordBookStatus) -> Bool {
        let wordBookObject = NSEntityDescription.insertNewObject(forEntityName: "WordBook", into: context) as! WordBookMO
        wordBookObject.createdAt = wordBook.createdAt
        wordBookObject.updatedAt = wordBook.createdAt
        wordBookObject.nextReviewDate = Date()
        wordBookObject.status = status.rawValue
        
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
    
    // 단어 오늘 단어장에 넣기
    func insertTodayWord(word: Word, todayWordBookID id: NSManagedObjectID) -> Bool {
        guard let wordBookObject = fetchWordBookMOByID(objectID: id) else {
            return false
        }
        
        let today = Date()
        let wordObject = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
        
        wordObject.spelling = word.spelling
        wordObject.createdAt = today
        wordObject.updatedAt = today
        wordObject.didChecked = false
        wordObject.testResult = WordTestResult.fail.rawValue
        
        wordBookObject.addToWords(wordObject)
        wordBookObject.updatedAt = today
        
        let meaningMOs = createMeaningMOs(meanings: word.meanings)
        wordObject.addToMeanings(meaningMOs)
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            context.rollback()
            NSLog("CoreData Error: %s", error.localizedDescription)
            return false
        }
    }
    
    // MARK: Helpers
    
    private func fetchWordBooks(status: WordBookStatus) -> [WordBook] {
        
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
    
    private func getWordBookPredicate(status: WordBookStatus) -> NSPredicate {
        
        var predicate = NSPredicate()
        
        if status == .study {
            predicate = NSPredicate(format: "%K == %d", #keyPath(WordBookMO.status), status.rawValue)
        } else if status == .review {
            let statusPredicate = NSPredicate(format: "%K == %d", #keyPath(WordBookMO.status), status.rawValue)
            let todayDateRange = Utilities().getTodayRange()
            let fromPredicate = NSPredicate(format: "%@ >= %K", todayDateRange.dateFrom as NSDate, #keyPath(WordBookMO.nextReviewDate))
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(WordBookMO.nextReviewDate), todayDateRange.dateTo as NSDate)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, fromPredicate, toPredicate])
        }
        
        return predicate
    }
    
    private func fetchWordBookMOByID(objectID: NSManagedObjectID) -> WordBookMO? {
        let fetchRequest: NSFetchRequest<WordBookMO> = WordBookMO.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(WordBookMO.objectID), objectID)
        fetchRequest.predicate = predicate
        
        do {
            let rawData = try self.context.fetch(fetchRequest)
            return rawData.first
        } catch let error as NSError {
            NSLog("CoreData Error: %s", error.localizedDescription)
            return nil
        }
    }
    
    private func createMeaningMOs(meanings: [Meaning]) -> NSOrderedSet {
        let today = Date()
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
    
    // TODO: 더미데이터용
    private func createWordMOs(words: [Word], createdAt: Date) -> NSOrderedSet {
        var wordMOs = [WordMO]()
        
        for word in words {
            let wordObject = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
            wordObject.createdAt = createdAt
            wordObject.updatedAt = createdAt
            wordObject.spelling = word.spelling
            wordObject.didChecked = false
            wordObject.testResult = WordTestResult.undefined.rawValue
            
            let meaningMOs = createMeaningMOs(meanings: word.meanings)
            wordObject.addToMeanings(meaningMOs)
            
            wordMOs.append(wordObject)
        }
        
        return NSOrderedSet(array: wordMOs)
    }
}
