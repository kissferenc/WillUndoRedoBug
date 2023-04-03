//
//  WillUndoRedoBugApp.swift
//  WillUndoRedoBug
//

import SwiftUI

@main
struct WillUndoRedoBugApp: App {
	@StateObject var model = Model()

    var body: some Scene {
        WindowGroup {
			NavigationStack {
				ContentView()
					.environmentObject(model)
			}
        }
    }
}
