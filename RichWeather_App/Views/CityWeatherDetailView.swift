import SwiftUI
import MapKit
import CoreLocation // Import CoreLocation

struct CityWeatherDetailView: View {
    var city: City
    
    // Computed property to determine gradient based on temperature
    var backgroundGradient: LinearGradient {
        switch city.temperature {
        case ..<10:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3),
                    Color.blue.opacity(1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case 10..<25:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.3),
                    Color.green.opacity(1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.3),
                    Color.red.opacity(1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var body: some View {
        ZStack {
            // Map as the background
            if let coordinate = city.coordinate {
                MapView(coordinate: coordinate)
                    .ignoresSafeArea()
            } else {
                // Placeholder or error handling if coordinates are not available
                Color.gray // You can use a different placeholder or error view
            }
            
            // Gradient color layer based on temperature
            backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text(city.name)
                        .font(.system(size: 45, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top, 15)
                    
                    Text("\(city.temperature)°C")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundColor(.white)
                    
                    Text(city.date)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 80)
                    
                    HStack(spacing: 60) {
                        // Wind Box
                        VStack {
                            Image(systemName: "wind")
                                .font(.title2)
                            Text("Wind")
                                .font(.headline)
                            if let windSpeed = city.windSpeed {
                                Text("$$windSpeed) m/s")
                                    .font(.subheadline)
                            } else {
                                Text("N/A")
                                    .font(.subheadline)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                        
                        // Humidity Box
                        VStack {
                            Image(systemName: "humidity.fill")
                                .font(.title2)
                            Text("Humidity")
                                .font(.headline)
                            if let humidity = city.humidity {
                                Text("$$humidity)%")
                                    .font(.subheadline)
                            } else {
                                Text("N/A")
                                    .font(.subheadline)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                    }
                    .padding(.vertical, 25)
                    
                    // Forecast Box (Placeholder for now)
                    VStack(alignment: .leading) {
                        Text("Forecast")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 5)
                        
                        // Placeholder for forecast data (replace with actual data later)
                        HStack(spacing: 20) {
                            ForEach(0..<4) { _ in
                                VStack {
                                    Text("00:00")
                                        .font(.subheadline)
                                    Image(systemName: "cloud.sun")
                                        .font(.title3)
                                    Text("-99°C")
                                        .font(.subheadline)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(20)
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 35)
                }
            }
        }
    }
}

#Preview{
    CityListView()
}
