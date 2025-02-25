import SwiftUI

struct ContentView: View {
    @Environment(RacingViewModel.self) var racingViewModel: RacingViewModel
    @ScaledMetric var imageSize = 36.0
    @ScaledMetric var filterImageSize = 24.0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                filters
                
                racingList
            }
            .padding(16)
            .task {
                await racingViewModel.startStreamingRaces()
            }
        }
        .navigationTitle(Text("Next To Go Racing"))
    }
    
    private var filters: some View {
        HStack {
            Button {
                Task {
                  await racingViewModel.updateSearch(cat: nil) // nil represents "All"
                }
            } label: {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: racingViewModel.searchTokens.isEmpty ? "checkmark.square.fill" : "square")
                            .foregroundColor(racingViewModel.searchTokens.isEmpty ? .blue : .gray)
                        Text("All")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(racingViewModel.searchTokens.isEmpty)
            .accessibilityLabel("Filter all races")
            
            // Individual category filters
            ForEach(RaceCategory.allCases) { cat in
                Button {
                    Task {
                      await racingViewModel.updateSearch(cat: cat)
                    }
                } label: {
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            Image(systemName: racingViewModel.searchTokens.contains(cat) ? "checkmark.square.fill" : "square")
                                .foregroundColor(racingViewModel.searchTokens.contains(cat) ? .blue : .gray)
                            VStack(spacing: 1) {
                                Image(cat.iconName)
                                    .resizable()
                                    .frame(width: filterImageSize, height: filterImageSize)
                                    .accessibilityLabel(Text(cat.name))
                                Text(cat.name)
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Filter races for \(cat.name)")
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var racingList: some View {
        ForEach(racingViewModel.nextToGoRaceSummaries, id: \.id) { raceSummary in
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if let imageName = raceSummary.raceCategory?.iconName {
                        Image(imageName)
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                    }
                    VStack(alignment: .leading) {
                        let raceDetails = raceSummary.meetingName + " " + String(raceSummary.raceNumber)
                        
                        Text(raceDetails)
                            .lineLimit(1)
                        Text("\(raceSummary.advertisedStart.isPassedStartTime ? "-" : "")") + Text(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)
                            .font(.footnote)
                            .foregroundColor(raceSummary.advertisedStart.isPassedStartTime ? .red : .secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel(Text("\(raceSummary.meetingName)"))
            }
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        ContentView()
    }
}
