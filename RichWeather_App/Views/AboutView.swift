//
//  AboutView.swift
//  RichWeather_App
//
//  Created by Eason Lin on 13/12/2024.
//

import SwiftUI

struct AboutView: View {
    @State private var tapCount = 0
    @State private var showingSecretImage = false
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("About")
                    .font(.title)
                    .bold()
                    .padding()
                
                // App Name and Version
                Text("Rich Weather")
                    .font(.title)
                    .bold()
                Text("Version 1.0.0")
                    .foregroundColor(.gray)
                
                // App Description
                Text("This is a final project of MAD9037, a rich and nice weather app created by Eason Lin!")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Developer Section
                VStack {
                    Text("Design and Develop by")
                        .font(.headline)
                        .padding(.top)
                    
                    // Developer photo that can be tapped
                    Image(showingSecretImage ? "developer_photo_2" : "developer_photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .onTapGesture {
                            tapCount += 1
                            if tapCount == 3 {
                                withAnimation {
                                    showingSecretImage.toggle()
                                }
                                tapCount = 0
                            }
                        }
                    
                    Text("Eason Lin")
                        .font(.title2)
                        .padding(.top, 5)
                    
                    Text("Software Developer")
                        .foregroundColor(.gray)
                }
                
                // Features Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Key Features:")
                        .font(.headline)
                        .padding(.top)
                    
                    FeatureRow(icon: "location.fill", text: "Real-time weather updates")
                    FeatureRow(icon: "clock.fill", text: "Hourly forecasts")
                    FeatureRow(icon: "map.fill", text: "Interactive weather maps")
                }
                .padding(.horizontal)
                
                // Contact Section
                VStack {
                    Text("Contact")
                        .font(.headline)
                        .padding(.top)
                    
                    Link("E-mail: lin00212@algonquinlive.com",
                         destination: URL(string: "lin00212@algonquinlive.com")!)
                    
                    Link("GitHub: github.com/lin00212",
                         destination: URL(string: "https://github.com/lin00212")!)
                }
                
            }
        }
//        .navigationTitle("About")
    }
}

// Helper view for feature rows
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
