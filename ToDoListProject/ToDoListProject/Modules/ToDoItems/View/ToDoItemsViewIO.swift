//
//  ToDoItemsViewIO.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 30.06.2023.
//

import Foundation

import Foundation

// MARK: - ToDoItems ViewInput
protocol ToDoItemsViewInput: AnyObject {
    func reload()
}

// MARK: - ToDoItems ViewOutput
protocol ToDoItemsViewOutput: AnyObject {
    func didLoadView()
    func displayToDoItems(row: Int, type: ToDoItemsViewController.TypeOfTableView) -> TodoItem?
    func getCellsCount(type: ToDoItemsViewController.TypeOfTableView) -> Int
    func countOfCompleted() -> Int
    func deleteItem(type: ToDoItemsViewController.TypeOfTableView, row: Int)
    func changeIsDone(type: ToDoItemsViewController.TypeOfTableView, row: Int)
    func checkIsDone(type: ToDoItemsViewController.TypeOfTableView, row: Int) -> Bool
}
