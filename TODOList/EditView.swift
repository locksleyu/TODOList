//
//  EditView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/3/24.
//

import SwiftUI

struct EditView: View {
	@Binding var todoItems: [TodoItem]
	@Binding var showEditView: Bool
	@Binding var indexOfItemToEdit: Int

	@State var originalTitle: String
	@State var disableSave: Bool = true
	var body: some View {
		ZStack(alignment: .center) {
			VStack {
				Spacer()
				TextField("EditItem", text: $todoItems[indexOfItemToEdit].title, axis: .vertical)
					.padding(30)
					.padding(.top, 40)
					.font(.body)
					.background(Color.gray)
					.onChange(of: todoItems[indexOfItemToEdit].title) { newValue in
						disableSave = (newValue == originalTitle)
					}
					.accessibilityIdentifier("EditTaskTextField")
				Spacer()
				Spacer()
			}
			VStack(alignment: .center) {
				Text("Edit item").padding(30).bold()
				Spacer()
			}
			VStack {
				HStack {
					Button(action: {
						showEditView = false
					}) {
						Text("Save")
							.font(.headline)
							.padding(20)
					}
					.disabled(disableSave)
					Spacer()
					Button(action: {
						showEditView = false
						todoItems[indexOfItemToEdit].title = originalTitle
					}) {
						Text("Cancel")
							.font(.headline)
							.padding(20)
					}
				}
				.padding(5)
				Spacer()
				Button(action: {
					TodoItemsLogic.removeItemWithID(&todoItems, id: todoItems[indexOfItemToEdit].id)
					showEditView = false
				}) {
					Text("Delete Task")
						.font(.headline)
						.padding(20)
						.tint(.red)
				}
			}
		}
	}
	
	struct EditView_PreviewsContainer: View {
		@State var todoItems: [TodoItem] = [TodoItem(userId: 1, id: 1, title: "test", completed: false)]
		@State var showEditView: Bool = false
		@State var indexOfItemToEdit: Int = 0
		
		var body: some View {
			EditView(todoItems: $todoItems, showEditView: $showEditView, indexOfItemToEdit: $indexOfItemToEdit, originalTitle: "original title")
		}
	}
	struct EditView_Previews: PreviewProvider {
		static var previews: some View {
			EditView_PreviewsContainer()
		}
	}
	
}
