//
//  HomeViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/21.
//

import Foundation

struct HomeViewModel {
    
    // MARK: main data
    var studyWordBooks: [WordBook]
    var reviewWordBooks: [WordBook]
    
    // MARK: LifeCycle
    init() {
        // FIXME: 더미데이터 write
        let dummyDataWriter = DummyDataWriter()
        dummyDataWriter.writeDummyData()
        
        let todayWordBookTuple = WordService.shared.fetchTodayWordBookTuple()
        self.studyWordBooks = todayWordBookTuple.studyWordBooks
        self.reviewWordBooks = todayWordBookTuple.reviewWordBooks
    }
    
    // MARK: data used in view
    
    var homeStatus: HomeStatus {
        return HomeStatus(studyWordBooks: studyWordBooks, reviewWordBooks: reviewWordBooks)
    }
    
    let numOfSections = 2
    
    func titleForSection(of section: Int) -> String {
            switch section {
            case 0: return "오늘 공부할 단어장"
            case 1: return "오늘 복습할 단어장"
            default: return ""
            }
    }
    
    func numOfRows(of section: Int) -> Int {
        switch section {
        case 0: return homeStatus.numOfStudyBooks
        case 1: return homeStatus.numOfReviewBooks
        default: return 0
        }
    }
    
    func wordBookForHomeCell(of indexPath: IndexPath) -> WordBook? {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            return studyWordBooks[row]
        } else if section == 1 {
            return reviewWordBooks[row]
        }
        
        return nil
    }
    
    func actionSheetTitle(of wordBook: WordBook) -> String {
        let dateGap = Utilities().getDaysFromToday(date: wordBook.createdAt)
        
        switch dateGap {
        case 0:
            return "오늘 단어장"
        case 1:
            return "어제 단어장"
        case 2:
            return "그제 단어장"
        default:
            return "+\(dateGap)일 단어장"
        }
        
    }
    
    // MARK: Helpers
    
    mutating func updateViewModel() {
        let todayWordBookTuple = WordService.shared.fetchTodayWordBookTuple()
        self.studyWordBooks = todayWordBookTuple.studyWordBooks
        self.reviewWordBooks = todayWordBookTuple.reviewWordBooks
    }
}
