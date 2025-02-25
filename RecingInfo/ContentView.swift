import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            RacesListView()
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        ContentView()
    }
}
