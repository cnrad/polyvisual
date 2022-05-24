import SwiftUI
import AVFoundation

public struct MenuPage: View {
        
    @State var selectedSound: String = "Click"
    let soundList = ["Click", "Drums 1", "Drums 2"]
    
    public var body: some View {
        ZStack {
            VStack {
                // Title
                Text("Polyvisual")
                    .font(.system(size: 56).weight(.black))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                    .shadow(color: .white.opacity(0.5), radius: 7)
                
                // Description
                Text("A simple program to help users understand complex rhythmic concepts through interactive visuals and sounds.")
                    .font(.system(size: 30).weight(.semibold))
                    .lineSpacing(6)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
        
                // Navigation Buttons
                VStack {
                    NavigationLink(destination: Polyrhythm()) {
                        Text("Learn about Polyrhythms")
                            .font(.system(size: 24).weight(.semibold))
                            .frame(width: 400, height: 60)
                            .padding(12)
                            .background(.black.opacity(0.6))
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.blue.opacity(0.5), lineWidth: 4)
                            )
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.2), radius: 7)
                            .padding(.bottom, 16)
                    }
                    
                    NavigationLink(destination: Polymeter()) {
                        Text("Learn about Polymeters")
                            .font(.system(size: 24).weight(.semibold))
                            .frame(width: 400, height: 60)
                            .padding(12)
                            .background(.black.opacity(0.6))
                            .foregroundColor(.purple)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.purple.opacity(0.5), lineWidth: 4)
                            )
                            .cornerRadius(12)
                            .shadow(color: .purple.opacity(0.2), radius: 7)
                            .padding(.bottom, 16)
                    }
                }.padding(.bottom, 24)
                
                // Sound picker
                Menu {
                    Picker(
                        selection: $selectedSound,
                        label: EmptyView(),
                        content: {
                            ForEach(soundList, id: \.self) {
                                Text($0)
                            }
                        }
                    )
                    .pickerStyle(InlinePickerStyle())
                } label: {
                    VStack(spacing: 0) {
                        Text("Change Sound")
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.bottom, 4)
    
                        Text("\(selectedSound)")
                            .foregroundColor(.indigo)
                            .font(.system(size: 24).weight(.bold))
                    }
                    .foregroundColor(.white)
                    .padding([.bottom, .top], 16)
                    .padding([.leading, .trailing], 52)
                    .background(.black.opacity(0.4))
                    .cornerRadius(12)
                }
                .preferredColorScheme(.dark)
                .onChange (of: selectedSound) { newSound in
                    Sounds.currentSound = newSound
                }
                
            }
            .frame(width: 700)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.2), .purple.opacity(0.15)]), startPoint: .topTrailing, endPoint: .bottomLeading)
        )
        .background(.black)
        .navigationBarBackButtonHidden(true)
    }
}
