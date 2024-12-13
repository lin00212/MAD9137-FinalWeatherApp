import SwiftUI
import MapKit

struct CityWeatherDetailView: View {
    var city: City
    
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
                                Text(String(format: "%.1f m/s", windSpeed))
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
                                Text("\(humidity)%")
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
                    
                    // Forecast Box
                    if let forecast = city.hourlyForecast {
                        VStack(alignment: .leading) {
                            Text("Hourly Forecast")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(forecast) { hour in
                                        VStack {
                                            Text(hour.time)
                                                .font(.subheadline)
                                            Image(systemName: hour.weatherIcon)
                                                .font(.title3)
                                                .foregroundColor(.yellow)
                                            Text(hour.temperatureCelsius)
                                                .font(.subheadline)
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 15)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(20)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 35)
                    } else {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Loading Forecast...")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
}

struct CityWeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleForecast = [
            HourlyForecast(
                dt: 1734046800,
                main: HourlyForecast.MainData(temp: 15.0),
                weather: [HourlyForecast.WeatherInfo(description: "Clear sky", icon: "01d")]
            ),
            HourlyForecast(
                dt: 1734050400,
                main: HourlyForecast.MainData(temp: 14.0),
                weather: [HourlyForecast.WeatherInfo(description: "Few clouds", icon: "02d")]
            ),
            HourlyForecast(
                dt: 1734054000,
                main: HourlyForecast.MainData(temp: 13.0),
                weather: [HourlyForecast.WeatherInfo(description: "Scattered clouds", icon: "03d")]
            )
        ]
        
        let sampleCity = City(
            id: UUID(),
            name: "Sample City",
            temperature: 15,
            date: "3 PM",
            weatherCondition: "Clear sky",
            weatherIcon: "sun.max.fill",
            timezone: 0,
            windSpeed: 5.0,
            humidity: 60,
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            hourlyForecast: sampleForecast
        )
        
        CityWeatherDetailView(city: sampleCity)
    }
}
