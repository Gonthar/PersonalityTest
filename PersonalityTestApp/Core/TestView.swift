import SwiftUI

struct TestView: View {
    @ObservedObject var viewModel: TestViewModel

    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                contentView
            }
            .padding(16.0)
            .navigationBarTitle("Are you an introvert? 🙇🏻‍♂️")
        }
    }

    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(loadingSection)
        case .beginTest:
            return AnyView(landingSection)
        case .question(let index):
            return AnyView(questionSection(questionIndex: index))
        case .empty:
            return AnyView(noQuestionsSection)
        case .error(let error):
            return AnyView(errorSection(error: error))
        case .result(let totalScore):
            return AnyView(resultSection(totalScore: totalScore))
        }
    }
}

private extension TestView {
    private var loadingSection: some View {
        LoadingIndicator(isAnimating: true)
    }

    private var noQuestionsSection: some View {
        Text("No questions found, sorry")
            .foregroundColor(.gray)
    }

    private func errorSection(error: Error) -> some View {
        return Text("We've encountered an error: \(error.localizedDescription)")
            .foregroundColor(.red)
    }

    private func questionSection(questionIndex: Int) -> some View {
        guard viewModel.dataSource.indices.contains(questionIndex) else { fatalError() }

        return TestQuestionView(viewModel: viewModel.dataSource[questionIndex])
    }

    private var landingSection: some View {
        Section {
            Text("Welcome")
                .font(.title)
                .padding(.bottom, CGFloat(16.0))
            Text("This multiple choice test will answer whether you're an introvert or an extrovert.\n\nAre you ready to start?")
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding([.leading, .trailing], CGFloat(16.0))
                .padding(.bottom, CGFloat(32.0))
            Button(action: { self.viewModel.beginTest() }) {
                Text("Begin")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .border(Color.green, width: 4.0)
        }
    }

    private func resultSection(totalScore: Int) -> some View {
        Section {
            Text("You are clearly an:")
                .font(.headline)
                .padding(.bottom, CGFloat(8.0))
            Text("\(totalScore >= 0 ? "INTROVERT" : "EXTROVERT")")
                .font(.largeTitle)
                .foregroundColor(.green)
        }
    }
}
