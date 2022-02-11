//
//  Widgets.swift
//  Widgets
//
//  Created by 전윤현 on 2022/02/11.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    private var event: Event? {
        let storage = LocalEventStorage(with: UserDefaults(suiteName: "group.kr.co.bepo.days")!)
        if let id = WidgetDefaults.shared.id, let event = storage.find(by: id) {
            return event
        } else {
            return nil
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), event: self.event)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, event: self.event)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, event: self.event)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var event: Event?
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let event = entry.event {
            VStack {
                Spacer().frame(height: 20)
                
                HStack {
                    Spacer()
                    Image("icon_\(event.icon)").resizable().frame(width: 40, height: 40)
                    Spacer().frame(width: 15)
                }
                
                Spacer()
                VStack(alignment: .leading) {
                    if event.dayCount(from: entry.date) == 0 {
                        Text("Today").font(.system(size: 20, weight: .bold))
                    } else {
                        let prefix = event.dayCount(from: entry.date) > 0 ? "D+" : "D-"
                        Text("\(prefix)\(abs(event.dayCount(from: entry.date)))").font(.system(size: 20, weight: .bold))
                    }
                    
                    Spacer().frame(height: 5)
                    Text(event.title).font(.system(size: 12, weight: .bold)).frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(height: 2)
                    Text(event.date, style: .date).font(.system(size: 10, weight: .light))
                }.padding(.leading, 20)
            }.padding(.bottom, 20)
        } else {
            Text("No Event")
        }
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), event: Event(title: "Birthday", icon: 1, date: Date().addingTimeInterval(1000000))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
