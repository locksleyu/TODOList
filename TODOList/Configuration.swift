//
//  Configuration.swift
//  TODOList
//
//  Created by Jeffrey Wisgo on 10/4/24.
//

import Foundation

// put all global configuration in here
struct Configuration {
	static let TODOItemsFetchBaseURL = "https://jsonplaceholder.typicode.com/todos"
	static let UserIDToFetch = 3
	static let TODOItemsFetchFullURL = TODOItemsFetchBaseURL + "?userId=" + String(UserIDToFetch)

}
