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
    
    func fetchStudyWordBooks() -> [WordBook] {
        
        var wordBooks = [WordBook]()
        
        let fetchRequest: NSFetchRequest<WordBookMO> = WordBookMO.fetchRequest()
        
        let createdAtDesc = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [createdAtDesc]
        
        let studyPredicate = NSPredicate(format: "status == %d", WordBookStatus.study.rawValue)
        fetchRequest.predicate = studyPredicate
        
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
    
    func fetchReviewWordBooks() -> [WordBook] {
        
    }
    
}
