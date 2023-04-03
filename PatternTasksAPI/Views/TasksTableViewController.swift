//
//  TasksTableViewController.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-04-02.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    
    private let viewModel = TasksViewModel()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
 
        viewModel.tasksDidChange = { [weak self] tasks in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        if let user = user {
            viewModel.fetchUserTasks(user: user)
            self.tableView.reloadData()
            
        }
   }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        var cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "taskCell")
        
        cell.textLabel?.text = viewModel.tasks[indexPath.row].title
        cell.detailTextLabel?.text = viewModel.tasks[indexPath.row].description
        cell.textLabel?.font = .systemFont(ofSize: 24)
        cell.detailTextLabel?.font = .systemFont(ofSize: 16)

        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskId = viewModel.tasks[indexPath.row].id
                if editingStyle == .delete {
                    viewModel.deleteTask(taskId: taskId)
        } else if editingStyle == .insert {
            return
        }
    }
}
