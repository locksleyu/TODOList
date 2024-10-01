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
				Label {
					Text("Task 1")
				} icon: {
					Label("", systemImage: "checkmark")			.foregroundStyle(.gray)
				}
			}
			.listStyle(InsetGroupedListStyle())
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
