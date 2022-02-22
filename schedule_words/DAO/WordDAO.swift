//
//  WordDAO.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/14.
//

import Foundation
import CoreData
import UIKit

enum WordBookStatus: Int16 {
    case study = 0, review, invalid
}

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
        wordBookObject.nextReviewDate = Date()
        wordBookObject.didFinish = wordBook.didFinish
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
    
    // 단어를 단어장에 넣기
    func insertWord(word: WordInput, WordBookID id: String) -> Bool {
        guard let wordBookObject = fetchWordBookMOByID(id: id) else {
            return false
        }
        
        let today = Date()
        let wordObject = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context) as! WordMO
        
        wordObject.spelling = word.spelling
        wordObject.createdAt = today
        wordObject.updatedAt = today
        wordObject.didChecked = false
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
        
        let todayDateRange = Utilities().getTodayRange()
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
    
    // TODO: didFinish된 단어장들 nextReviewDate 갱신하기
    
    // MARK: Helpers
    
    // HomeStatus를 불러올 때 사용
    private func getWordBookPredicate(status: WordBookStatus) -> NSPredicate {
        
        var predicate = NSPredicate()
        
        if status == .study {
            predicate = NSPredicate(format: "%K == %d", #keyPath(WordBookMO.status), status.rawValue)
        } else if status == .review {
            let statusPredicate = NSPredicate(format: "%K == %d", #keyPath(WordBookMO.status), status.rawValue)
            let todayDateRange = Utilities().getTodayRange()
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(WordBookMO.nextReviewDate), todayDateRange.dateTo as NSDate)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, toPredicate])
        }
        
        return predicate
    }
    
    // 오늘의 단어장에 단어 넣을 때 사용
    private func fetchWordBookMOByID(id: String) -> WordBookMO? {
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string: id)!) else { return nil }
        
        do {
            return try context.existingObject(with: objectID) as? WordBookMO
        } catch let error as NSError {
            NSLog("CoreData Error: %s", error.localizedDescription)
            return nil
        }
    }
    
    // 단어장에 단어 넣을 때 사용
    private func createMeaningMOs(meanings: [MeaningInput]) -> NSOrderedSet {
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
    
    // 단어장에 단어 넣을 때 사용
    private func createWordMOs(words: [WordInput], createdAt: Date) -> NSOrderedSet {
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
