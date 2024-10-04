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
	
	public func isAddItem() -> Bool {
		return (id == -1)
	}
	public func isRegularItem() -> Bool {
		return (id != -1)
	}
	
	public static func createAddItem() -> TodoItem
	{
		return TodoItem(userId: -1, id: -1, title: "Add Item", completed: false)
	}
}

extension TodoItem: Equatable {
	static func == (first: TodoItem, second: TodoItem) -> Bool {
		return first.id == second.id && first.title == second.title && first.userId == second.userId && first.completed == second.completed
	}
}

// In the future we could refactor to use this struct instead of a [TodoItem] structure in MainView
struct TodoItemsLogic {
	static func removeItemWithID(_ todoItems: inout [TodoItem], id: Int)
	{
		todoItems.removeAll() {$0.id == id}
	}
	static func toggleCompleteStateOfItem(_ todoItems: inout [TodoItem], item: TodoItem)
	{
		if let index = todoItems.firstIndex(of: item) {
			todoItems[index].completed = !todoItems[index].completed;
		}
	}
	static func getNextId(_ todoItems: [TodoItem]) -> Int {
		let nextId = (todoItems.map {$0.id}.max() ?? 1000) + 1
		return nextId
	}
	static func fetchRemoteDataFromNetwork(completionHandler: @escaping (_ todoItems: [TodoItem]?, _ error: Error?) -> ()) {
		let url = URL(string: Configuration.TODOItemsFetchFullURL)!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"  // optional
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let task = URLSession.shared.dataTask(with: request){ data, response, error in
			if let error = error {
				print("Error while fetching data:", error)
				completionHandler(nil, NSError(domain: "", code: 100, userInfo: [ NSLocalizedDescriptionKey: "Error fetching data"]))
			}
			guard let data = data else {
				return
			}
			do {
				let decodedData: [TodoItem] = try JSONDecoder().decode([TodoItem].self, from: data)
				completionHandler(decodedData, nil)
			} catch let jsonError {
				print("Failed to decode json", jsonError)
				completionHandler(nil, NSError(domain: "", code: 100, userInfo: [ NSLocalizedDescriptionKey: "Error decoding data"]))
			}
		}
		task.resume()
	}
}
