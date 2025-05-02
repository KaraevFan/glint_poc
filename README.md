# Glint · Milestone 1 — On-Device ASR Proof of Concept

> **Goal:** Demonstrate that a Core ML–converted Whisper model can transcribe a **2-minute voice dump in ≤ 10 seconds** on iPhone (ANE-enabled), while consuming ≤ 5 % battery and remaining crash-free over 50 sessions.

---

## 1 · Success Criteria

| Objective | KPI / Pass-Fail Gate |
|-----------|---------------------|
| **Latency** | ≤ 10 s end-to-end for 120 s audio |
| **Accuracy** | ≥ 95 % WER on demo clips |
| **Reliability** | 0 crashes in 50 sequential sessions |
| **Battery** | ≤ 5 % drain per 2-min run |
| **Instrumentation** | `os_signpost` markers for start/stop + battery sampling |

---

## 2 · Scope

### In Scope
- **Audio capture** via `AVAudioEngine` / `AVAudioSession`
- **Model conversion** Whisper → Core ML (ANE-optimized)
- **SwiftUI UI**: record/stop toggle, live transcript scroll
- **Instrumentation**: latency timers, battery logging

### Out of Scope
- Networking / cloud sync  
- Advanced UI (“Reflection Card”, VAD prompts)  
- Persistent storage

---

## 3 · User Journey

1. User opens app → mic permission prompt  
2. Taps **Record** → 2-minute timer starts  
3. Audio buffered → Whisper (Core ML) produces partial transcript  
4. Live transcript shown in UI  
5. User taps **Stop** *or* timer ends → final transcript displayed  
6. Dev checks logs for latency + battery

---

## 4 · Functional Requirements

| Layer | Responsibilities |
|-------|------------------|
| **Audio Engine** | manage session, interruptions, errors |
| **Transcription Service** | stream buffers → Whisper, emit partial/final results |
| **UI Layer (SwiftUI)** | state machine, live transcript view, error banners |
| **Instrumentation** | `os_signpost` hooks, battery snapshot API |

---

## 5 · Non-Functional Requirements

- **Performance**: latency target above  
- **Reliability**: crash-free metric above  
- **Battery**: ≤ 5 % per session  
- **Privacy**: audio never leaves device

---

## 6 · Architecture Snapshot
SwiftUI View
⬇︎ user action
AVAudioEngine  →  AudioBuffer
⬇︎ streamed
Core ML Whisper (ANE)
⬇︎
Transcript Stream
↘︎ os_signpost metrics ↙︎

---

## 7 · Dependencies

- Apple Developer Program & provisioning
- Xcode 16+ / iOS 17 SDK
- Whisper → Core ML conversion script
- Test hardware: iPhone (ANE A14 or newer)

---

## 8 · Validation Plan

| Test | Device(s) | Pass Criteria |
|------|-----------|--------------|
| Latency benchmark | iPhone 12/13/14 | ≤ 10 s |
| Accuracy sample | same | ≥ 95 % WER |
| Battery profile | iPhone 14 | ≤ 5 % drain |
| Stability loop | any (50×) | 0 crashes |

---

## 9 · Milestone Checklist

- [ ] 📦  Bootstrap Xcode project & CI
- [ ] 🔄 Convert Whisper → Core ML, sanity-check on device
- [ ] 🎙  Wire AVFoundation capture
- [ ] 🧠  Hook Core ML inference pipeline
- [ ] 🖥  Build SwiftUI recording UI + live transcript
- [ ] 📊  Add `os_signpost` latency + battery logging
- [ ] ✅  Run validation suite, collect metrics

---

## 10 · Next Steps for Cursor Agent

1. **Read this doc in full.**  
2. Note that I have created a placeholder Xcode project as Glint_mobile_POC in this directory
3. Generate an **implementation game-plan** covering file/folder structure, key classes, and build commands.  
4. Execute tasks *one checklist item at a time*, asking for confirmation before modifying code across multiple files.  
5. After each step, run `swift test` (if applicable) or simulate a recording session and report metrics.  
6. Stop when all success criteria pass.  
