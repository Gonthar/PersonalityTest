import Foundation
import SwiftUI

class TestQuestionViewModel: Identifiable {
    private let question: Question
    let onAnswerSelected: (Answer) -> Void
    var text: String { return question.text }
    var answers: [Answer] { return question.answers }

    init(question: Question, onAnswerSelected: @escaping (Answer) -> Void) {
        self.question = question
        self.onAnswerSelected = onAnswerSelected
    }
}
