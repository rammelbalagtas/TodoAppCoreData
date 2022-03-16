//
//  ToDoListTableViewController.swift
//  TodoAppCoreData
//
//  Created by Rammel on 2022-03-11.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer!
    var toDoList = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetch data from database
        fetchData()
        //reload table view
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as? ToDoTableViewCell
        else {preconditionFailure("cannot deque reusable cell")}
        // Configure the cell...
        let todo = toDoList[indexPath.row]
        // add strikethrough for completed task
        if todo.isComplete {
            let title = NSAttributedString(string: todo.title!, attributes:
                                        [.strikethroughStyle: 2,
                                         .strikethroughColor: UIColor.gray])
            cell.titleLabel?.attributedText = title
        } else {
            let title = NSAttributedString(string: todo.title!)
            cell.titleLabel?.attributedText = title
        }
        return cell
    }
    
    // to toggle between complete and not complete
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoList[indexPath.row].isComplete.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete from data source
            let moc = persistentContainer.viewContext
            moc.delete(self.toDoList[indexPath.row])
            moc.perform {
                do {
                    try moc.save()
                } catch {
                    moc.rollback()
                }
                //update table view
                self.fetchData()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // add todo item via a popup alert contol
    @IBAction func addToDoButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add ToDo", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { field in
            field.placeholder = "Enter you todo item"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { [self] _ in
            guard let fields = alert.textFields else { return }
            let todoField = fields[0]
            guard let title = todoField.text, !title.isEmpty else { return }
    
            //save todo
            let moc = persistentContainer.viewContext
            let todo = ToDo(context: moc)
            todo.title = title
            moc.perform {
                do {
                    try moc.save()
                } catch {
                    moc.rollback()
                }
                //update table view
                self.fetchData()
                tableView.reloadData()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchData() {
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let moc = persistentContainer.viewContext
        guard
            let results = try? moc.fetch(request)
        else {return}
        toDoList = results
    }
    
}
