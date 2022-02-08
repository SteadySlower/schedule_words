//
//  Errors.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/02.
//

import Foundation

enum WordInputError {
    case tooManyMeanings
    case noWord
    case noMeaning
    case meaningValidationFailure
    
    var message: String {
        switch self {
        case .tooManyMeanings:
            return "뜻은 3개까지만 저장할 수 있습니다."
        case .noWord:
            return "단어를 입력해주세요."
        case .noMeaning:
            return "뜻을 하나 이상 입력해주세요."
        case .meaningValidationFailure:
            return "뜻은 한글로 입력해주세요."
        }
    }
}
