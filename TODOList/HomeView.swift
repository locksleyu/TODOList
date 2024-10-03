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
			.padding(30)
			
			Button("Start")
			{
				showingMain = true
			}
			.sheet(isPresented: $showingMain) {
				ContentView()
			}
			.padding(30)

			Text("by: Jeffrey Wisgo")
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
