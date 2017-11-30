//
//  ViewController.swift
//  CoreDataApplication
//
//  Created by Chandler, Jackson C. (MU-Student) on 11/30/17.
//  Copyright © 2017 Chandler, Jackson C. (MU-Student). All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
    var groceries: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Grocery")
        
        do{
            groceries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not load. \(error)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "New Item", message: "Add Grocery", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let itemToSave = textField.text else{
                return
            }
            self.save(item: itemToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(item: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: managedContext)!
        
        let grocery = NSManagedObject(entity: entity, insertInto: managedContext)
        
        grocery.setValue(item, forKeyPath: "grocery")
        
        do{
            try managedContext.save()
            groceries.append(grocery)
        } catch let error as NSError {
            print("Save Failed. \(error)")
        }
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return groceries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let grocery = groceries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = grocery.value(forKeyPath: "grocery") as? String
        return cell
    }
}
