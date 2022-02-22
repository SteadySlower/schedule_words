//
//  MOParser.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/14.
//

//import Foundation
//
//
//
//// TODO: parser 없애고 다 initiater로 수정
//class MOParser {
//    func parseWordBook(rawData: WordBookMO) -> WordBook {
//        let id = rawData.objectID
//        let createdAt = rawData.createdAt!
//        let wordMOs = rawData.words!.array as! [WordMO]
//        let words = wordMOs.map { wordMO in
//            self.parseWord(rawData: wordMO)
//        }
//        return WordBook(id: id, words: words, createdAt: createdAt)
//    }
//
//    private func parseWord(rawData: WordMO) -> Word {
//        let id = rawData.objectID
//        let spelling = rawData.spelling ?? ""
//        let meanings = (rawData.meanings?.array.map({ meaningMO in
//            self.parseMeaning(rawData: meaningMO as! MeaningMO)
//        })) ?? [Meaning]()
//        let didChecked = rawData.didChecked
//        let testResult = WordTestResult(rawValue: rawData.testResult) ?? .undefined
//
//        return Word(id: id, spelling: spelling, meanings: meanings, didChecked: didChecked, testResult: testResult)
//    }
//
//    private func parseMeaning(rawData: MeaningMO) -> Meaning {
//        let id = rawData.objectID
//        let description = rawData.content ?? ""
//        return Meaning(id: id, description: description)
//    }
//}
 
