import SwiftUI

struct ExamplesListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("UI Controls") {
                    ExampleRow(title: "Buttons", icon: "button.programmable") { ButtonsView() }
                    ExampleRow(title: "Color Picker", icon: "paintpalette") { ColorPickerView() }
                    ExampleRow(title: "Date Picker", icon: "calendar") { DatePickerView() }
                    ExampleRow(title: "Slider", icon: "slider.horizontal.3") { SliderView() }
                    ExampleRow(title: "Stepper", icon: "plus.forwardslash.minus") { StepperView() }
                }

                Section("Text & Input") {
                    ExampleRow(title: "Text", icon: "textformat") { text() }
                    ExampleRow(title: "Text Field", icon: "character.cursor.ibeam") { textfield() }
                    ExampleRow(title: "Text Editor", icon: "doc.text") { textEditor() }
                }

                Section("Lists & Grids") {
                    ExampleRow(title: "List", icon: "list.bullet") { ListDevicesView(devices: ["HOUSE": house, "WORK": work]) }
                    ExampleRow(title: "Swipe Actions", icon: "arrow.left.and.right") { SwipeActionsLists() }
                    ExampleRow(title: "Lazy Grid", icon: "grid") { LazyGridView() }
                }

                Section("Navigation") {
                    ExampleRow(title: "Navigation View", icon: "chevron.right.square") { NavegationView() }
                    ExampleRow(title: "Tab View", icon: "square.grid.2x2") { TabView1() }
                }

                Section("Layout") {
                    ExampleRow(title: "Geometry Reader", icon: "aspectratio") { GeometryReaderScrollView() }
                    ExampleRow(title: "View Modifiers", icon: "wand.and.stars") { ModifierView() }
                    ExampleRow(title: "Shimmer Effect", icon: "sparkles") { ShimmerExampleView() }
                    ExampleRow(title: "Animated VStack", icon: "arrow.up.to.line") { AnimatedVStackExampleView() }
                }

                Section("State Management") {
                    ExampleRow(title: "States", icon: "arrow.triangle.2.circlepath") { states() }
                    ExampleRow(title: "App Storage", icon: "externaldrive") { AppStorageView() }
                    ExampleRow(title: "Scene Storage", icon: "apps.iphone") { SceneStorageView() }
                    ExampleRow(title: "Observed Object", icon: "eye") { ObservedObjectView() }
                }

                Section("Overlays & Modals") {
                    ExampleRow(title: "Alert", icon: "exclamationmark.triangle") { AlertView() }
                    ExampleRow(title: "Full Screen Cover & Sheet", icon: "rectangle.expand.vertical") { ContentView2() }
                    ExampleRow(title: "Context Menu", icon: "contextualmenu.and.cursorarrow") { ContextMenu() }
                }

                Section("Other") {
                    ExampleRow(title: "Form", icon: "list.clipboard") { FormView() }
                    ExampleRow(title: "Link", icon: "link") { LinkView() }
                    ExampleRow(title: "Progress View", icon: "chart.bar") { ProgressV() }
                    ExampleRow(title: "Gestures", icon: "hand.tap") { GesturesView() }
                }

            }
            .navigationTitle("SwiftUI Examples")
        }
    }
}

private struct ExampleRow<Destination: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination().navigationTitle(title)) {
            Label(title, systemImage: icon)
        }
    }
}

#Preview {
    ExamplesListView()
}
