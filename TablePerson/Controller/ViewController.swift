//
//  ViewController.swift
//  TablePerson
//
//  Created by Филипп on 10/19/19.
//  Copyright © 2019 Filipp. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var array : [Person] = []
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReuest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            array = try context.fetch(fetchReuest)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) { 
        guard let newPerson = segue.source as? SecondViewController else { return }
        guard  let person = newPerson.savePerson() else {
            tableView.reloadData()
            return
        }
        array.append(person)
        tableView.reloadData()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPerson" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let person = array[indexPath.row]
    
            let newVC = segue.destination as! SecondViewController
            newVC.isCurrent = true
            newVC.index = indexPath.row
            newVC.currentPerson = person
        }
    }
    
    
    //Comment 


}



