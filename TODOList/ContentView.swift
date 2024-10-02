//
//  ContentView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import SwiftUI

// https://jsonplaceholder.typicode.com/todos


class TodoItem: Codable, Identifiable
{
	let userId: Int
	let id: Int
	var title: String
	var completed: Bool
	init (userId: Int, id: Int, title: String, completed: Bool)
	{
		self.userId = userId;
		self.id = id;
		self.title = title;
		self.completed = completed;
	}
}

/*
struct TodoItem2: Codable, Identifiable {
	let userId: Int
	let id: Int
	var title: String
	var myTitle: String
	{
		get {
			print("get returns \(title) [\(self)]")
			return title
		}
		set (n) {
			print("set sets \(n) [\(self)]")
			title = n
		}
	}
	var completed: Bool
}
*/

extension TodoItem: Equatable {
  static func ==(first: TodoItem, second: TodoItem) -> Bool {
	  return first.id == second.id // assume ID is unique
  }
}

struct ContentView: View {
	@State private var todoItems: [TodoItem] = []
	@State private var showEditView: Bool = false
	@State private var indexOfItemToEdit: Int = 0
	private func fetchRemoteData() {
			print("FETCH REMOTE DATA!")

			let url = URL(string: "https://jsonplaceholder.typicode.com/todos?userId=3")!
			var request = URLRequest(url: url)
			request.httpMethod = "GET"  // optional
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			let task = URLSession.shared.dataTask(with: request){ data, response, error in
				if let error = error {
					print("Error while fetching data:", error)
					return
				}

				guard let data = data else {
					return
				}

				do {
					let decodedData = try JSONDecoder().decode([TodoItem].self, from: data)
					// get only 5 items at most
					if ( decodedData.count <= 2) { // TODO: change to 5 before submit!!
						self.todoItems = decodedData
					}
					else {
						self.todoItems = Array(decodedData[0...1]) // TODO: change to 4 before submit!!
					}
					// TODO: find a cleaner way to integrate this special item (merge Lists)
					self.todoItems.append(TodoItem(userId: 0, id: -1, title: "Add task", completed: false))
					
				} catch let jsonError {
					print("Failed to decode json", jsonError)
				}
			}

			task.resume()
		}
	var body: some View {
		NavigationStack {
			//Text("TODO List").font(.headline)
			List {
				ForEach (todoItems) { item in
					HStack {
						if(item.id != -1) {
							var _ = print("id = \(item.id), completed = \(item.completed)")
							if (item.completed) {
								Label("", systemImage:"checkmark").foregroundStyle(.green)
							}
							else {
								Label("", systemImage:"checkmark").foregroundStyle(.gray)
							}
						}
						else {
							Label("", systemImage:"plus").foregroundStyle(.gray)
						}
						
						Button(item.title, action: {
							var _ = print("before = \(item.completed), now = \(!item.completed), id = \(item.id)")
							updateCompleteStateOfItem(item: item)
							//todoItems.append(TodoItem(userId: 1, id: 1, title: "abc", completed: false))
						})
					}
					.swipeActions {
						Button (action:{ removeItemWithID(id: item.id) }) {
							  Label("Delete", systemImage: "minus.circle")
						  }
						  .tint(.red)
						  Button (action:{
							  if let index = todoItems.firstIndex(of: item) {
								  print("found: \(index)")
								  indexOfItemToEdit = index
							  }
							  else {
								  print("not found!")
							  }
							  showEditView = true
						  }) {
							  Label("Edit", systemImage: "pencil")
						  }
						  .tint(.blue)
						}
				}
			}
			//.toolbar {
			//	EditButton()
			//}
			.onAppear {
				fetchRemoteData()
			}
			.sheet(isPresented: $showEditView) {
				editView
			}
		}
		
	}
	var editView: some View {
		ZStack(alignment: .center) {
			VStack {
				Spacer()
				TextField("EditItem", text: $todoItems[indexOfItemToEdit].title, axis: .vertical)
					.padding(30)
					.padding(.top, 40)
					.background(Color.gray)
				Spacer()
				Spacer()
			}
			VStack(alignment: .center) {
				Text("Edit item").padding(30).bold()
				Spacer()
			}
			VStack {
				HStack {
					Spacer()
					Button(action: {
						showEditView = false // dismiss
						// TODO: remove workaround
						todoItems.append(TodoItem(userId: 1, id: 1, title: "abc", completed: false))
						todoItems.removeLast()
					}) {
						Image(systemName: "xmark.circle").padding(20)
					}
				}
				.padding(5)
				Spacer()
			}
		}
	}
	func removeItemWithID(id: Int)
	{
		print("remove me!")
		todoItems.removeAll() {$0.id == id}
	}
	func updateCompleteStateOfItem(item: TodoItem)
	{
	
		print("previous items = \(todoItems)")

		if let index = todoItems.firstIndex(of: item) {
			print("found!")
			
			todoItems[index].completed = !todoItems[index].completed
			// TODO: remove workaround
			todoItems.append(TodoItem(userId: 1, id: 1, title: "abc", completed: false))
			todoItems.removeLast()
		}
			print("new items = \(todoItems)")
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
