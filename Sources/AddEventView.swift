import SwiftUI
import PhotosUI

// MARK: - プリセットテンプレート

private struct EventTemplate: Identifiable {
    let id = UUID()
    let category: String
    let title: String
}

private let eventTemplates: [EventTemplate] = [
    // 定期接種ワクチン
    .init(category: "定期接種ワクチン", title: "ロタウイルス 1回目"),
    .init(category: "定期接種ワクチン", title: "ロタウイルス 2回目"),
    .init(category: "定期接種ワクチン", title: "ロタウイルス 3回目（5価）"),
    .init(category: "定期接種ワクチン", title: "B型肝炎 1回目"),
    .init(category: "定期接種ワクチン", title: "B型肝炎 2回目"),
    .init(category: "定期接種ワクチン", title: "B型肝炎 3回目"),
    .init(category: "定期接種ワクチン", title: "Hib（ヒブ）1回目"),
    .init(category: "定期接種ワクチン", title: "Hib（ヒブ）2回目"),
    .init(category: "定期接種ワクチン", title: "Hib（ヒブ）3回目"),
    .init(category: "定期接種ワクチン", title: "Hib（ヒブ）追加"),
    .init(category: "定期接種ワクチン", title: "小児用肺炎球菌 1回目"),
    .init(category: "定期接種ワクチン", title: "小児用肺炎球菌 2回目"),
    .init(category: "定期接種ワクチン", title: "小児用肺炎球菌 3回目"),
    .init(category: "定期接種ワクチン", title: "小児用肺炎球菌 追加"),
    .init(category: "定期接種ワクチン", title: "四種混合（DPT-IPV）1回目"),
    .init(category: "定期接種ワクチン", title: "四種混合（DPT-IPV）2回目"),
    .init(category: "定期接種ワクチン", title: "四種混合（DPT-IPV）3回目"),
    .init(category: "定期接種ワクチン", title: "四種混合（DPT-IPV）追加"),
    .init(category: "定期接種ワクチン", title: "BCG"),
    .init(category: "定期接種ワクチン", title: "MR（麻疹・風疹）第1期"),
    .init(category: "定期接種ワクチン", title: "MR（麻疹・風疹）第2期"),
    .init(category: "定期接種ワクチン", title: "水痘 1回目"),
    .init(category: "定期接種ワクチン", title: "水痘 2回目"),
    .init(category: "定期接種ワクチン", title: "日本脳炎 1回目"),
    .init(category: "定期接種ワクチン", title: "日本脳炎 2回目"),
    .init(category: "定期接種ワクチン", title: "日本脳炎 3回目"),
    .init(category: "定期接種ワクチン", title: "日本脳炎 4回目（追加）"),
    .init(category: "定期接種ワクチン", title: "HPV（子宮頸がん）1回目"),
    .init(category: "定期接種ワクチン", title: "HPV（子宮頸がん）2回目"),
    .init(category: "定期接種ワクチン", title: "HPV（子宮頸がん）3回目"),
    // 乳幼児健診
    .init(category: "乳幼児健診", title: "1ヶ月健診"),
    .init(category: "乳幼児健診", title: "3〜4ヶ月健診"),
    .init(category: "乳幼児健診", title: "6〜7ヶ月健診"),
    .init(category: "乳幼児健診", title: "9〜10ヶ月健診"),
    .init(category: "乳幼児健診", title: "1歳健診"),
    .init(category: "乳幼児健診", title: "1歳6ヶ月健診"),
    .init(category: "乳幼児健診", title: "2歳健診"),
    .init(category: "乳幼児健診", title: "3歳健診"),
]

// MARK: - AddEventView

struct AddEventView: View {
    @Environment(EventStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var date = Date()
    @State private var comment = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedUIImage: UIImage?
    @State private var showingTemplatePicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button {
                        showingTemplatePicker = true
                    } label: {
                        Label("テンプレートから選ぶ", systemImage: "list.bullet.clipboard")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } footer: {
                    Text("定期接種ワクチン・乳幼児健診のテンプレートが選べます")
                }

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
            .sheet(isPresented: $showingTemplatePicker) {
                TemplatePickerView(selectedTitle: $title)
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

// MARK: - TemplatePickerView

private struct TemplatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTitle: String

    private let categories = ["定期接種ワクチン", "乳幼児健診"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(eventTemplates.filter { $0.category == category }) { template in
                            Button(template.title) {
                                selectedTitle = template.title
                                dismiss()
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .navigationTitle("テンプレート")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }
}
