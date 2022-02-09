//
//  EventListViewController.swift
//  Days
//
//  Created by 전윤현 on 2022/02/09.
//

import Foundation
import UIKit

class EventListCell: UITableViewCell {
    var event: Event! {
        didSet {
            
        }
    }
    
    @IBOutlet weak private var iconView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var dayCountLabel: UILabel!
}

class EventListViewController: UIViewController {
    let storage: EventStorage = LocalEventStorage()

    @IBOutlet weak private var tableView: UITableView!
    
    @IBAction func add() {
        let event = Event(title: "추가", icon: 1, date: Date())
        let row = storage.list().count
        let indexPath = IndexPath(row: row, section: 0)

        storage.add(event)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storage.list().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = storage.list()[indexPath.row]
            storage.delete(event)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
