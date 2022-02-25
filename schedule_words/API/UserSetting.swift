//
//  SettingService.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/25.
//

import Foundation

class UserSetting {
    
    static let shared = UserSetting()
    
    private let plist = UserDefaults.standard
    
    var setting: Setting {
        didSet {
            plist.set(setting.rawData, forKey: "setting")
        }
    }
    
    init() {
        let rawData = plist.object(forKey: "setting") as? [String: Int]
        if let rawData = rawData {
            self.setting = Setting(rawData: rawData)
        } else {
            let defaultSetting = Setting.defaultSetting
            plist.set(defaultSetting.rawData, forKey: "setting")
            self.setting = Setting.defaultSetting
        }
    }
    
    func saveSetting(setting: Setting) {
        self.setting = setting
    }
}
