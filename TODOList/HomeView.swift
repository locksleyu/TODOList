//
//  HomeView.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/2/24.
//

import SwiftUI

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
