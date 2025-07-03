
import SwiftUI

struct RangeSlider: View {
    @Binding var minValue: Double
       @Binding var maxValue: Double
       let barData: [Double]
       let range: ClosedRange<Double>
       @State private var isDraggingMin = false
       @State private var isDraggingMax = false

       var body: some View {
           VStack {
               GeometryReader { geometry in
                   RangeSliderContent(
                       width: geometry.size.width,
                       minValue: $minValue,
                       maxValue: $maxValue,
                       isDraggingMin: $isDraggingMin,
                       isDraggingMax: $isDraggingMax,
                       barData: barData,
                       range: range
                   )
               }
               .frame(height: 120)
           }
           .padding()
       }
}

struct RangeSliderContent: View {
    let width: CGFloat
    @Binding var minValue: Double
    @Binding var maxValue: Double
    @Binding var isDraggingMin: Bool
    @Binding var isDraggingMax: Bool
    let barData: [Double]
    let range: ClosedRange<Double>

    private let height: CGFloat = 100

    var body: some View {
        ZStack(alignment: .leading) {
            BarChartView(barData: barData, width: width, height: height, minValue: minValue, maxValue: maxValue)
            SelectionBarsView(minValue: minValue, maxValue: maxValue, width: width, height: height)
            SelectionIndicatorView(minValue: minValue, maxValue: maxValue, width: width, height: height)
            MinHandleView(minValue: $minValue, maxValue: maxValue, isDragging: $isDraggingMin, width: width, height: height, range: range)
            MaxHandleView(minValue: minValue, maxValue: $maxValue, isDragging: $isDraggingMax, width: width, height: height, range: range)
        }
    }
}

struct BarChartView: View {
    let barData: [Double]
    let width: CGFloat
    let height: CGFloat
    var minValue: Double
    var maxValue: Double

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<barData.count, id: \.self) { index in
                let indexValue = Double(index) / Double(barData.count - 1) * 100
                let isSelected = indexValue >= minValue && indexValue <= maxValue

                Rectangle()
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.3))
                    .frame(
                        width: barWidth,
                        height: (barData[index] / 100.0) * height
                    )
            }
        }
        .frame(height: height)
    }

    private var barWidth: CGFloat {
        (width - CGFloat(barData.count - 1) * 2) / CGFloat(barData.count)
    }
}

struct SelectionBarsView: View {
    let minValue: Double
    let maxValue: Double
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: leftBarWidth, height: 4)

            Spacer()

            Rectangle()
                .fill(Color.black)
                .frame(width: rightBarWidth, height: 4)
        }
        .offset(y: height / 2 - 2.9)
    }

    private var leftBarWidth: CGFloat {
        (maxValue / 100.0) * width
    }

    private var rightBarWidth: CGFloat {
        ((100 - maxValue) / 100.0) * width
    }
}

struct SelectionIndicatorView: View {
    let minValue: Double
    let maxValue: Double
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(
                Rectangle()
                    .stroke(Color.clear.opacity(0.3), lineWidth: 2)
            )
            .frame(width: selectionWidth, height: height)
            .offset(x: selectionOffset, y: 0)
    }

    private var selectionWidth: CGFloat {
        ((maxValue - minValue) / 100.0) * width
    }

    private var selectionOffset: CGFloat {
        (minValue / 100.0) * width
    }
}

struct MinHandleView: View {
    @Binding var minValue: Double
    let maxValue: Double
    @Binding var isDragging: Bool
    let width: CGFloat
    let height: CGFloat
    let range: ClosedRange<Double>

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    
                    .stroke(Color.gray, lineWidth: 2)
            )
            
            .scaleEffect(isDragging ? 1.2 : 1.0)
            .position(x: handlePosition, y: height / 2 + 55)
            .gesture(dragGesture)
    }

    private var handlePosition: CGFloat {
        (minValue / 100.0) * width
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                let newValue = max(
                    range.lowerBound,
                    min(maxValue - 5, (Double(value.location.x) / Double(width)) * 100)
                )
                minValue = newValue
            }
            .onEnded { _ in
                isDragging = false
            }
    }
}

struct MaxHandleView: View {
    let minValue: Double
    @Binding var maxValue: Double
    @Binding var isDragging: Bool
    let width: CGFloat
    let height: CGFloat
    let range: ClosedRange<Double>

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
            )
            .scaleEffect(isDragging ? 1.2 : 1.0)
            .position(x: handlePosition, y: height / 2 + 55)
            .gesture(dragGesture)
    }

    private var handlePosition: CGFloat {
        (maxValue / 100.0) * width
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                let newValue = max(
                    minValue + 5,
                    min(range.upperBound, (Double(value.location.x) / Double(width)) * 100)
                )
                maxValue = newValue
            }
            .onEnded { _ in
                isDragging = false
            }
    }
}
