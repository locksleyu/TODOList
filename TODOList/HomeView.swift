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
			Text("TODO List Application Challenge")
			.padding(20)
			.font(.headline)
			
			Button("Start")
			{
				showingMain = true
			}
			.fullScreenCover(isPresented: $showingMain) {
				ContentView()
			}
			.padding(30)
			.font(.largeTitle)

			Text("by: Jeffrey Wisgo")
				.font(.footnote)
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
