//
//  LocalEventStorage.swift
//  Days
//
//  Created by 전윤현 on 2022/02/09.
//

import Foundation

extension Event {
    init(with info: [String: Any]) {
        self.id = info["id"] as! Double
        self.title = info["title"] as! String
        self.icon = info["icon"] as! Int
        self.date = info["date"] as! Date
    }
    
    func asDictionary() -> [String: Any] {
        ["id" : id, "title": title, "icon": icon, "date" : date]
    }
}

final class LocalEventStorage: EventStorage {
    private let defaults: UserDefaults
    private let key =  "list"
    
    init(with defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func add(_ event: Event) {
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        list.append(event.asDictionary())
        defaults.setValue(list, forKey: key)
    }
    
    func update(_ event: Event) {
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        
        if let index = list.firstIndex(where: {Event(with: $0) == event}) {
            list[index] = event.asDictionary()
        }
        defaults.setValue(list, forKey: key)
    }
    
    func delete(_ event: Event) {
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        
        if let index = list.firstIndex(where: {Event(with: $0) == event}) {
            list.remove(at: index)
        }
        defaults.setValue(list, forKey: key)
    }
    
    func list() -> [Event] {
        let list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        return list.map{Event(with: $0)}
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
    
    func find(by id: Identifier) -> Event? {
        self.list().first(where: {$0.id == id})
    }
}
