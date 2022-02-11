//
//  WidgetDefaults.swift
//  Days
//
//  Created by 전윤현 on 2022/02/11.
//

import Foundation

final class WidgetDefaults {
    static let shared = WidgetDefaults()
    
    private let defaults = UserDefaults(suiteName: "group.kr.co.bepo.days")!
    private let key = "widget_id"
    
    var id: Double? {
        get {
            return defaults.double(forKey: key)
        }
        
        set {
            defaults.setValue(newValue, forKey: key)
        }
    }
}
