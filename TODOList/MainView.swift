//
//  ContentView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import SwiftUI

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

struct MainView: View {
	@State private var todoItems: [TodoItem] = []
	
	@State private var showEditView: Bool = false
	@State private var showAddView: Bool = false
	@State private var showHome: Bool = false
	@State private var showAlert: Bool = false
	@State private var alertText: String = "Error"
	@State private var indexOfItemToEdit: Int = 0
	@State private var newItemTitle: String = ""
	@State private var nextId: Int = 0
	
	let filterOptions = ["All Tasks", "Active Tasks", "Completed Tasks"]
	@State private var filterSelection = "Active Tasks"
	
	private func fetchRemoteData() {
		let url = URL(string: "https://jsonplaceholder.typicode.com/todos?userId=3")!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"  // optional
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let task = URLSession.shared.dataTask(with: request){ data, response, error in
			if let error = error {
				print("Error while fetching data:", error)
				showAlert("Error fetching initial data")
				return
			}
			guard let data = data else {
				return
			}
			do {
				let decodedData = try JSONDecoder().decode([TodoItem].self, from: data)
				// get only 5 items at most
				if ( decodedData.count <= 5) { // TODO: change to 5 before submit!!
					self.todoItems = decodedData
				}
				else {
					self.todoItems = Array(decodedData[0...4]) // TODO: change to 4 before submit!!
				}
				// TODO: find a cleaner way to integrate this special item (merge Lists)
				self.todoItems.append(TodoItem(userId: 0, id: -1, title: "Add task", completed: false))
				self.nextId = getNextId()
				
			} catch let jsonError {
				print("Failed to decode json", jsonError)
				showAlert("Error decoding initial data")
			}
		}
		
		task.resume()
	}
	var body: some View {
		NavigationStack {
			Picker("Filter", selection: $filterSelection) {
				ForEach(filterOptions, id: \.self) {
					Text($0)
				}
			}
			.pickerStyle(.menu)
			List {
				ForEach ($todoItems) { $item in
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
									updateCompleteStateOfItem(item: item)
								}
							})
							.foregroundColor(getForegroundColor(item:item))
							/*
							.onTapGesture {}.onLongPressGesture(minimumDuration: 0.1) {
								if let index = todoItems.firstIndex(of: item) {
									indexOfItemToEdit = index
								}
								showEditView = true
							}*/
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
									indexOfItemToEdit = index
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
				EditView(todoItems: $todoItems, showEditView: $showEditView, indexOfItemToEdit: $indexOfItemToEdit, originalTitle: todoItems[indexOfItemToEdit].title)
			}
			.sheet(isPresented: $showAddView) {
				AddView(todoItems: $todoItems, showAddView: $showAddView, newItemTitle: $newItemTitle, nextId: $nextId)
			}
			Button("Back to home page")
			{
				showHome = true
			}
			.fullScreenCover(isPresented: $showHome) {
				HomeView()
			}
			.padding(30)
			.font(.title)
		}
		.alert(alertText, isPresented: $showAlert) {
			Button("OK", role: .cancel) { }
}
	}
	func showAlert(_ text: String)
	{
		alertText = text
		showAlert = true
	}
	func getForegroundColor(item: TodoItem) -> Color
	{
		if (item.id == -1) {return Color.gray}
		else {return Color.black}
	}
	func getNextId() -> Int {
		let nextId = ($todoItems.wrappedValue.map {$0.id}.max() ?? 1000) + 1
		return nextId
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
		todoItems.removeAll() {$0.id == id}
	}
	func updateCompleteStateOfItem(item: TodoItem)
	{
		if let index = todoItems.firstIndex(of: item) {
			todoItems[index].completed = !todoItems[index].completed;
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
	}
}
