import SwiftUI
import Combine

class TestViewModel: ObservableObject, Identifiable {
    @Published var dataSource: [TestQuestionViewModel] = []
    @Published private(set) var state = State.loading

    private let apiProvider: APIProvider
    private var disposables = Set<AnyCancellable>()
    private var totalScore: Int = 0

    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
        fetchQuestions()
    }

    private func fetchQuestions() {
        apiProvider.getQuestions()
        .map { response in
            response.list.map { [weak self] question in
                return TestQuestionViewModel(
                    question: question,
                    onAnswerSelected: { self?.answerSelected($0) }
                )
            }
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.dataSource = []
                    self.state = .error(error)
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] questions in
                guard let self = self else { return }
                self.dataSource = questions
                self.state = questions.isEmpty ? .empty : .beginTest
            }
        )
        .store(in: &disposables)
    }

    private func answerSelected(_ answer: Answer) {
        guard case .question(let questionIndex) = state else {
            fatalError("Answer selected while not presenting a question")
        }

        totalScore += answer.score
        state = questionIndex == dataSource.indices.last ? .result(totalScore) : .question(questionIndex + 1)
    }

    func beginTest() {
        guard !dataSource.isEmpty else { return }
        state = .question(0)
    }
}

extension TestViewModel {
    enum State {
        case loading
        case beginTest
        case question(Int)
        case empty
        case error(Error)
        case result(Int)
    }
}
