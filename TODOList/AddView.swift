//
//  AddView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/3/24.
//

import SwiftUI

// View that is used to add a new item.

struct AddView: View {
	@Environment(\.colorScheme) var colorScheme

	@Binding var todoItems: [TodoItem]
	@Binding var showAddView: Bool
	@Binding var newItemTitle: String
	@Binding var nextId: Int

	var body: some View {
		ZStack(alignment: .center) {
			VStack {
				Spacer()
				TextField("Add task details here", text: $newItemTitle, axis: .vertical)
					.padding(20)
					.font(.body)
					.foregroundColor(getForegroundColor(colorScheme: colorScheme))
					.background(getBackgroundColor(colorScheme: colorScheme))
					.accessibilityIdentifier("AddTaskTextField")
					.overlay(
						Rectangle()
						.stroke(Color.white)
						.padding(0)
					)
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
						showAddView = false
					}) {
						Text("Cancel")
							.font(.headline)
							.padding(20)
					}
					Spacer()
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
				}
				.padding(5)
				Spacer()
			}
		}
	}
	func getBackgroundColor(colorScheme: ColorScheme) -> Color
	{
		if (colorScheme == .dark) {return Color(red: 0.3, green: 0.3, blue: 0.3)}
		else {return Color(red: 0.8, green: 0.8, blue: 0.8)}
	}
	func getForegroundColor(colorScheme: ColorScheme) -> Color
	{
		if (colorScheme == .dark) {return .white}
		else {return .black}
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

