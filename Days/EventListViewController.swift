//
//  EventListViewController.swift
//  Days
//
//  Created by 전윤현 on 2022/02/09.
//

import Foundation
import UIKit

struct EventAction {
    var event: Event
    var mode: EventEditorMode
}

class EventListCell: UITableViewCell {
    var event: Event! {
        didSet {
            let format = DateFormatter.dateFormat(fromTemplate: "dMMMMyyyy", options: 0, locale: Locale.current)
            let formatter = DateFormatter()
            let dayCount = event.dayCount()
            
            formatter.dateFormat = format
            
            titleLabel.text = event.title
            dateLabel.text = formatter.string(from: event.date)
            iconView.image = UIImage(named: "icon_\(event.icon)")
            
            if dayCount == 0 {
                dayCountLabel.text = "Today"
            } else if dayCount < 0 {
                dayCountLabel.text = "D-\(abs(dayCount))"
            } else {
                dayCountLabel.text = "D+\(dayCount)"
            }
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
        let event = Event(title: "", icon: 1, date: Date())
        performSegue(withIdentifier: "EventEditor", sender: EventAction(event: event, mode: .add))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventEditor" {
            let navigationViewController = segue.destination as? UINavigationController
            let eventEditorViewController = navigationViewController?.topViewController as? EventEditorViewController
            let action = sender as? EventAction
            
            if let action = action, let controller = eventEditorViewController {
                controller.event = action.event
                controller.mode = action.mode
                controller.delegate = self
            }
        }
    }
}

extension EventListViewController: EventEditorViewControllerDelegate {
    func eventEditorViewController(_ controller: EventEditorViewController, finishEditing event: Event, mode: EventEditorMode, widget: Bool) {
        if mode == .add {
            let indexPath = IndexPath(row: storage.list().count, section: 0)
            storage.add(event)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            })
            
        } else if mode == .edit {
            storage.update(event)
            tableView.reloadData()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        let event = storage.list()[indexPath.row]
        
        cell.event = event
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = storage.list()[indexPath.row]
        let action = EventAction(event: event, mode: .edit)
        performSegue(withIdentifier: "EventEditor", sender: action)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
