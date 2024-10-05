//
//  AddView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/3/24.
//

import SwiftUI

struct AddView: View {
	@Binding var todoItems: [TodoItem]
	@Binding var showAddView: Bool
	@Binding var newItemTitle: String
	@Binding var nextId: Int

	var body: some View {
		ZStack(alignment: .center) {
			VStack {
				Spacer()
				TextField("Add task details here", text: $newItemTitle, axis: .vertical)
					.padding(30)
					.padding(.top, 40)
					.font(.body)
					.background(Color.gray)
					.accessibilityIdentifier("AddTaskTextField")
				Spacer()
				Spacer()
			}
			VStack(alignment: .center) {
				Text("Add item").padding(30).bold()
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
						showAddView = false
					}) {
						Text("Save")
							.font(.headline)
							.padding(20)
							.disabled(newItemTitle == "")
					}
					Spacer()
					Button(action: {
						showAddView = false
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
}

struct AddView_PreviewsContainer: View {
	@State var todoItems: [TodoItem] = [TodoItem(userId: 1, id: 1, title: "test", completed: false)]
	@State var showAddView: Bool = false
	@State var nextId: Int = 100
	@State var newItemTitle: String = "new item title"

	var body: some View {
		AddView(todoItems: $todoItems, showAddView: $showAddView, newItemTitle: $newItemTitle, nextId: $nextId)
	}
}
struct AddView_Previews: PreviewProvider {
	static var previews: some View {
		AddView_PreviewsContainer()
	}
}

