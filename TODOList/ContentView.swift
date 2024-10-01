//
//  ContentView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			Text("TODO List").font(.headline)
			List {
				Label("Your account", systemImage: "checkmark")
				Text("Item 1")
				Text("Item 2")
				Text("Item 3")
				Text("Add Task")
			}
			.listStyle(InsetGroupedListStyle())
			.foregroundStyle(.gray)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
