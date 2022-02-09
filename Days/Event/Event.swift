//
//  Event.swift
//  Days
//
//  Created by 전윤현 on 2022/02/09.
//

import Foundation

struct Event: Equatable {
    let id: Double
    var title: String
    var icon: Int
    var date: Date
    
    init(title: String, icon: Int, date: Date) {
        self.id = Date().timeIntervalSince1970
        self.title = title
        self.icon = icon
        self.date = date
    }
    
    // + 미래, - 과거
    func dayCount(from: Date = Date()) -> Int {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: from)
        let to = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: from, to: to)
        
        return components.day!
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}
