import SwiftUI

struct CityListView: View {
    @StateObject private var networkManager = NetworkManager()
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    @State private var isSearchViewPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Text("City List")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)

                    List {
                        ForEach(networkManager.cities) { city in
                            NavigationLink(destination: CityWeatherDetailView(city: city)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(city.temperature)°C")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                        Text(city.name)
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                        Text(city.date)
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Image(systemName: city.weatherIcon)
                                            .font(.largeTitle)
                                            .foregroundColor(getIconColor(for: city.weatherCondition))
                                            .padding()
                                        Text(city.weatherCondition.capitalized)
                                            .foregroundColor(.white)
                                            
                                    }
                                    
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemBlue).opacity(0.1))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: networkManager.deleteCity)
                        .onMove(perform: moveCity) // Changed this line
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(.plain)
                    .navigationBarItems(leading: EditButton(), trailing:
                        Button(action: {
                            isSearchViewPresented = true // Show SearchView modally
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    )
                    .sheet(isPresented: $isSearchViewPresented) {
                        SearchView(presentationMode: $isSearchViewPresented) // Pass the binding
                            .environmentObject(networkManager)
                    }
                    Spacer()
                }
                .padding(.top, 20)
            }
        }
    }
    
    func getIconColor(for weatherCondition: String) -> Color {
        switch weatherCondition.lowercased() {
        case "clear sky":
            return .yellow
        case "light rain", "moderate rain", "heavy intensity rain", "very heavy rain", "extreme rain", "freezing rain", "light intensity shower rain", "shower rain", "heavy intensity shower rain", "ragged shower rain":
            return .blue
        default:
            return .white // For clouds or other conditions
        }
    }
    
    private func moveCity(from source: IndexSet, to destination: Int) {
        networkManager.moveCity(from: source, to: destination)
    }
}

#Preview {
    ContentView()
}
