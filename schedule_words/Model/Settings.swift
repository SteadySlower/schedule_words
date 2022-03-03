//
//  Setting.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/25.
//

import Foundation

enum SettingType {
    case testMode
    case testWordsOrder
    case studyMode
    case studyWordsOrder
    
    var description: String {
        switch self {
        case .testMode: return "단어 보기"
        case .testWordsOrder: return "단어 순서"
        case .studyMode: return  "단어 보기"
        case .studyWordsOrder: return "단어 순서"
        }
    }
    
    var segmentItems: [String] {
        [self.firstSegmentText, self.secondSegmentText]
    }
    
    private var firstSegmentText: String {
        switch self {
        case .testMode: return "통과 제외"
        case .testWordsOrder: return "랜덤"
        case .studyMode: return  "통과 제외"
        case .studyWordsOrder: return "랜덤"
        }
    }
    
    private var secondSegmentText: String {
        switch self {
        case .testMode: return "전체"
        case .testWordsOrder: return "원래대로"
        case .studyMode: return  "전체"
        case .studyWordsOrder: return "원래대로"
        }
    }
    
    var selectedSegmentIndex: Int {
        let setting = UserSetting.shared.setting
        switch self {
        case .testMode: return setting.testMode.rawValue
        case .testWordsOrder: return setting.testWordsOrder.rawValue
        case .studyMode: return  setting.studyMode.rawValue
        case .studyWordsOrder: return setting.studyWordsOrder.rawValue
        }
    }
}

struct Setting {
    var testMode: ListingMode
    var testWordsOrder: WordsOrder
    var studyMode: ListingMode
    var studyWordsOrder: WordsOrder
    
    static let defaultSetting = Setting()
    
    private init() {
        self.testMode = .onlyFail
        self.testWordsOrder = .random
        self.studyMode = .onlyFail
        self.studyWordsOrder = .random
    }
    
    init(rawData: [String: Int]) {
        self.testMode = ListingMode(rawValue: rawData["testMode"]!)!
        self.testWordsOrder = WordsOrder(rawValue: rawData["testWordsOrder"]!)!
        self.studyMode = ListingMode(rawValue: rawData["studyMode"]!)!
        self.studyWordsOrder = WordsOrder(rawValue: rawData["studyWordsOrder"]!)!
    }
    
    var rawData: [String: Int] {
        return [
            "testMode": testMode.rawValue,
            "testWordsOrder": testWordsOrder.rawValue,
            "studyMode": studyMode.rawValue,
            "studyWordsOrder": studyWordsOrder.rawValue,
        ]
    }
}

enum ListingMode: Int {
    case onlyFail = 0
    case all
    
    mutating func toggle() {
        switch self {
        case .onlyFail:
            self = .all
        case .all:
            self = .onlyFail
        }
    }
}

enum WordsOrder: Int {
    case random = 0
    case original
    
    mutating func toggle() {
        switch self {
        case .random:
            self = .original
        case .original:
            self = .random
        }
    }
}
