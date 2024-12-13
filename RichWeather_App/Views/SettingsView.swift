////
////  SettingsView.swift
////  RichWeather_App
////
////  Created by Eason Lin on 12/12/2024.
////
//
//import SwiftUI
//
//struct SettingsView: View {
//    @ObservedObject var viewModel = SettingsViewModel()
//
//    var body: some View {
//        Form {
//            Section(header: Text("Appearance")) {
//                Toggle(isOn: $viewModel.isDarkMode) {
//                    Text("Dark Mode")
//                        .font(.subheadline)
//                }
//            }
//            Section(header: Text("Data Refresh")) {
//                Picker("Refresh Interval", selection: $viewModel.refreshInterval) {
//                    ForEach(viewModel.timeIntervals, id: \.self) { interval in
//                        Text("$$interval) minutes").tag(interval)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
//            Section(header: Text("About")) {
//                Button("About") {
//                    // Present About screen
//                }
//            }
//        }
//        .navigationBarTitle("Settings")
//    }
//}
//
//#Preview {
//    SettingsView()
//}


import SwiftUI

struct SettingsView: View {
    @State private var refreshInterval: RefreshInterval = .fifteenMinutes // Default interval
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    @Environment(\.colorScheme) var currentColorScheme // To determine if dark mode is already enabled from system settings
    
    enum RefreshInterval: String, CaseIterable, Identifiable { // Enum for the refresh intervals
        case fiveMinutes = "5 mins"
        case tenMinutes = "10 mins"
        case fifteenMinutes = "15 mins"
        case thirtyMinutes = "30 mins"
        
        var id: String { self.rawValue } // RawValue works as an id
    }


    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()

                // Settings Content
                VStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white) // Or any other color
                        .padding()
                    
                    //Refresh interval picker
                    Picker("Time Refresh Interval", selection: $refreshInterval) {
                        ForEach(RefreshInterval.allCases) { interval in
                            Text(interval.rawValue).tag(interval) //Display interval string in the picker
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()


                    // About Section
                    VStack {
                        NavigationLink(destination: AboutView()) { // Create about us view
                            HStack {
                                Text("About the App")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding()
                        }
                    }.background(.black)
                    
                    
                    // Dark Mode Toggle
                    VStack {
                        HStack {
                            Text("Dark Mode")
                                .foregroundColor(.white)
                            Spacer()
                            Toggle(isOn: $isDarkModeEnabled){  // Directly bind to @AppStorage
                            }
                            .padding()
                        }
                    }
                    .background(Color.black) // Or your preferred background
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .clear, titleColor: .yellow) //Example colour
        } //End of NavigationView
    }

    

}


struct AboutView: View {
    var body: some View {
        VStack { // Example content
            Text("About View") // Replace with your actual about page

        }
        .navigationTitle("About the App") // Set the navigation title

    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
