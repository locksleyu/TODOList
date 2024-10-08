//
//  MainView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import SwiftUI

enum FilterOptions: String, Equatable, CaseIterable {
	case allTasks  		= "All Tasks"
	case activeTasks	= "Active Tasks"
	case completedTasks	= "Completed Tasks"
	
	var localizedName: LocalizedStringKey {
		LocalizedStringKey(rawValue)
	}
}

// Main view that shows elements and allows adding or deleting. The top has a picker to allow
// sorting by All Tasks, etc.

struct MainView: View {
	@Environment(\.colorScheme) var colorScheme
	@State internal var todoItems: [TodoItem] = []
	@State internal var enabledItems: [Int: Bool] = [:]

	@Binding var showingMain: Bool

	@State private var showEditView: Bool = false
	@State private var showAddView: Bool = false
	@State private var showHome: Bool = false
	@State private var showAlert: Bool = false
	
	@State private var alertText: String = "Error"
	@State private var indexOfItemToEdit: Int = 0
	@State private var newItemTitle: String = ""
	@State private var nextId: Int = 0
	@State private var filterSelection: FilterOptions = .activeTasks
	
	internal func fetchRemoteData() {
		TodoItemsLogic.fetchRemoteDataFromNetwork { todoItems, error in
			guard error == nil else {
				showAlert(error?.localizedDescription ?? "Error fetching data")
				return;
			}
			if let todoItems = todoItems {
				if ( todoItems.count <= Configuration.MaxFetchedItems) {
					self.todoItems = todoItems
				}
				else {
					self.todoItems = Array(todoItems[0...Configuration.MaxFetchedItems-1])
				}
				self.todoItems.append(TodoItem.createAddItem())
				self.nextId = TodoItemsLogic.getNextId(todoItems)
				
				self.todoItems.forEach { item in
					enabledItems[item.id] = true
				}
			}
		}
	}
	var body: some View {
		NavigationStack {
			Picker("Filter", selection: $filterSelection) {
				ForEach(FilterOptions.allCases, id: \.self) { value in // \.self is needed b/c enum doesn't confirm to Identifable
					Text(value.localizedName)
					.tag(value)
					.accessibilityIdentifier("FilterPicker")
				}
			}
			.pickerStyle(.menu)
			List {
				ForEach ($todoItems) { $item in
					if (itemPassesFilter(item: item)) {
						HStack {
							Button  {
								if (item.isRegularItem()) {
									TodoItemsLogic.toggleCompleteStateOfItem(&todoItems, item: item)
								}
								else {
									newItemTitle = ""
									showAddView = true
								}
							} label: {
								if (item.isRegularItem()) {
									if (item.completed) {
										Label("", systemImage:"checkmark").foregroundStyle(.green).bold()
									}
									else {
										Label("", systemImage:"checkmark").foregroundStyle(.gray)
									}
								}
								else {
									Label("", systemImage:"plus").foregroundStyle(.gray)
								}
								
							}
							.buttonStyle(.borderless)

							Button(action: {
								if (item.isRegularItem()) {
										if let index = todoItems.firstIndex(of: item) {
											indexOfItemToEdit = index
										}
										showEditView = true
								}
								else {
									newItemTitle = ""
									showAddView = true
								}
							}) {
								HStack {
									Text(item.title)
										.multilineTextAlignment(.leading)
									Spacer()
								}
							}
							.buttonStyle(.borderless)
							.accessibilityIdentifier("ItemButton")
							.foregroundColor(getForegroundColor(item:item, colorScheme: colorScheme))
							.swipeActions(edge: .trailing) { // swipe left
								if (item.isRegularItem()) {
									Button (action:{
										withAnimation(.linear(duration: 0.5)) {
											enabledItems[item.id] = false
										}
										// Note: for iOS 17+ we could just use completion:
										DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
											TodoItemsLogic.removeItemWithID(&todoItems, id: item.id)
										}
									}) {
										Label("Delete", systemImage: "minus.circle")
									}
									.tint(.red)
									/*
									// Design option: allow edit from left swipe
									 
									Button (action:{
										if let index = todoItems.firstIndex(of: item) {
											indexOfItemToEdit = index
										}
										showEditView = true
									}) {
										Label("Edit", systemImage: "pencil")
									}
									.tint(.blue)
									.accessibilityIdentifier("SwipeLeft")
									 */
								}
							}
							.swipeActions(edge: .leading) { // swipe right
								if (item.isRegularItem()) {
									Button (action:{
										if let index = todoItems.firstIndex(of: item) {
											indexOfItemToEdit = index
										}
										showEditView = true
									}) {
										Label("Edit", systemImage: "pencil")
									}
									.tint(.blue)
									.accessibilityIdentifier("SwipeRight")
								}
							}
						}
						.listRowSeparator(.hidden)
						.listRowBackground(
							Color(UIColor.secondarySystemGroupedBackground)
								.overlay(alignment: .bottom) {
									Divider()
								})
						.contentShape(Rectangle())
						.opacity((enabledItems[item.id] ?? true) ? 1.0 : 0.0) // used to animation deletion from swipe
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
				showingMain = false
			}
			.fullScreenCover(isPresented: $showHome) {
				HomeView()
			}
			.padding(5)
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
	func getForegroundColor(item: TodoItem, colorScheme: ColorScheme) -> Color
	{
		if (item.isAddItem()) {return (colorScheme == .light) ? Color.gray : Color.gray}
		else {return (colorScheme == .light) ? Color.black : Color.white}
	}
	func itemPassesFilter(item: TodoItem) -> Bool
	{
		if (filterSelection == .activeTasks)
		{
			if ((item.isRegularItem()) && (item.completed == true)) {
				return false
			}
		} else if (filterSelection == .completedTasks)
		{
			if ((item.isRegularItem()) && (item.completed == false)) {
				return false
			}
		}
		return true
	}
}


struct MainView_PreviewsContainer: View {
	@State var showingMain = true

	var body: some View {
		MainView(showingMain: $showingMain)
	}
}
struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView_PreviewsContainer()
			//.previewInterfaceOrientation(.landscapeLeft)
	}
}
