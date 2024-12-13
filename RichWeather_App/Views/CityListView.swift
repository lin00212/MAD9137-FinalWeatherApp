import SwiftUI

struct CityListView: View {
    @StateObject private var networkManager = NetworkManager()
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false

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
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                        Text(city.name)
                                            .foregroundColor(.white)
                                        Text(city.date)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    Image(systemName: city.weatherIcon)
                                        .font(.title2)
                                        .foregroundColor(.yellow)
                                    Text(city.weatherCondition)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemBlue).opacity(0.1))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: networkManager.deleteCity)
                        .onMove(perform: networkManager.moveCity)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(.plain)
                    .navigationBarItems(leading: EditButton(), trailing:
                        NavigationLink(destination: SearchView().environmentObject(networkManager)) {
                            Image(systemName: "magnifyingglass")
                        }
                    )
                    Spacer()
                }
                .padding(.top, 20)
            }
        }
    }


}


#Preview {
    ContentView()
}

