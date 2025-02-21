import SwiftUI

struct MeditationView: View {
    @State private var isBreathing = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Meditation")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.purple)
                    .shadow(color: .purple.opacity(0.2), radius: 5, x: 0, y: 5)
                
                Spacer()
                
                // Animated Breathing Circle
                ZStack {
                    // Outer Glow
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 20)
                        .scaleEffect(isBreathing ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isBreathing)
                    
                    // Outer Circle
                    Circle()
                        .stroke(Color.purple.opacity(0.3), lineWidth: 20)
                        .frame(width: 250, height: 250)
                        .scaleEffect(isBreathing ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isBreathing)
                    
                    // Inner Circle
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 200, height: 200)
                        .scaleEffect(isBreathing ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isBreathing)
                        .shadow(color: .purple.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    // Inner Glow
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 5)
                        .frame(width: 180, height: 180)
                        .scaleEffect(isBreathing ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isBreathing)
                }
                .onAppear {
                    // Ensure state mutation happens on the main thread
                    DispatchQueue.main.async {
                        isBreathing.toggle()
                    }
                }
                
                Spacer()
                
                // Breathing Instructions
                Text("Focus on your breath. Inhale deeply, exhale slowly.")
                    .font(.subheadline)
                    .foregroundColor(.purple.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView()
    }
}
