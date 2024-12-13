
import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            CityListView()
                .tabItem {
                    Label("Cities", systemImage: "list.dash")
                }
                .tag(0)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
        }
//        .modelContainer(for: City.self) // Add modelContainer here
    }
}
