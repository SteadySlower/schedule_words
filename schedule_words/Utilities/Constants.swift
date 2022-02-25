//
//  Constants.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation
import UIKit


// undo 버튼 Config
let FLOATING_UNDO_BUTTON_CONFIGURATION: UIButton.Configuration = {
    var config = UIButton.Configuration.filled()
    config.baseBackgroundColor = UIColor.init(red: 80/256, green: 188/256, blue: 223/256, alpha: 0.8)
    config.contentInsets = NSDirectionalEdgeInsets(top: -5, leading: 0, bottom: 0, trailing: 0)
    config.image = UIImage(systemName: "arrow.uturn.backward")
    config.imageColorTransformer = UIConfigurationColorTransformer({ _ in
        return .white
    })
    config.cornerStyle = .capsule
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
    return config
}()
