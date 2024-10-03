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
}

/*
// TODO: fix preview
 
struct SwiftUIView_Previews: PreviewProvider {
	@State var todoItems: [TodoItem] = []
	@State var showEditView: Bool = false
	@State var indexOfItemToEdit: Int = 0
		
    static var previews: some View {
		EditView(todoItems: $todoItems, showEditView: $showEditView, indexOfItemToEdit: $indexOfItemToEdit)
    }
}

#Preview {
	struct Preview: View {
		@State var number = 10
		var body: some View {
			MyView(number: $number)
		}
	}

	return Preview()
}
*/


