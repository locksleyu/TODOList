//
//  ContentView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import SwiftUI

// https://jsonplaceholder.typicode.com/todos

struct TodoItem: Codable, Identifiable {
	let userId: Int
	let id: Int
	var title: String
	var completed: Bool
}

extension TodoItem: Equatable {
  static func ==(first: TodoItem, second: TodoItem) -> Bool {
	  return first.id == second.id && first.title == second.title && first.userId == second.userId && first.completed == second.completed
  }
}

struct ContentView: View {
	@State private var todoItems: [TodoItem] = []
	@State private var showEditView: Bool = false
	@State private var showAddView: Bool = false
	@State private var indexOfItemToEdit: Int = 0
	@State private var newItemTitle: String = ""
	@State private var nextId: Int = 100 // todo, set properly
	
	let filterOptions = ["All Tasks", "Active Tasks", "Completed Tasks"]
	@State private var filterSelection = "Active Tasks"
	
	@State private var showingHome: Bool = false
	
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
			Picker("Filter", selection: $filterSelection) {
							ForEach(filterOptions, id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.menu)
			List {
				ForEach ($todoItems) { $item in
					var _ = print("==> id = \($item.id), completed = \($item.completed)")

					//Text("==> ID: \($item.id) - Value: \(item.completed)")

					if (itemPassesFilter(item: item)) {
						HStack {
							if($item.id != -1) {
								var _ = print("id = \(item.id), completed = \($item.completed)")
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
								if (item.id == -1) { // add item
									newItemTitle = ""
									showAddView = true;
								}
								else {
									var _ = print("before = \(item.completed), now = \(!item.completed), id = \(item.id)")
									updateCompleteStateOfItem(item: item)
								}
							})
							.foregroundColor(getForegroundColor(item:item))
						}
						.listRowSeparator(.hidden)
						.listRowBackground(
							Color(UIColor.secondarySystemGroupedBackground)
								.overlay(alignment: .bottom) {
									
									Divider()
								})
						.contentShape(Rectangle())
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
				.clipShape(RoundedRectangle(cornerRadius: 0.0, style: .continuous))
				.font(.body)
			}
			.onAppear {
				fetchRemoteData()
			}
			.sheet(isPresented: $showEditView) {
				editView
			}
			.sheet(isPresented: $showAddView) {
				addView
			}

			Button("Back to home page")
			{
				showingHome = true
			}
			.fullScreenCover(isPresented: $showingHome) {
				HomeView()
			}
			.padding(30)
			.font(.title)
		}
	}
	func getForegroundColor(item: TodoItem) -> Color
	{
		if (item.id == -1) {return Color.gray}
		else {return Color.black}
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
					}) {
						Image(systemName: "xmark.circle").padding(20)
					}
				}
				.padding(5)
				Spacer()
			}
		}
	}
	var addView: some View {
		ZStack(alignment: .center) {
			VStack {
				Spacer()
				TextField("Add task details here", text: $newItemTitle, axis: .vertical)
					.padding(30)
					.padding(.top, 40)
					.background(Color.gray)
				Spacer()
				Spacer()
			}
			VStack(alignment: .center) {
				Text("Add task").padding(30).bold()
				Spacer()
			}
			VStack {
				HStack {
					Button(action: {
						if (newItemTitle != "") {
							let newItem = TodoItem(userId: 3, id: nextId, title: newItemTitle, completed: false)
							todoItems.insert(newItem, at: todoItems.count-1)
							nextId += 1
						}
						showAddView = false // dismiss
					}) {
						Text("Save")
							.font(.headline)
							.padding(20)
							.disabled(newItemTitle == "")
					}
					Spacer()
					Button(action: {
						showAddView = false // dismiss
					}) {
						Text("Cancel")
							.font(.headline)
							.padding(20)
					}
				}
				.padding(5)
				Spacer()
			}
		}
	}
	func itemPassesFilter(item: TodoItem) -> Bool
	{
		if (filterSelection == "Active Tasks")
		{
			if ((item.id != -1) && (item.completed == true)) {
				return false
			}
		} else if (filterSelection == "Completed Tasks")
		{
			if ((item.id != -1)  && (item.completed == false)) {
				return false
			}
		}
		return true
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
			
			todoItems[index].completed = !todoItems[index].completed;
		}
		print("new items = \(todoItems)")
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
