import SwiftUI

struct AngerLog: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var reason: String
}

class AngerLogViewModel: ObservableObject {
    @Published var angerLogs: [AngerLog] = [] {
        didSet { saveLogs() }
    }
    @Published var angerCount: Int = UserDefaults.standard.integer(forKey: "angerCount")

    init() {
        loadLogs()
    }

    func addAngerLog(reason: String) {
        let newLog = AngerLog(date: Date(), reason: reason)
        angerLogs.append(newLog)
        angerCount += 1
        UserDefaults.standard.set(angerCount, forKey: "angerCount")
        saveLogs()
    }

    private func saveLogs() {
        if let encoded = try? JSONEncoder().encode(angerLogs) {
            UserDefaults.standard.set(encoded, forKey: "angerLogs")
        }
    }

    private func loadLogs() {
        if let savedData = UserDefaults.standard.data(forKey: "angerLogs"),
           let decoded = try? JSONDecoder().decode([AngerLog].self, from: savedData) {
            self.angerLogs = decoded
        }
    }
}

struct HomeView: View {
    @StateObject private var viewModel = AngerLogViewModel()
    @State private var newReason = ""
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView { // ✅ Wrap in ScrollView
                VStack(spacing: 20) {
                    // Progress Circle
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.purple.opacity(0.2), lineWidth: 15)
                                .frame(width: 150, height: 150)
                            
                            Circle()
                                .trim(from: 0.0, to: min(CGFloat(viewModel.angerCount) / 10, 1.0))
                                .stroke(
                                    AngularGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.pink]),
                                        center: .center,
                                        startAngle: .degrees(-90),
                                        endAngle: .degrees(270)
                                    ),
                                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 150, height: 150)
                                .animation(.easeInOut(duration: 0.5), value: viewModel.angerCount)
                            
                            Text("\(viewModel.angerCount)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.purple)
                        }
                        Text("Anger Count")
                            .font(.headline)
                            .foregroundColor(.purple.opacity(0.7))
                    }
                    .padding(.top, 30)

                    // TextField for new log entry
                    TextField("Why did you get angry?", text: $newReason)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .foregroundColor(.purple)
                        .font(.system(size: 18, weight: .medium))
                        .autocapitalization(.sentences)


                    // Log Anger Button
                    Button(action: {
                        if !newReason.isEmpty {
                            withAnimation(.spring()) {
                                viewModel.addAngerLog(reason: newReason)
                                newReason = ""
                            }
                        }
                    }) {
                        Text("Log Anger")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.purple.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)

                    // Display Anger Logs
                    VStack(spacing: 10) {
                        ForEach(viewModel.angerLogs.reversed()) { log in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(log.reason)
                                        .font(.headline)
                                        .foregroundColor(.purple)

                                    Text(formatDate(log.date))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(radius: 2)
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20) // ✅ Extra padding at bottom
                }
                .padding(.vertical)
            }
        }
    }
}

                    // Function to format the date
                    private func formatDate(_ date: Date) -> String {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMMM yyyy"
                        return formatter.string(from: date)
                    }
                



struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Tracker", systemImage: "chart.bar.fill")
                }

            MeditationView()
                .tabItem {
                    Label("Meditation", systemImage: "leaf.fill")
                }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

