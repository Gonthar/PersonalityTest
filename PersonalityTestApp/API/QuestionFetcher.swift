import Foundation
import Combine

protocol APIProvider {
    func getQuestions() -> AnyPublisher<QuestionResponse, QuestionError>
}

struct MockQuestionFetcher: APIProvider {
    func getQuestions() -> AnyPublisher<QuestionResponse, QuestionError> {
        let data = QuestionResponse(
            list: [
                Question(
                    text: "At the end of a long day how do you most effectively recharge?",
                    answers: [
                        Answer(text: "Reading", score: 5),
                        Answer(text: "Taking a long bath", score: 3),
                        Answer(text: "Running or biking", score: -2)
                    ]
                ),
                Question(
                    text: "How many people would you invite to your perfect party?",
                    answers: [
                        Answer(text: "Noone", score: 6),
                        Answer(text: "A couple of close friends", score: 2),
                        Answer(text: "At least 12 people", score: -3),
                        Answer(text: "As many as possible!", score: -7)
                    ]
                ),
                Question(
                    text: "Which do you prefer?",
                    answers: [
                        Answer(text: "Inner reflection and solitude", score: 3),
                        Answer(text: "Socializing", score: -3)
                    ]
                )
            ]
        )

        return Just(data)
            .setFailureType(to: QuestionError.self)
            .eraseToAnyPublisher()
    }
}
