//
//  ContentView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import SwiftUI

// https://jsonplaceholder.typicode.com/todos
/*
"userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
*/

struct TodoItem: Codable, Identifiable {
	let userId: Int
	let id: Int
	let title: String
	let completed: Bool
}

struct ContentView: View {
	@State private var todoItems: [TodoItem] = []
	private func fetchRemoteData() {
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
					if ( decodedData.count <= 5) {
						self.todoItems = decodedData
					}
					else {
						self.todoItems = Array(decodedData[0...4])
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
		VStack {
			Text("TODO List").font(.headline)
			List {
				Section {
					ForEach (todoItems) { item in
						Label {
							Text(item.title)
						} icon: {
							if(item.id == -1) {
								Label("", systemImage:"checkmark").foregroundStyle(.gray)
							}
							else {
								Label("", systemImage:"plus").foregroundStyle(.gray)
							}
						}
					}
				}
			}
			.onAppear {
				fetchRemoteData()
			}
		
		}
	}
}
/*
 +
 List {
	 Label {
		 Text("Add task")
	 } icon: {
		 Label("", systemImage: "plus")
			 .foregroundStyle(.gray)
	 }
 }
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
