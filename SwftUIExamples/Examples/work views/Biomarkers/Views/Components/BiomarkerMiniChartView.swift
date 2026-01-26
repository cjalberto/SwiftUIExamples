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
    public let visibleMin: Double?
    public let visibleMax: Double?
    public let trend: BiomarkerTrend?
    
    public init(dataPoints: [BiomarkerDataPoint], visibleMin: Double? = nil, visibleMax: Double? = nil, trend: BiomarkerTrend? = nil) {
        self.dataPoints = dataPoints
        self.visibleMin = visibleMin
        self.visibleMax = visibleMax
        self.trend = trend
    }
    
    public var minValue: Double {
        visibleMin ?? dataPoints.map(\.value).min() ?? 0
    }
    
    public var maxValue: Double {
        visibleMax ?? dataPoints.map(\.value).max() ?? 100
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
    public let verticalPadding: CGFloat
    public let lineColor: Color?
    
    public init(
        lineWidth: CGFloat = 2,
        showEndDot: Bool = true,
        endDotSize: CGFloat = 10,
        backgroundColor: Color = Color(red: 245/255, green: 245/255, blue: 245/255).opacity(0.5),
        cornerRadius: CGFloat = 8,
        horizontalPadding: CGFloat = 5,
        verticalPadding: CGFloat = 12,
        lineColor: Color? = nil
    ) {
        self.lineWidth = lineWidth
        self.showEndDot = showEndDot
        self.endDotSize = endDotSize
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
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
            verticalPadding: verticalPadding,
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
        verticalPadding: 6,
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
            Chart {
                // Dashed line at the end date
                if let lastPoint = data.dataPoints.last {
                    RuleMark(x: .value("Date", lastPoint.date))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundStyle(Color.gray.opacity(0.5))
                }

                ForEach(data.dataPoints) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(lineColor)
                    .lineStyle(StrokeStyle(lineWidth: style.lineWidth, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                }
                
                // End dot on last point
                if style.showEndDot, let lastPoint = data.dataPoints.last {
                    PointMark(
                        x: .value("Date", lastPoint.date),
                        y: .value("Value", lastPoint.value)
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
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.backgroundColor)
                .padding(.vertical, style.verticalPadding * 2)
        )
    }
    
    private var paddedDomain: ClosedRange<Double> {
        let padding = (data.maxValue - data.minValue) * 0.1
        return (data.minValue - padding)...(data.maxValue + padding)
    }
}

// MARK: - Preview
#Preview("Mini Chart - Up Trend") {
    let calendar = Calendar.current
    let today = Date()
    let dataPoints = (0..<8).map { i in
        BiomarkerDataPoint(
            value: Double.random(in: 40...60),
            date: calendar.date(byAdding: .day, value: -i * 7, to: today) ?? today
        )
    }.reversed()
    
    return BiomarkerMiniChartView(
        data: BiomarkerChartData(
            dataPoints: Array(dataPoints),
            trend: .up
        ),
        style: .default
    )
    .frame(width: 120, height: 40)
    .padding()
}

#Preview("Mini Chart - Down Trend") {
    let calendar = Calendar.current
    let today = Date()
    let dataPoints = (0..<8).map { i in
        BiomarkerDataPoint(
            value: Double.random(in: 3.5...5.0),
            date: calendar.date(byAdding: .day, value: -i * 7, to: today) ?? today
        )
    }.reversed()
    
    return BiomarkerMiniChartView(
        data: BiomarkerChartData(
            dataPoints: Array(dataPoints),
            trend: .down
        ),
        style: .compact
    )
    .frame(width: 100, height: 35)
    .padding()
}

#Preview("Mini Chart - Resizable") {
    let calendar = Calendar.current
    let today = Date()
    let dataPoints = (0..<8).map { i in
        BiomarkerDataPoint(
            value: Double.random(in: 20...80),
            date: calendar.date(byAdding: .day, value: -i * 7, to: today) ?? today
        )
    }.reversed()
    
    return VStack(spacing: 20) {
        BiomarkerMiniChartView(
            data: BiomarkerChartData(dataPoints: Array(dataPoints), trend: .up),
            style: .default
        )
        .frame(width: 80, height: 30)
        
        BiomarkerMiniChartView(
            data: BiomarkerChartData(dataPoints: Array(dataPoints), trend: .down),
            style: .default
        )
        .frame(width: 120, height: 40)
        
        BiomarkerMiniChartView(
            data: BiomarkerChartData(dataPoints: Array(dataPoints), trend: .neutral),
            style: .default
        )
        .frame(width: 200, height: 60)
    }
    .padding()
}
