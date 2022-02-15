//
//  WordDAO.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/14.
//

import Foundation
import CoreData
import UIKit

fileprivate enum WordBookStatus: Int16 {
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
        
        
        
    }
    
    // MARK: Helpers
    
    private func fetchWordBooks(status: WordBookStatus) -> [WordBook] {
        
        var wordBooks = [WordBook]()
        
        let fetchRequest: NSFetchRequest<WordBookMO> = WordBookMO.fetchRequest()
        
        let createdAtDesc = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [createdAtDesc]
        
        fetchRequest.predicate = getWordBookPredicate(status: status)
        
        do {
            let rawData = try self.context.fetch(fetchRequest)
            
            let parser = MOParser()
            
            for wordBookMO in rawData {
                let wordBook = parser.parseWordBook(rawData: wordBookMO)
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
}
