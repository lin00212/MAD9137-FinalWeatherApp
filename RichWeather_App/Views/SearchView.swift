//
//  SearchCityView.swift
//  RichWeather_App
//
//  Created by Eason Lin on 12/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [City] = []
    @EnvironmentObject var networkManager: NetworkManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                TextField("Search for a city", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6).opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                    .onChange(of: searchText) {
                        if !searchText.isEmpty {
                            Task {
                                await performSearch(for: searchText)
                            }
                        } else {
                            searchResults = []
                        }
                    }

                List {
                    ForEach(searchResults) { city in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.headline)
                                Text(city.weatherCondition)
                                    .font(.caption)
                            }
                            Spacer()
                            Button(action: {
                                Task {
                                    await addCityToList(city: city) // Add 'city:' label
                                }
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)

                Spacer()
            }
            .padding(.top, 20)
        }
    }

    func performSearch(for cityName: String) async {
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName)&appid=\(networkManager.apiKey)&units=metric") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                await MainActor.run {
                    self.searchResults = [] // Clear results on invalid response
                }
                return
            }

            let decodedResponse = try JSONDecoder().decode(WeatherData.self, from: data)
            let city = City(name: decodedResponse.name,
                            temperature: Int(decodedResponse.main.temp),
                            date: Utility.getCurrentTime(timezoneOffset: decodedResponse.timezone),
                            weatherCondition: decodedResponse.weather[0].description,
                            weatherIcon: Utility.getIconName(for: decodedResponse.weather[0].icon),
                            timezone: decodedResponse.timezone)

            await MainActor.run {
                self.searchResults = [city] // Update search results
            }
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
            await MainActor.run {
                self.searchResults = [] // Clear results on error
            }
        }
    }

    func addCityToList(city: City) async {
        await networkManager.fetchWeatherForCity(cityName: city.name)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    SearchView()
}
