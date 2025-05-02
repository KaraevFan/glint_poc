//
// MNIST_Classifier.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, visionOS 1.0, *)
class MNIST_ClassifierInput : MLFeatureProvider {

    /// Image of the digit drawing to be classified as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    var image: CVPixelBuffer

    var featureNames: Set<String> { ["image"] }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "image" {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }

    init(image: CVPixelBuffer) {
        self.image = image
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
    convenience init(imageWith image: CGImage) throws {
        self.init(image: try MLFeatureValue(cgImage: image, pixelsWide: 28, pixelsHigh: 28, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
    convenience init(imageAt image: URL) throws {
        self.init(image: try MLFeatureValue(imageAt: image, pixelsWide: 28, pixelsHigh: 28, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 28, pixelsHigh: 28, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 28, pixelsHigh: 28, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!
    }

}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, visionOS 1.0, *)
class MNIST_ClassifierOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// Probability of each digit as dictionary of 64-bit integers to doubles
    var labelProbabilities: [Int64 : Double] {
        provider.featureValue(for: "labelProbabilities")!.dictionaryValue as! [Int64 : Double]
    }

    /// Most likely digit as integer value
    var classLabel: Int64 {
        provider.featureValue(for: "classLabel")!.int64Value
    }

    var featureNames: Set<String> {
        provider.featureNames
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }

    init(labelProbabilities: [Int64 : Double], classLabel: Int64) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["labelProbabilities" : MLFeatureValue(dictionary: labelProbabilities as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(int64: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, visionOS 1.0, *)
class MNIST_Classifier {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "MNIST Classifier", withExtension:"mlmodelc")!
    }

    /**
        Construct MNIST_Classifier instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of MNIST_Classifier.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `MNIST_Classifier.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct MNIST_Classifier instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct MNIST_Classifier instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct MNIST_Classifier instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<MNIST_Classifier, Error>) -> Void) {
        load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct MNIST_Classifier instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> MNIST_Classifier {
        try await load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct MNIST_Classifier instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<MNIST_Classifier, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(MNIST_Classifier(model: model)))
            }
        }
    }

    /**
        Construct MNIST_Classifier instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> MNIST_Classifier {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return MNIST_Classifier(model: model)
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as MNIST_ClassifierInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as MNIST_ClassifierOutput
    */
    func prediction(input: MNIST_ClassifierInput) throws -> MNIST_ClassifierOutput {
        try prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as MNIST_ClassifierInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as MNIST_ClassifierOutput
    */
    func prediction(input: MNIST_ClassifierInput, options: MLPredictionOptions) throws -> MNIST_ClassifierOutput {
        let outFeatures = try model.prediction(from: input, options: options)
        return MNIST_ClassifierOutput(features: outFeatures)
    }

    /**
        Make an asynchronous prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as MNIST_ClassifierInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as MNIST_ClassifierOutput
    */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
    func prediction(input: MNIST_ClassifierInput, options: MLPredictionOptions = MLPredictionOptions()) async throws -> MNIST_ClassifierOutput {
        let outFeatures = try await model.prediction(from: input, options: options)
        return MNIST_ClassifierOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        It uses the default function if the model has multiple functions.

        - parameters:
            - image: Image of the digit drawing to be classified as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as MNIST_ClassifierOutput
    */
    func prediction(image: CVPixelBuffer) throws -> MNIST_ClassifierOutput {
        let input_ = MNIST_ClassifierInput(image: image)
        return try prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - inputs: the inputs to the prediction as [MNIST_ClassifierInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [MNIST_ClassifierOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    func predictions(inputs: [MNIST_ClassifierInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [MNIST_ClassifierOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [MNIST_ClassifierOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  MNIST_ClassifierOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
