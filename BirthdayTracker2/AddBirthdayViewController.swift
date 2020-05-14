//
//  ViewController.swift
//  BirthdayTracker2
//
//  Created by Андрей Сигида on 02/03/2020.
//  Copyright © 2020 Андрей Сигида. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class AddBirthdayViewController: UIViewController {
    @IBOutlet var fistNameTextField: UITextField!
     @IBOutlet var lasttNameTextField: UITextField!
     @IBOutlet var birthdatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        birthdatePicker.maximumDate = Date()

    }
    @IBAction func saveTapped (_sender:UIBarButtonItem){
        let firstName = fistNameTextField.text ?? ""
        let lasttName = lasttNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBirthday = Birthday(context:context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lasttName
        newBirthday.birthdate = birthdate
        newBirthday.birthdayId = UUID().uuidString
        if let uniqueId = newBirthday.birthdayId{
            print("birthdayId:\(uniqueId)")}
        do{
            try context.save()
            let message = "Сегодня \(firstName) \(lasttName) празднует день рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month,.day], from: birthdate)
            dateComponents.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayId {
                let reqest = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(reqest, withCompletionHandler: nil)
            }
        } catch let error {
            print("Не удалось сохранить из-за ошибки \(error).")
        }


        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelTapped(_sender:UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

