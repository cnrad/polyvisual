import SwiftUI
import AVFoundation

public struct Polymeter: View {
    
    // Audio players
    let engine = AVAudioEngine()
    @State var audioPlayer1: AVAudioPlayer?
    @State var audioPlayer2: AVAudioPlayer?
    
    @State var bpm: Double = 180.0
    @State var isPlaying: Bool = false
    
    @State var length1: Double = 5.0
    @State var length2: Double = 4.0
    
    @State var timer: Timer?
    
    @State var line1index: Int = 1
    @State var line2index: Int = 1
    
    // Add a default pattern for an example
    @State var line1array: Array<Int> = [1, 3, 4]
    @State var line2array: Array<Int> = [1]
    
    public func startPlaying(){
        self.isPlaying = true
        
        // Invalidate any possible previous timer instances
        timer?.invalidate()
        
        // First action
        if(line1array.contains(line1index)) {
            playTick(type: 1)
        }
        if(line2array.contains(line2index)) {
            playTick(type: 2)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: Double(60 / bpm), repeats: true) { (_) in
            if(line1index < Int(length1)){
                line1index += 1
            } else {
                line1index = 1
            }
            
            if(line2index < Int(length2)){
                line2index += 1
            } else {
                line2index = 1
            }
            
            if(line1array.contains(line1index)) {
                playTick(type: 1)
            }
            if(line2array.contains(line2index)) {
                playTick(type: 2)
            }
        }
    }
    
    public func stopPlaying() {
        self.isPlaying = false
        
        timer?.invalidate()
        line1index = 1
        line2index = 1
    }
    
    public func playTick(type: Int) {
        if let audioURL = Bundle.main.url(forResource: type == 1 ? "\(Sounds.currentSound)_1" : "\(Sounds.currentSound)_2", withExtension: "wav") {
            do {
                if (type == 1){
                    try self.audioPlayer1 = AVAudioPlayer(contentsOf: audioURL)
                    self.audioPlayer1?.numberOfLoops = 0
                    self.audioPlayer1?.play()
                } else {
                    try self.audioPlayer2 = AVAudioPlayer(contentsOf: audioURL)
                    self.audioPlayer2?.numberOfLoops = 0
                    self.audioPlayer2?.play()
                }
                
            } catch {
                print("Something went wrong...")
            }
        }
    }
    
    public var body: some View {
        ScrollView {
            HStack {
                Spacer()
                
                VStack {

                    // Title + Info
                    Group {
                        Text("Polymeters")
                            .font(.system(size: 56).weight(.black))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text("A polymeter is two patterns that have different numbers of beats, but the length of each beat is the same, thus making each pattern a different length in total. For example, a pattern that lasts 5 beats with a pattern that lasts 4 beats would take 20 beats to line up on the first beat again (20 is the least common multiple of 5 and 4)! \n\n Click \"Go\" to see what it sounds like, and change the settings and select the tiles below to experiment with other polymeters and patterns!")
                            .font(.system(size: 20).weight(.semibold))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                            .frame(width: 600)
                    }
                    
                    // Settings
                    VStack {
                        Text("BPM")
                            .foregroundColor(.white)
                            .font(.system(size: 20).weight(.bold))
                        
                        HStack {
                            Slider(
                                value: $bpm,
                                in: 120...240,
                                step: 1
                            ) {
                                Text("BPM")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            } minimumValueLabel: {
                                Text("120")
                                    .foregroundColor(.white)
                            } maximumValueLabel: {
                                Text("240")
                                    .foregroundColor(.white)
                            } onEditingChanged: { editing in
                                self.stopPlaying()
                            }
                            .frame(width: 200)
                        }
                        
                        Text("Length of Patterns")
                            .foregroundColor(.white)
                            .font(.system(size: 20).weight(.bold))
                        
                        HStack {
                            Slider(
                                value: $length1,
                                in: 1...8,
                                step: 1
                            ) {
                                Text("Beats")
                            } minimumValueLabel: {
                                Text("1")
                                    .foregroundColor(.white)
                            } maximumValueLabel: {
                                Text("8")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200)
                        }
                        HStack {
                            Slider(
                                value: $length2,
                                in: 1...8,
                                step: 1
                            ) {
                                Text("Beats")
                                    .foregroundColor(.white)
                            } minimumValueLabel: {
                                Text("1")
                                    .foregroundColor(.white)
                            } maximumValueLabel: {
                                Text("8")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200)
                        }
                    }.padding(.bottom, 10)
                    
                    HStack(alignment: .top) {
                        Text(String(Int(length1)))
                            .frame(width: 30, height: 40)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                        Text(":")
                            .frame(width: 10, height: 40)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(String(Int(length2)))
                            .frame(width: 30, height: 40)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                    }.padding(.bottom, 20)
                    
                    // Visuals
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(1...Int(length1), id: \.self) { i in
                                Button {
                                    if (!line1array.contains(i)) {
                                        line1array.append(i)
                                    } else if (line1array.contains(i)) {
                                        line1array.remove(at: line1array.firstIndex(of: i)!)
                                    }
                                } label: {
                                    Text("\(i)")
                                        .foregroundColor(.white)
                                        .padding(24)
                                }
                                .contentShape(Rectangle())
                                .frame(width: 60, height: 60)
                                .background(.red.opacity(self.line1index == i ? line1array.contains(i) ? 1 : 0.7 : line1array.contains(i) ? 0.4 : 0.1))
                                .cornerRadius(6)
                            }
                        }
                        
                        HStack {
                            ForEach(1...Int(length2), id: \.self) { i in
                                Button {
                                    if (!line2array.contains(i)) {
                                        line2array.append(i)
                                    } else if (line2array.contains(i)) {
                                        line2array.remove(at: line2array.firstIndex(of: i)!)
                                    }
                                } label: {
                                    Text("\(i)")
                                        .foregroundColor(.white)
                                        .padding(24)
                                }
                                .contentShape(Rectangle())
                                .frame(width: 60, height: 60)
                                .background(.blue.opacity(self.line2index == i ? line2array.contains(i) ? 1 : 0.7 : line2array.contains(i) ? 0.4 : 0.1))
                                .cornerRadius(6)
                            }
                        }
                    }.padding(.bottom, 20)
                    
                    Text("Tap the tiles above to add or remove beats from the pattern.")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        self.isPlaying ? self.stopPlaying() : self.startPlaying()
                        
                    }) {
                        Text(isPlaying ? "Stop" : "Go")
                            .font(.system(size: 24).weight(.bold))
                            .frame(width: 125, height: 50)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.25))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white.opacity(0.4), lineWidth: 4)
                            )
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 52)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        // Uses 2 backgrounds: one as the gradient with opacity, black as the base
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.15), .indigo.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .background(.black)
        .onDisappear {
            // When navigating away from the page
            timer?.invalidate()
        }
    }
}
