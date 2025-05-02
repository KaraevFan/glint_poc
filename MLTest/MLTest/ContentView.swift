import SwiftUI
import CoreML // Add this import

struct ContentView: View {
    // Try to initialize the model (ignore errors for now)
    let encoderModel = try? coreml_encoder_base_en()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            // You can optionally display if the model loaded
            // Text(encoderModel == nil ? "Encoder Failed" : "Encoder Loaded")
        }
        .padding()
    }
}
