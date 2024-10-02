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
					// Assigning the data to the array
					self.todoItems = decodedData
				} catch let jsonError {
					print("Failed to decode json", jsonError)
				}
			}

			task.resume()
		}
	var body: some View {
		VStack {
			Text("TODO List").font(.headline)
			List (todoItems) { item in
				Label {
					Text(item.title)
				} icon: {
					Label("", systemImage: "checkmark")
						.foregroundStyle(.gray)
				}
			}
			.listStyle(InsetGroupedListStyle())
			.onAppear {
				fetchRemoteData()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
