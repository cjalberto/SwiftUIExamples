//
//  BiomarkerMiniChartView.swift
//  Doc App
//
//  Created on 24/01/26.
//

import SwiftUI
import Charts

// MARK: - Chart Data Structure
public struct BiomarkerChartData {
    public let dataPoints: [BiomarkerDataPoint]
    public let limitLowValue: Double?
    public let limitHighValue: Double?
    public let trend: BiomarkerTrend?
    
    public init(dataPoints: [BiomarkerDataPoint], limitLowValue: Double? = nil, limitHighValue: Double? = nil, trend: BiomarkerTrend? = nil) {
        self.dataPoints = dataPoints
        self.limitLowValue = limitLowValue
        self.limitHighValue = limitHighValue
        self.trend = trend
    }
    
    public var minValue: Double {
        limitLowValue ?? dataPoints.map(\.value).min() ?? 0
    }
    
    public var maxValue: Double {
        limitHighValue ?? dataPoints.map(\.value).max() ?? 100
    }
}

// MARK: - Chart Style Structure
public struct BiomarkerChartStyle {
    public let lineWidth: CGFloat
    public let showEndDot: Bool
    public let endDotSize: CGFloat
    public let backgroundColor: Color
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat
    public let lineColor: Color?
    
    public init(
        lineWidth: CGFloat = 2,
        showEndDot: Bool = true,
        endDotSize: CGFloat = 10,
        backgroundColor: Color = Color(red: 245/255, green: 245/255, blue: 245/255).opacity(0.5),
        cornerRadius: CGFloat = 8,
        horizontalPadding: CGFloat = 5,
        lineColor: Color? = nil
    ) {
        self.lineWidth = lineWidth
        self.showEndDot = showEndDot
        self.endDotSize = endDotSize
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.lineColor = lineColor
    }
    
    public func with(lineColor: Color) -> BiomarkerChartStyle {
        BiomarkerChartStyle(
            lineWidth: lineWidth,
            showEndDot: showEndDot,
            endDotSize: endDotSize,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            horizontalPadding: horizontalPadding,
            lineColor: lineColor
        )
    }
    
    public static let `default` = BiomarkerChartStyle()
    
    public static let compact = BiomarkerChartStyle(
        lineWidth: 1.5,
        showEndDot: true,
        endDotSize: 8,
        backgroundColor: Color(red: 245/255, green: 245/255, blue: 245/255),
        cornerRadius: 20,
        horizontalPadding: 16,
        lineColor: nil
    )
}

// MARK: - Mini Chart View
public struct BiomarkerMiniChartView: View {
    private let data: BiomarkerChartData
    private let style: BiomarkerChartStyle
    
    public init(data: BiomarkerChartData, style: BiomarkerChartStyle = .default) {
        self.data = data
        self.style = style
    }
    
    private var lineColor: Color {
        style.lineColor ?? Color.black
    }
    
    public var body: some View {
        GeometryReader { geometry in
            // Y-offset adjustment: When axes are hidden (.chartXAxis(.hidden)), SwiftUI Charts
            // doesn't reserve space for the X-axis, causing the chart to render lower than expected.
            // We compensate by adding an offset proportional to the Y domain range (38% in this case)
            // to move all data points up, ensuring proper visual alignment within the chart area.
            let domainRange = (data.limitHighValue ?? 100) - (data.limitLowValue ?? 0)
            let yOffset = domainRange * 0.38 // 38% of the Y domain range
            
            Chart {
                if let lastPoint = data.dataPoints.last {
                    RuleMark(x: .value("Date", lastPoint.date))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundStyle(Color.gray.opacity(0.5))
                }

                ForEach(data.dataPoints) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value + yOffset) // applying yOffset when .chartXAxis(.hidden)
                    )
                    .foregroundStyle(lineColor)
                    .lineStyle(StrokeStyle(lineWidth: style.lineWidth, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                }
                
                if style.showEndDot, let lastPoint = data.dataPoints.last {
                    PointMark(
                        x: .value("Date", lastPoint.date),
                        y: .value("Value", lastPoint.value + yOffset)
                    )
                    .foregroundStyle(lineColor)
                    .symbolSize(style.endDotSize * style.endDotSize)
                    .annotation(position: .overlay) {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: style.endDotSize + 4, height: style.endDotSize + 4)
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartYScale(domain: paddedDomain)
            .padding(.horizontal, style.horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                    .padding(.vertical, geometry.size.height/4)
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private var paddedDomain: ClosedRange<Double> {
        
        let difference = (data.limitHighValue ?? 0) - (data.limitLowValue ?? 0)
        let lowLimit = (data.limitLowValue ?? 0) - difference/2
        let highLimit = (data.limitHighValue ?? 100) + difference/2
        
        let translation: Double
        if lowLimit < 0 {
            translation = abs(lowLimit)
        } else {
            translation = 0
        }
        
        let adjustedLow = lowLimit + translation
        let adjustedHigh = highLimit + translation
        
        return adjustedLow...adjustedHigh
    }
}

// MARK: - Preview
#Preview("Mini Chart - Custom Values") {
    let calendar = Calendar.current
    let today = Date()
    let values = [10.0, 20.5, 60.5, 50.6, 90.0, 45.0]
    
    let dataPoints = values.enumerated().map { index, value in
        BiomarkerDataPoint(
            value: value,
            date: calendar.date(byAdding: .day, value: -index * 7, to: today) ?? today
        )
    }.reversed()
    
    return BiomarkerMiniChartView(
        data: BiomarkerChartData(
            dataPoints: Array(dataPoints),
            limitLowValue: 25,
            limitHighValue: 80,
            trend: .up
        ),
        style: .default
    )
    .frame(width: 120, height: 40)
    .padding()
}
