//
//  DummyWords.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

private let cakeMeaning = Meaning(description: "케이크")
private let cake = Word(spelling: "cake", meanings: [cakeMeaning])

private let runMeaning1 = Meaning(description: "달리다")
private let runMeaning2 = Meaning(description: "운영하다")
private let run = Word(spelling: "run", meanings: [runMeaning1, runMeaning2])

private let goMeaning = Meaning(description: "가다")
private let go = Word(spelling: "go", meanings: [goMeaning])

private let loveMeaning = Meaning(description: "사랑")
private let love = Word(spelling: "love", meanings: [loveMeaning])

private let makeMeaning1 = Meaning(description: "만들다")
private let makeMeaning2 = Meaning(description: "해내다")
private let makeMeaning3 = Meaning(description: "벌다")
private let make = Word(spelling: "make", meanings: [makeMeaning1, makeMeaning2, makeMeaning3])

private let complicatedMeaning = Meaning(description: "복잡한")
private let complicated = Word(spelling: "complicated", meanings: [complicatedMeaning])

private let luckyMeaning = Meaning(description: "운이 좋은")
private let lucky = Word(spelling: "lucky", meanings: [luckyMeaning])

let today = Date()
let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)!

let dummyWordBook = WordBook(words: [cake, run, go, love, make, complicated, lucky], createdAt: Date())

let dummyTodayWordBook = WordBook(words: [cake, run, go, love, make, complicated, lucky], createdAt: today)
let dummyYesterdayWordBook = WordBook(words: [cake, run, go, love, make, complicated, lucky], createdAt: yesterday)
let dummyDayBeforeYesterdayWordBook = WordBook(words: [cake, run, go, love, make, complicated, lucky], createdAt: dayBeforeYesterday)


let dummyHomeStatus = HomeStatus(numOfStudyBooks: 3,
                                 numOfStudyWords: 100,
                                 secondsOfStudyTime: TimeInterval(198),
                                 numOfReviewBooks: 10,
                                 numOfReviewWords: 200,
                                 secondsOfReviewTime: TimeInterval(363),
                                 studyWordBooks: [dummyTodayWordBook, dummyYesterdayWordBook, dummyDayBeforeYesterdayWordBook],
                                 reviewWordBooks: [dummyWordBook, dummyWordBook, dummyWordBook])
