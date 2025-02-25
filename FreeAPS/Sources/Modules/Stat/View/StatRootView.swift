import Charts
import CoreData
import SwiftDate
import SwiftUI
import Swinject

extension Stat {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()

        @FetchRequest(
            entity: TDD.entity(),
            sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]
        ) var fetchedTDD: FetchedResults<TDD>

        @FetchRequest(
            entity: InsulinDistribution.entity(),
            sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]
        ) var fetchedInsulin: FetchedResults<InsulinDistribution>

        enum Duration: String, CaseIterable, Identifiable {
            case Today
            case Day
            case Week
            case Month
            case Total
            var id: Self { self }
        }

        @State private var selectedDuration: Duration = .Today
        @State var paddingAmount: CGFloat? = 10
        @State var headline: Color = .secondary
        @State var days: Double = 0
        @State var pointSize: CGFloat = 3
        @State var conversionFactor = 0.0555

        @ViewBuilder func stats() -> some View {
            ZStack {
                let filter = DateFilter()
                switch selectedDuration {
                case .Today:
                    StatsView(
                        filter: filter.today,
                        $state.highLimit,
                        $state.lowLimit,
                        $state.units,
                        $state.overrideUnit
                    )
                case .Day:
                    StatsView(
                        filter: filter.day,
                        $state.highLimit,
                        $state.lowLimit,
                        $state.units,
                        $state.overrideUnit
                    )
                case .Week:
                    StatsView(
                        filter: filter.week,
                        $state.highLimit,
                        $state.lowLimit,
                        $state.units,
                        $state.overrideUnit
                    )
                case .Month:
                    StatsView(
                        filter: filter.month,
                        $state.highLimit,
                        $state.lowLimit,
                        $state.units,
                        $state.overrideUnit
                    )
                case .Total:
                    StatsView(
                        filter: filter.total,
                        $state.highLimit,
                        $state.lowLimit,
                        $state.units,
                        $state.overrideUnit
                    )
                }
            }
        }

        @ViewBuilder func chart() -> some View {
            let filter = DateFilter()
            switch selectedDuration {
            case .Today:
                ChartsView(
                    filter: filter.today,
                    $state.highLimit,
                    $state.lowLimit,
                    $state.units,
                    $state.overrideUnit,
                    $state.layingChart
                )
            case .Day:
                ChartsView(
                    filter: filter.day,
                    $state.highLimit,
                    $state.lowLimit,
                    $state.units,
                    $state.overrideUnit,
                    $state.layingChart
                )
            case .Week:
                ChartsView(
                    filter: filter.week,
                    $state.highLimit,
                    $state.lowLimit,
                    $state.units,
                    $state.overrideUnit,
                    $state.layingChart
                )
            case .Month:
                ChartsView(
                    filter: filter.month,
                    $state.highLimit,
                    $state.lowLimit,
                    $state.units,
                    $state.overrideUnit,
                    $state.layingChart
                )
            case .Total:
                ChartsView(
                    filter: filter.total,
                    $state.highLimit,
                    $state.lowLimit,
                    $state.units,
                    $state.overrideUnit,
                    $state.layingChart
                )
            }
        }

        var body: some View {
            HStack {
                VStack(alignment: .center, spacing: 16) {
                    chart().padding(.top, 20)
                    Picker("Duration", selection: $selectedDuration) {
                        ForEach(Duration.allCases) { duration in
                            Text(NSLocalizedString(duration.rawValue, comment: "")).tag(Optional(duration))
                        }
                    }
                    .pickerStyle(.segmented)
                    stats()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .onAppear(perform: configureView)
            .navigationBarTitle("Statistics")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(leading: Button("Close", action: state.hideModal))
        }
    }
}
