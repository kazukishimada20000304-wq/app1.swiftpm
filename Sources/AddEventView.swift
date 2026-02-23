import SwiftUI
import PhotosUI

struct AddEventView: View {
    @Environment(EventStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var date = Date()
    @State private var comment = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedUIImage: UIImage?

    var body: some View {
        NavigationStack {
            Form {
                Section("イベント情報") {
                    TextField("タイトル（例：初めての笑顔）", text: $title)
                    DatePicker("日付", selection: $date, displayedComponents: .date)
                }

                Section("写真") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let image = selectedUIImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(maxWidth: .infinity)
                        } else {
                            Label("写真を選択", systemImage: "photo.badge.plus")
                                .frame(maxWidth: .infinity, minHeight: 60)
                        }
                    }
                }

                Section("コメント") {
                    TextField("コメントを入力", text: $comment, axis: .vertical)
                        .lineLimit(4...)
                }
            }
            .navigationTitle("新規イベント")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .fontWeight(.semibold)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        selectedUIImage = UIImage(data: data)
                    }
                }
            }
        }
    }

    private func save() {
        var imageFileName: String?
        if let data = selectedImageData {
            imageFileName = store.saveImage(data)
        }
        let event = BabyEvent(
            title: title.trimmingCharacters(in: .whitespaces),
            date: date,
            comment: comment,
            imageFileName: imageFileName
        )
        store.add(event)
        dismiss()
    }
}
