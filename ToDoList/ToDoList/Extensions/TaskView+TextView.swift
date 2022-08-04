//
//  TaskView+TextView.swift
//  ToDoList
//
//  Created by Igor Manakov on 04.08.2022.
//

import Foundation
import UIKit

extension TaskView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .appColor(.tertiary) {
            textView.text = nil
            textView.textColor = .appColor(.primaryLabel)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = .appColor(.tertiary)
        }
    }
}
