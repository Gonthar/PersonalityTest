import Foundation

struct QuestionResponse: Codable {
    let list: [Question]
}

struct Question: Codable {
    let text: String
    let answers: [Answer]
}

struct Answer: Codable, Hashable {
    let text: String
    let score: Int
}
