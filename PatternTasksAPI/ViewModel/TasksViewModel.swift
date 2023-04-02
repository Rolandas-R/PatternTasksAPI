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
    
    enum TaskFetchState {
        case fetched(Task)
        case error(Error)
    }


    func fetchUserTasks(user: User) {
        api.fetchUserTasks(userId: user.userId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
//                    self?.tableData = tasks
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
                    print("Task deleted successfully")
                case .failure(let error):
                    print("Error deleting task: \(error)")
                    if let taskIndex = self?.tasks.firstIndex(where: { $0.id == taskId }) {
                        self?.tasks.insert(self!.tasks[taskIndex], at: taskIndex)
                        self?.tasksDidChange?(self!.tasks)
                    }
                }
            }
        }
    }
    
//    func deleteTask(at index: Int) {
//        let task = tasks[index]
//        api.deleteTask(taskId: task.id) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    self?.tasks.remove(at: index)
//                    self?.tasksDidChange?(self!.tasks)
//                    print("Task deleted successfully")
//                case .failure(let error):
//                    print("Error deleting task: \(error)")
//                    // Re-add task to tableData and trigger tasksDidChange closure
//                    self?.tasks.insert(task, at: index)
//                    self?.tasksDidChange?(self!.tasks)
//                }
//            }
//        }
//    }


}
