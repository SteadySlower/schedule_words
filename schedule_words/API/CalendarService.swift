//
//  CalendarService.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/02.
//

import Foundation

class CalendarService {
    
    static let shared = CalendarService()
    
    private let plist = UserDefaults.standard
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
    }()
    
    let today: Date
    
    init() {
        // 저장된 today가 없을 때
        guard let recorededToday = plist.object(forKey: "today") as? Date else {
            let today = Date()
            plist.set(Date() as NSDate, forKey: "today")
            self.today = today
        }
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let isTodayValid = calendar.isDateInToday(recorededToday)
        
        if isTodayValid {
            self.today = recorededToday
        } else {
            let today = Date()
            plist.set(Date() as NSDate, forKey: "today")
            self.today = today
        }
    }
}
