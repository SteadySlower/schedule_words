//
//  SettingViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/25.
//

import Foundation

class SettingViewModel {
    
    private var setting = UserSetting.shared.setting
    
    let numOfSections = 2
    
    func titleForSection(of section: Int) -> String {
        switch section {
        case 0: return "테스트 설정"
        case 1: return "공부 설정"
        default: return ""
        }
    }
    
    func numOfRows(of section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        default: return 0
        }
    }
    
    func typeForTestCell(of indexPath: IndexPath) -> SettingType {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            return row == 0 ? .testMode : .testWordsOrder
        } else {
            return row == 0 ? .studyMode : .studyWordsOrder
        }
    }

    
    func settingToggled(type: SettingType) {
        switch type {
        case .testMode:
            setting.testMode.toggle()
        case .testWordsOrder:
            setting.testWordsOrder.toggle()
        case .studyMode:
            setting.studyMode.toggle()
        case .studyWordsOrder:
            setting.studyWordsOrder.toggle()
        }
    }
    
    func saveSetting() {
        UserSetting.shared.saveSetting(setting: setting)
    }
}
