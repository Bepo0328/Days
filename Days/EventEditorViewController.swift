//
//  EventEditorViewController.swift
//  Days
//
//  Created by 전윤현 on 2022/02/10.
//

import Foundation
import UIKit

enum EventEditorMode {
    case add
    case edit
}

protocol EventEditorViewControllerDelegate: AnyObject {
    func eventEditorViewController(_ controller: EventEditorViewController, finishEditing event: Event, mode: EventEditorMode, widget: Bool)
}

class EventEditorViewController: UITableViewController {
    @IBOutlet weak private var iconButton: UIButton!
    @IBOutlet weak private var titleField: UITextField!
    @IBOutlet weak private var datePicker: UIDatePicker!
    @IBOutlet weak private var widgetSwitch: UISwitch!
    
    var mode: EventEditorMode!
    var event: Event!
    weak var delegate: EventEditorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconButton.setImage(UIImage(named: "icon_\(event.icon)"), for: .normal)
        self.titleField.text = event.title
        self.datePicker.date = event.date
        self.widgetSwitch.isOn = UserDefaults.standard.double(forKey: "widget") == event.id
    }
    
    @IBAction func dateChanged() {
        self.event.date = datePicker.date
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save() {
        if let delegate = delegate, let title = titleField.text {
            event.title = title
            delegate.eventEditorViewController(self, finishEditing: event, mode: mode, widget: widgetSwitch.isOn)
        }
    }
}
