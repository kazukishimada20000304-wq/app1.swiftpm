import SwiftUI

struct EventRowView: View {
    @Environment(EventStore.self) private var store
    let event: BabyEvent

    var body: some View {
        HStack(spacing: 14) {
            thumbnailView
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(event.date.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if !event.comment.isEmpty {
                    Text(event.comment)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let fileName = event.imageFileName,
           let uiImage = store.loadImage(fileName: fileName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.pink.opacity(0.12))
                .overlay {
                    Image(systemName: "photo")
                        .foregroundStyle(.pink.opacity(0.5))
                }
        }
    }
}
