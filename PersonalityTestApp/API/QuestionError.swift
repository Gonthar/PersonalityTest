import Foundation

enum QuestionError: Error {
    case connection(description: String)
    case parsing(description: String)
}
