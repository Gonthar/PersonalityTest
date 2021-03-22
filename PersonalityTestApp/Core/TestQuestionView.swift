import SwiftUI

struct TestQuestionView: View {
    private let viewModel: TestQuestionViewModel

    init(viewModel: TestQuestionViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("\(viewModel.text)")
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16.0)
            ForEach(viewModel.answers, id: \.self) { answer in
                Button(action: { self.viewModel.onAnswerSelected(answer) }) {
                    Text("\(answer.text)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .border(Color.green, width: 4.0)
                .padding(.bottom, 8.0)
            }
        }
    }
}
