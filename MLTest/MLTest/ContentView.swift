import SwiftUI
import CoreML // Don't forget this import

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Testing MNIST Model...")
        }
        .onAppear {
            // Attempt to initialize the model
            // The class name is derived from the filename
            let model = try? MNIST_Classifier()
            if model != nil {
                print("Successfully loaded MNISTClassifier!")
            } else {
                print("Failed to load MNISTClassifier.")
            }
        }
    }
}
