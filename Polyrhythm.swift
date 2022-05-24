import SwiftUI
import AVFoundation

public struct Polyrhythm: View {
    
    // Define audio player stuff
    let engine = AVAudioEngine()
    @State var audioPlayer1: AVAudioPlayer?
    @State var audioPlayer2: AVAudioPlayer?
    
    // Main states
    @State var duration: Double = 3.0
    @State var rotationAngle = 0.0
    @State var isPlaying = false
    
    // Declare beat count and currentBeat counts
    @State var beats1: String = "4"
    @State var beats2: String = "3"
    @State var currentBeat1: Int = 1
    @State var currentBeat2: Int = 1
    
    // Declare timer states
    @State var timer1: Timer?
    @State var timer2: Timer?
    @State var rotationTimer: Timer?
    
    @State var rememberTip: String = "No phrase"
    
    public func playTick(type: Int) {
        // Play the click basically
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
                // Catch for handling in case (shouldn't ever crash to begin with)
                print("Something went wrong...")
            }
        }
    }
    
    public func startPlaying(){
        // Validate inputs, don't allow above 40 for performance reasons
        if(Double(self.beats1) ?? 1.0 > 40.0) {
            self.beats1 = "40";
        }
        if(Double(self.beats1) ?? 1.0 > 40.0) {
            self.beats2 = "40";
        }
        
        // Change beat count to Double type
        let b1: Double = Double(self.beats1) ?? 1.0
        let b2: Double = Double(self.beats2) ?? 1.0
        
        // Invalidate any possible previous timer instances
        timer1?.invalidate()
        timer2?.invalidate()
        rotationTimer?.invalidate()
        
        // Start playing
        self.isPlaying = true
        
        // First event
        rotationAngle += 30
        playTick(type: 1)
        playTick(type: 2)
        
        // Timer events after initial interval
        rotationTimer = Timer.scheduledTimer(withTimeInterval: (5 - duration + 1) / 12, repeats: true) { (_) in
            rotationAngle += 30
        }
        
        timer1 = Timer.scheduledTimer(withTimeInterval: (5 - duration + 1) / b1, repeats: true) { (_) in
            // Play Click1 and increase beat by 1
            playTick(type: 1)
            
            if (currentBeat1 < Int(beats1) ?? 1 ) {
                currentBeat1 += 1
            } else {
                currentBeat1 = 1
            }
        }
        
        timer2 = Timer.scheduledTimer(withTimeInterval: (5 - duration + 1) / b2, repeats: true) { (_) in
            // Play Click2 and increase beat by 1
            playTick(type: 2)
            
            if (currentBeat2 < Int(beats2) ?? 1) {
                currentBeat2 += 1
            } else {
                currentBeat2 = 1
            }
        }
    }
    
    public func stopPlaying() {
        // Stop animation
        self.isPlaying = false
        
        // Stop all timers, reset variables to initial state
        timer1?.invalidate()
        timer2?.invalidate()
        rotationTimer?.invalidate()
        currentBeat1 = 1
        currentBeat2 = 1
        rotationAngle = 0.0
    }
    
    // Display a mnemonic for certain polyrhythms if possible
    public func checkMnemonic() {
        let input1: String = self.beats1;
        let input2: String = self.beats2;
        
        switch(input1, input2) {
            case("3", "4"),("4", "3"):
                rememberTip = "\"Pass - the - bread - and - but-ter\""
            case("4", "5"),("5", "4"):
                rememberTip = "\"I'm - look-ing - for - a - home - to - buy\""
            case("3", "2"),("2", "3"):
                rememberTip = "\"Not - diff-i-cult\""
            case("5", "3"),("3", "5"):
                rememberTip = "\"I - am - eat-ing - but-ter - now\""
            default:
                rememberTip = "No phrase"
        }
    }
    
    public var body: some View {
        ScrollView {
            HStack {
                Spacer()
                
                VStack {
                    
                    // Title + Info
                    Group {
                        Text("Polyrhythms")
                            .font(.system(size: 56).weight(.black))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text("A polyrhythm is a rhythm where there are actually *multiple* different rhythms playing at once. Usually, there are 2 rhythms with different numbers of beats that are perfectly evenly spaced, but they each take the same amount of total time to play. The first beat of a polyrhythm will always line up, and polyrhythms are denoted with a colon in between the numbers. \n\nA 4:3 *(four-to-three)* polyrhythm has 4 beats playing while 3 beats are playing, and both take up same total amount of time. Click \"Go\" to see what it sounds like, and change the settings below to experiment with other polyrhythms!")
                            .font(.system(size: 20).weight(.semibold))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                    }
                        .frame(width: 600)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Settings
                    VStack {
                        HStack {
                            Slider(
                                value: $duration,
                                in: 1...5,
                                step: 1
                            ) {
                                Text("Speed")
                            } minimumValueLabel: {
                                Text("Slow")
                                    .foregroundColor(.white)
                            } maximumValueLabel: {
                                Text("Fast")
                                    .foregroundColor(.white)
                            } onEditingChanged: { editing in
                                self.stopPlaying()
                            }
                            .frame(width: 300)
                        }.padding(.bottom, 15)
                        
                        HStack(alignment: .top) {
                            TextField("", text: $beats1)
                                .frame(width: 60, height: 40)
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                                .foregroundColor(.blue)
                                .background(.white)
                                .cornerRadius(10)
                                .onChange(of: beats1) { _ in
                                    self.stopPlaying()
                                }
                            Text(":")
                                .frame(width: 15, height: 40)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            TextField("", text: $beats2)
                                .frame(width: 60, height: 40)
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .keyboardType(.decimalPad)
                                .foregroundColor(.blue)
                                .background(.white)
                                .cornerRadius(10)
                                .onChange(of: beats2) { _ in
                                    self.stopPlaying()
                                }
                        }.padding(.bottom, 15)
                        
                        Button(action: {
                            self.isPlaying ? self.stopPlaying() : self.startPlaying()
                            self.checkMnemonic()
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
                            
                        }.onAppear {
                            self.checkMnemonic()
                        }
                    
                    }.padding(.bottom, 50)
                    
                    // Visuals
                    HStack(alignment: .center) {
                        Text("\(currentBeat1)")
                            .foregroundColor(.red)
                            .font(.system(size: 36).weight(.bold))
                            .frame(width: 50)
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 350, height: 350)
                                .foregroundColor(.white)
                                .shadow(color: .blue, radius: 5)
                            
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 5)
                                .offset(y: -175)
                                .rotationEffect(.degrees(rotationAngle))
                                .animation(Animation.linear(duration: isPlaying ? (5 - duration + 1) / 12 : 0), value: rotationAngle)
                            
                            Polygon(sides: Int(beats1) ?? 1, angle: 270)
                                .stroke(.red, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .frame(width: 350, height: 350)
                            
                            Polygon(sides: Int(beats2) ?? 1, angle: 270)
                                .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .frame(width: 350, height: 350)
                        }
                        
                        Spacer()
                        
                        Text("\(currentBeat2)")
                            .foregroundColor(.blue)
                            .font(.system(size: 36).weight(.bold))
                            .frame(width: 50)
                        
                    }
                    .padding(.bottom, 18)
                    .frame(width: 500)
                    
                    // Polyrhythm info
                    Group {
                        Text("\(beats1):\(beats2) polyrhythm")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text(rememberTip)
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .padding(.bottom, 52)
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        // Uses 2 backgrounds: one as the gradient with opacity, black as the base
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.15), .cyan.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .background(.black)
        .onDisappear {
            // When navigating away from the page
            timer1?.invalidate()
            timer2?.invalidate()
            rotationTimer?.invalidate()
        }
    }
}
