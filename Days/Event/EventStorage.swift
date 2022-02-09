//
//  EventStorage.swift
//  Days
//
//  Created by 전윤현 on 2022/02/09.
//

import Foundation

protocol EventStorage {
    typealias Identifier = Double
    
    func add(_ event: Event)
    func update(_ event: Event)
    func delete(_ event: Event)
    func list() -> [Event]
    func clear()
    func find(by id: Identifier) -> Event?
}
