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
	var fieldChanged: Bool = false
	var body: some View {
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
					Button(action: {
						showEditView = false
					}) {
						Text("Save")
							.font(.headline)
							.padding(20)
						//.disabled(newItemTitle == "")
					}
					Spacer()
					Button(action: {
						showEditView = false
						indexOfItemToEdit = -1 // signal that we have nothing to change
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
	
	
	struct EditView_PreviewsContainer: View {
		@State var todoItems: [TodoItem] = [TodoItem(userId: 1, id: 1, title: "test", completed: false)]
		@State var showEditView: Bool = false
		@State var indexOfItemToEdit: Int = 0
		
		var body: some View {
			EditView(todoItems: $todoItems, showEditView: $showEditView, indexOfItemToEdit: $indexOfItemToEdit)
		}
	}
	struct EditView_Previews: PreviewProvider {
		static var previews: some View {
			EditView_PreviewsContainer()
		}
	}
	
}
