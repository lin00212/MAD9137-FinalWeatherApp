import SwiftUI

struct SettingsView: View {
    @AppStorage("refreshInterval") private var refreshInterval: RefreshInterval = .fifteenMinutes
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    @EnvironmentObject var networkManager: NetworkManager
    
    enum RefreshInterval: String, CaseIterable, Identifiable {
        case fiveMinutes = "5 mins"
        case tenMinutes = "10 mins"
        case fifteenMinutes = "15 mins"
        case thirtyMinutes = "30 mins"
        case sixtyMinutes = "60 mins"
        
        var id: String { self.rawValue }
        
        var timeInterval: TimeInterval {
            switch self {
            case .fiveMinutes: return 5 * 60
            case .tenMinutes: return 10 * 60
            case .fifteenMinutes: return 15 * 60
            case .thirtyMinutes: return 30 * 60
            case .sixtyMinutes: return 60 * 60
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()

                VStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                    
                    Picker("Time Refresh Interval", selection: $refreshInterval) {
                        ForEach(RefreshInterval.allCases) { interval in
                            Text(interval.rawValue).tag(interval)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background(Color(UIColor.white).opacity(0.3))
                    .cornerRadius(15)
                    .listRowBackground(Color.clear)
                    .padding()
                    .onChange(of: refreshInterval) {
                        networkManager.startPeriodicUpdates()
                    }

                    VStack {
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                Text("About the App")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding()
                        }
                    }
                    .background(Color(UIColor.white).opacity(0.3))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .listRowBackground(Color.clear)
                    .padding(.vertical)
                    
                    VStack {
                        HStack {
                            Text("Dark Mode")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Spacer()
                            Toggle(isOn: $isDarkModeEnabled) {
                            }
                            .padding()
                        }
                        
                    }
                    .background(Color(UIColor.white).opacity(0.3))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .listRowBackground(Color.clear)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .clear, titleColor: .clear)
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
