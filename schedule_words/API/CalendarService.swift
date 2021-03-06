//
//  CalendarService.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/02.
//

import Foundation

class CalendarService {
    
    // MARK: Stored Properties
    
    static let shared = CalendarService()
    
    private let plist = UserDefaults.standard
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()
    
    let today: Date
    
    var isDayChanged: Bool
    
    // MARK: Initializer
    
    init() {
        guard let recorededToday = plist.object(forKey: "today") as? Date else {
            // 저장된 today가 없을 때
            let today = Date()
            plist.set(today as NSDate, forKey: "today")
            self.today = today
            self.isDayChanged = true
            return
        }
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let isTodayValid = calendar.isDateInToday(recorededToday)
        
        if isTodayValid {
            self.today = recorededToday
            self.isDayChanged = false
        } else {
            let today = Date()
            plist.set(today as NSDate, forKey: "today")
            self.today = today
            self.isDayChanged = true
        }
    }
    
    // MARK: Methods
    
    // 날짜 비교
        // TODO: 홈화면에서 어제 단어장이 날짜에 따라서 오늘 단어장으로 보이는 일이 생겨서 일단 임시 방편으로 -1리턴할 때만 오늘.
    func getDaysFromToday(date: Date) -> Int {
        if calendar.isDateInToday(date) {
            return -1
        } else {
            return calendar.dateComponents([.day], from: date, to: today).day!
        }
    }
    
    // 오늘 날짜 범위 리턴
    func getTodayRange() -> (dateFrom: Date, dateTo: Date) {
        let dateFrom = calendar.startOfDay(for: today)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        return (dateFrom: dateFrom, dateTo: dateTo)
    }
    
    // 복습 날짜 리턴
    func getNextReviewDate(numOfReviews: Int) -> Date? {
        switch numOfReviews {
        case 0: return calendar.date(byAdding: .day, value: 3, to: today)
        case 1: return calendar.date(byAdding: .day, value: 4, to: today)
        case 2: return calendar.date(byAdding: .day, value: 7, to: today)
        case 3: return calendar.date(byAdding: .day, value: 14, to: today)
        default: return nil
        }
    }
    
    // 오늘과 날짜 차이 반환
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = calendar.startOfDay(for: from)
        let toDate = calendar.startOfDay(for: to)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day!
    }
    
    // 오늘 날짜와 동일한지 반환
    
    func isDateInToday(date: Date) -> Bool {
        return calendar.isDate(date, inSameDayAs: today)
    }
    
    // MARK: Dev
    
    // 오늘 날짜 변경하기
//    func chanageToday(date: Date) {
//        self.today = date
//        self.isDayChanged = true
//        _ = WordService.shared.setForNewDay()
//       DummyDataWriter().insertTodayDummyWord()
//    }
}
