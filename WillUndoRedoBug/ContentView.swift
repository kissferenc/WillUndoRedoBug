//
//  ContentView.swift
//  WillUndoRedoBug
//

import SwiftUI
import OSLog

struct ContentView: View {
	@Environment(\.undoManager) var undoManager
	@EnvironmentObject var model: Model
	let logger = Logger(subsystem: "ContentView", category: "changeValue")

	private let willUndoPublisher = NotificationCenter.default.publisher(for: .NSUndoManagerWillUndoChange)
	private let willRedoPublisher = NotificationCenter.default.publisher(for: .NSUndoManagerWillRedoChange)
	private let didUndoPublisher = NotificationCenter.default.publisher(for: .NSUndoManagerDidUndoChange)
	private let didRedoPublisher = NotificationCenter.default.publisher(for: .NSUndoManagerDidRedoChange)
	private let undoDidClosePublisher = NotificationCenter.default.publisher(for: .NSUndoManagerDidCloseUndoGroup)

	@State private var canUndo = false
	@State private var canRedo = false

	var body: some View {
		VStack {
			Text("Value: \(model.value)")
			HStack {
				Button("increase") {
					model.setValue(model.value + 1, undoManager: self.undoManager)
				}

				Button("decrease") {
					model.setValue(model.value - 1, undoManager: self.undoManager)
				}
			}
		}
		.padding()
		.onReceive(willUndoPublisher) { _ in logger.debug("willUndo") }
		.onReceive(willRedoPublisher) { _ in logger.debug("willRedo") }
		.onReceive(didUndoPublisher) { _ in logger.debug("didUndo"); updateUndoState() }
		.onReceive(didRedoPublisher) { _ in logger.debug("didRedo"); updateUndoState() }
		.onReceive(undoDidClosePublisher) { _ in logger.debug("undoDidClose"); updateUndoState() }
		.navigationTitle("ContentView")
		.toolbar {
#if os(iOS)
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button {
					self.undoManager?.undo()
				} label: {
					Label("Undo", systemImage: "arrow.uturn.backward.circle")
				}
				.disabled(!canUndo)

				Button {
					self.undoManager?.redo()
				} label: {
					Label("Redo", systemImage: "arrow.uturn.forward.circle")
				}
				.disabled(!canRedo)
			}
#endif
		}
	}

	func updateUndoState() {
#if os(iOS)
		canUndo = self.undoManager?.canUndo ?? false
		canRedo = self.undoManager?.canRedo ?? false
#endif
	}
}

struct ContentView_Previews: PreviewProvider {
	static let model = Model()
	static var previews: some View {
		ContentView()
			.environmentObject(model)
	}
}
