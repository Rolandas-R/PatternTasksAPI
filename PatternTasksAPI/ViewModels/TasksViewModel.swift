//
//  TaskListViewModel.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-04-02.
//

import Foundation

class TasksViewModel {
    
    private let api = SwaggerAPI()
    
    var tasks: [Task] = [] {
           didSet {
               tasksDidChange?(tasks)
           }
       }
    
    var tasksDidChange: (([Task]) -> Void)?



    func fetchUserTasks(user: User) {
        api.fetchUserTasks(userId: user.userId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasks = tasks
                    self?.tasksDidChange?(tasks)
                case .failure(let error):
                    print("Error fetching tasks: \(error)")
                }
            }
        }
    }
    
    func deleteTask(taskId: Int) {
        api.deleteTask(taskId: taskId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let taskIndex = self?.tasks.firstIndex(where: { $0.id == taskId }) {
                        self?.tasks.remove(at: taskIndex)
                        self?.tasksDidChange?(self!.tasks)
                        print("Task deleted successfully")
                    }

                case .failure(let error):
                    print("Error deleting task: \(error)")

                    }
                }
            }
        }
    }
    



