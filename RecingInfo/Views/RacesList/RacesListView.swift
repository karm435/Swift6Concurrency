import SwiftUI

struct RacesListView: View {
    @State private var racingViewModel: RacingViewModel = .init()
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
        .navigationTitle("Next To Go Racing")
    }
    
    private var filters: some View {
        HStack {
            Button {
                Task {
                    await racingViewModel.filterRacesFor(nil)
                }
            } label: {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: racingViewModel.searchTokens.isEmpty ? "checkmark.square.fill" : "square")
                            .foregroundColor(racingViewModel.searchTokens.isEmpty ? .blue : .gray)
                            .accessibilityHidden(true)
                        Text("All")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(racingViewModel.searchTokens.isEmpty)
            .accessibilityLabel("All races")
            .accessibilityValue(racingViewModel.searchTokens.isEmpty ? "Selected" : "Not selected")
            .accessibilityAddTraits(.isButton)
            
            // Individual category filters
            ForEach(RaceCategory.allCases) { cat in
                Button {
                    Task {
                        await racingViewModel.filterRacesFor(cat)
                    }
                } label: {
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            Image(systemName: racingViewModel.searchTokens.contains(cat) ? "checkmark.square.fill" : "square")
                                .foregroundColor(racingViewModel.searchTokens.contains(cat) ? .blue : .gray)
                                .accessibilityHidden(true)
                            VStack(spacing: 1) {
                                Image(cat.iconName)
                                    .resizable()
                                    .frame(width: filterImageSize, height: filterImageSize)
                                    .accessibilityHidden(true)
                                Text(cat.name)
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("\(cat.name) races")
                .accessibilityValue(racingViewModel.searchTokens.contains(cat) ? "Selected" : "Not selected")
                .accessibilityAddTraits(.isButton)
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
                            .accessibilityHidden(true)
                    }
                    VStack(alignment: .leading) {
                        let raceDetails = raceSummary.meetingName + " Race " + String(raceSummary.raceNumber)
                        
                        Text(raceDetails)
                            .lineLimit(1)
                        Text("\(raceSummary.advertisedStart.isPassedStartTime ? "-" : "")") + Text(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)
                            .font(.footnote)
                            .foregroundColor(raceSummary.advertisedStart.isPassedStartTime ? .red : .secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(raceSummary.meetingName) Race \(raceSummary.raceNumber)")
                .accessibilityValue(raceSummary.advertisedStart.isPassedStartTime ? 
                    "Started \(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)" :
                    "Starting in \(Date(timeIntervalSince1970: TimeInterval(raceSummary.advertisedStart.seconds)), style: .relative)")
            }
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        RacesListView()
    }
}
