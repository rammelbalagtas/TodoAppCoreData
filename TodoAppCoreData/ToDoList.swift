//
//  ToDoList.swift
//  TodoAppCoreData
//
//  Created by Rammel on 2022-03-11.
//

import Foundation

class ToDoList {
    
    var list = [ToDo]()
    
    func deleteTodo(indexPath: IndexPath) {
        list.remove(at: indexPath.row)
    }
    
    @discardableResult func addTodo(title: String) -> ToDo {
        let todo = ToDo(title: title)
        list.insert(todo, at: 0)
        return todo
    }
    
    func moveTodo(fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        let tmp = list[fromIndexPath.row]
        list.remove(at: fromIndexPath.row)
        list.insert(tmp, at: toIndexPath.row)
    }
    
}
