//
//  HomeViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/21.
//

import Foundation

struct HomeViewModel {
    let studyWordBooks: [WordBook]
    let reviewWordBook: [WordBook]
    
    var homeStatus: HomeStatus {
        return HomeStatus(studyWordBooks: studyWordBooks, reviewWordBooks: reviewWordBook)
    }
}
