
//
//  LearningJourneyBarView.swift
//
//
//  Created by octavianus on 24/01/24.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct LearningJourneyBarView: View {
    @State private var hoverLocation: CGPoint = .zero
    @State private var isHovering = false
    
    var totalColumn: Int
    var currentProgress: Int
    var targetObjectiveAt: Int
    
    var backgroundColor: Color
    var backgroundLineColor: Color
    var backgroundLineWidth: CGFloat = 1
    
    var barColor: Color
    var targetColor: Color
    var hoverColor: Color
    
    var onProgressBarClicked: ( () -> (Void) )?
    
    init(totalColumn: Int, currentProgress: Int, targetObjectiveAt: Int, backgroundColor: Color, backgroundLineColor: Color, backgroundLineWidth: CGFloat, barColor: Color, targetColor: Color, hoverColor: Color, onProgressBarClicked: ( () -> Void)? = nil) {
        self.totalColumn = totalColumn
        self.currentProgress = currentProgress
        self.targetObjectiveAt = targetObjectiveAt
        self.backgroundColor = backgroundColor
        self.backgroundLineColor = backgroundLineColor
        self.backgroundLineWidth = backgroundLineWidth
        self.barColor = barColor
        self.targetColor = targetColor
        self.hoverColor = hoverColor
        self.onProgressBarClicked = onProgressBarClicked
    }
    
    var body: some View {
        VStack{
            if targetObjectiveAt > totalColumn{
                Text("Target objective should not exceed totalLO")
            }else{
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let rowSize = width / CGFloat(totalColumn)
                    let barHeight = height / 3
                    let barCenter = height / 2
                    let overlapBar = rowSize / 6
                    
                    Path{ path in
                        for index in 0...totalColumn{
                            path.move(to:
                                        CGPointMake(0 + (CGFloat(index) * rowSize),0))
                            path.addLine(to:
                                            CGPointMake(0 + (CGFloat(index) * rowSize),height))
                            
                        }
                    }
                    .stroke(.black,lineWidth: backgroundLineWidth)
                    
                    // Draw Background line
                    Path{ path in
                        
                        path.move(to: CGPointMake(0, barCenter - (barHeight / 2)))
                        path.addLine(to: CGPointMake(rowSize * CGFloat(currentProgress+1) + overlapBar , barCenter - (barHeight / 2)))
                        path.addLine(to: CGPointMake(rowSize * CGFloat(currentProgress+1) + overlapBar , barCenter + (barHeight / 2)))
                        path.addLine(to: CGPointMake(0, barCenter + (barHeight / 2)))
                    }
                    .fill(isHovering ? barColor : hoverColor)
                    .onTapGesture {
                        print("asd")
                        if let onProgressBarClicked{
                            onProgressBarClicked()
                        }
                    }
                    .onHover(perform: { hoverStatus in
                        isHovering = hoverStatus
                    })
                    
                    //Draw background Circle
                    Path{ path in
                        path.addArc(center:
                                        CGPoint(
                                            x: rowSize * CGFloat(currentProgress+1) + overlapBar,
                                            y: barCenter),
                                    radius: barHeight / 2,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360), clockwise: true)
                    }
                    .fill(isHovering ? barColor : hoverColor)
                    .onTapGesture {
                        print("asd")
                        if let onProgressBarClicked{
                            onProgressBarClicked()
                        }
                    }
                    .onHover(perform: { hoverStatus in
                        isHovering = hoverStatus
                    })

                    
                    
                    // Draw the line
                    Path{ path in
                        
                        path.move(to: CGPointMake(0, barCenter - (barHeight / 2)))
                        path.addLine(to: CGPointMake(rowSize * CGFloat(currentProgress) + overlapBar , barCenter - (barHeight / 2)))
                        path.addLine(to: CGPointMake(rowSize * CGFloat(currentProgress) + overlapBar , barCenter + (barHeight / 2)))
                        path.addLine(to: CGPointMake(0, barCenter + (barHeight / 2)))
                    }
                    .fill(barColor)
                    
                    Path{ path in
                        path.addArc(center:
                                        CGPoint(
                                            x: rowSize * CGFloat(currentProgress) + overlapBar,
                                            y: barCenter),
                                    radius: barHeight / 2,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360), clockwise: true)
                    }
                    .fill(barColor)
                    
                    
                    //Draw Target Color
                    Path { path in
                        path.move(to: CGPoint(
                            x: rowSize * CGFloat(targetObjectiveAt),
                            y: 0))
                        path.addLine(to: CGPoint(
                            x: rowSize * CGFloat(targetObjectiveAt),
                            y: height))
                    }
                    .stroke(barColor,lineWidth: backgroundLineWidth)
                    
                }
                .background(self.backgroundColor)
            }
        }
    }
}
