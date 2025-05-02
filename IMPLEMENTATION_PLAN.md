# Glint – On-Device ASR Proof-of-Concept  
Implementation Plan (aligned with README checklist)

## Goal  
Build an iOS app that demonstrates real-time, on-device speech-to-text using a Core ML-converted Whisper model, while meeting specific performance and reliability criteria.

---

## Plan

### 1. Bootstrap Xcode Project & CI *(Checklist Item 1)*  
- Verify the existing **`Glint_mobile_POC`** Xcode project structure.  
- Configure fundamental project settings (Bundle ID, signing, etc.).  
  _(Apple Developer–specific tasks may need separate assistance.)_

### 2. Convert Whisper → Core ML *(Checklist Item 2)*  
- Locate or obtain the model-conversion script listed in the dependencies.  
- Run the script to generate the **`.mlmodel`** file.  
- Add the generated model to the Xcode project.  
- Create a quick test utility to load the model on device/simulator and perform a dummy prediction.

### 3. Wire AVFoundation Capture *(Checklist Item 3)*  
- Implement an **`AudioEngine`** module that:  
  - Requests microphone permission.  
  - Configures **`AVAudioSession`**.  
  - Sets up **`AVAudioEngine`** for live audio capture.  
  - Exposes raw audio buffers (delegate or Combine publisher).  
  - Handles session interruptions and errors gracefully.

### 4. Hook Core ML Inference Pipeline *(Checklist Item 4)*  
- Implement a **`TranscriptionService`** that:  
  - Receives buffers from `AudioEngine`.  
  - Pre-processes audio for Whisper-Core ML.  
  - Runs inference via Core ML.  
  - Converts model output into partial/final transcripts.  
  - Publishes transcript updates (e.g., with Combine).

### 5. Build SwiftUI Recording UI + Live Transcript *(Checklist Item 5)*  
- Create the main **`ContentView`** in SwiftUI.  
- Add a simple state machine: *Idle → Recording → Processing → Error*.  
- Record/Stop button triggers `AudioEngine` & `TranscriptionService`.  
- Display live transcript updates in real time.  
- Show a recording timer.  
- Surface any audio/transcription errors to the user.

### 6. Add `os_signpost` Latency & Battery Logging *(Checklist Item 6)*  
- Insert `os_signpost` markers in both `AudioEngine` and `TranscriptionService` to time key phases (record start/stop, inference duration, etc.).  
- Sample battery level periodically (e.g., `UIDevice.current.batteryLevel`) during active transcription.  
- Log all metrics via **`OSLog`** for later analysis.

### 7. Run Validation Suite *(Checklist Item 7)*  
- Execute the tests defined in the *Validation Plan* (Latency, Accuracy, Battery, Stability).  
- Collect results and compare to success criteria; iterate if necessary.

---

## Execution Approach
- Attack one checklist item at a time.  
- Before each step, propose file structure and key `class` / `struct` definitions.  
- Request confirmation **before** creating or modifying project files.  
- After major milestones (e.g., audio capture, inference wiring), outline how to manually or automatically test that layer.

---