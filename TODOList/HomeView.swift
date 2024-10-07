//
//  HomeView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/2/24.
//

import SwiftUI

// View that is shown with the app first loads. Shows basic information about the app and allows jumping into
// the main view via a button.

struct HomeView: View {
	@State var showingMain = false
    var body: some View {
		VStack {
			Text("TODO List")
			.padding(10)
			.font(.title)
			Text("Application Challenge")
			.padding(10)
			.font(.title)
			Button("Start")
			{
				showingMain = true
			}
			.fullScreenCover(isPresented: $showingMain) {
				MainView(showingMain: $showingMain)
			}
			.padding(30)
			.font(.largeTitle)

			Text("by: Jeffrey Wisgo")
				.font(.headline)
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
