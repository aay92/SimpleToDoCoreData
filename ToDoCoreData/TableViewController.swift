//
//  TableViewController.swift
//  ToDoCoreData
//
//  Created by Aleksey Alyonin on 21.06.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var task : [Tasks] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    @IBAction func tackAAdded(_ sender: UIBarButtonItem) {
        let aletrController = UIAlertController(title: "Write new Task", message: "Input text", preferredStyle: .alert)
        
        let safeTask = UIAlertAction(title: "Action", style: .default) { action in
            let textField = aletrController.textFields?.first
            if let newTask = textField?.text{
                self.safeData(with: newTask)
                self.tableView.reloadData()
            }
        }
        aletrController.addTextField{_ in }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { _ in })
        
        aletrController.addAction(safeTask)
        aletrController.addAction(cancel)
        
        present(aletrController, animated: true, completion: nil)
    }
    
    func safeData(with title: String){
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do{
            try context.save()
            task.append(taskObject)
            tableView.reloadData()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func removeData(with title: String){
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do{
            try context.deletedObjects
            task.removeAll()
            tableView.reloadData()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = task[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            
        }
    }
}
