//
//  TodoList.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/4/24.
//

import Foundation

struct TodoItem: Codable, Identifiable {
	let userId: Int
	let id: Int
	var title: String
	var completed: Bool
}

extension TodoItem: Equatable {
	static func == (first: TodoItem, second: TodoItem) -> Bool {
		return first.id == second.id && first.title == second.title && first.userId == second.userId && first.completed == second.completed
	}
}

// note: in the future we could refactor to use this struct instead of a [TodoItem] structure in MainView
struct TodoItemsLogic {
	static func removeItemWithID(_ todoItems: inout [TodoItem], id: Int)
	{
		todoItems.removeAll() {$0.id == id}
	}
	static func updateCompleteStateOfItem(_ todoItems: inout [TodoItem], item: TodoItem)
	{
		if let index = todoItems.firstIndex(of: item) {
			todoItems[index].completed = !todoItems[index].completed;
		}
	}
	static func getNextId(_ todoItems: [TodoItem]) -> Int {
		let nextId = (todoItems.map {$0.id}.max() ?? 1000) + 1
		return nextId
	}
}
