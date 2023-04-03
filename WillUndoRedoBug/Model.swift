//
//  Model.swift
//  WillUndoRedoBug
//

import SwiftUI
import OSLog

class Model: ObservableObject {
	let logger = Logger(subsystem: "Model", category: "setValue")
	@Published var value: Int
	init(value: Int = 10) {
		self.value = value
	}

	func setValue(_ newValue: Int, undoManager: UndoManager?) {
		let currentValue = self.value
		logger.debug("[setValue] before set oldValue: \(currentValue), newValue: \(newValue)")
		undoManager?.registerUndo(withTarget: self, handler: { model in
			model.setValue(currentValue, undoManager: undoManager)
		})
		self.value = newValue
		logger.debug("[setValue] after set oldValue: \(currentValue), newValue: \(newValue)")
	}
}
