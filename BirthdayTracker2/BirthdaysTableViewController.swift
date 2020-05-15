//
//  BirthdaysTableViewController.swift
//  BirthdayTracker2
//
//  Created by Андрей Сигида on 02/03/2020.
//  Copyright © 2020 Андрей Сигида. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class BirthdaysTableViewController: UITableViewController {
    var birthdays = [Birthday]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        let sortDescriptor1 = NSSortDescriptor(key:"lastName",ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key:"firstName",ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1,sortDescriptor2]
        
        do{
            birthdays = try context.fetch(fetchRequest)
        }catch let error {
            print("Не удалось загрузить данные из-за ошибки \(error).")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return birthdays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
        let birthday = birthdays[indexPath.row]
        //удаление уведомления
        if let identifier = birthday.birthdayId {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
        let firstName = birthday.firstName ?? ""
        let lasttName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lasttName
        
        if let date = birthday.birthdate as Date?{
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }else{
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    

    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count>indexPath.row{
            let birthday = birthdays[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birthday)
            birthdays.remove(at:indexPath.row)
            
            do{
                     try context.save()
                 }catch let error{
                     print("Не удалось сохранить из-за ошибки \(error).")
                 }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }

}
