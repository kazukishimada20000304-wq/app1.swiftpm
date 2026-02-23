import SwiftUI

struct EventDetailView: View {
    @Environment(EventStore.self) private var store
    let event: BabyEvent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let fileName = event.imageFileName,
                   let uiImage = store.loadImage(fileName: fileName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(radius: 4, y: 2)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Label(
                        event.date.formatted(date: .long, time: .omitted),
                        systemImage: "calendar"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    if let age = store.ageString(at: event.date) {
                        Label(age, systemImage: "figure.child")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.pink)
                    }

                    if !event.comment.isEmpty {
                        Divider()
                        Text(event.comment)
                            .font(.body)
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding()
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.large)
    }
}
