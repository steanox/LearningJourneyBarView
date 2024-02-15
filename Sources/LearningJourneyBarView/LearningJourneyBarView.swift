
//
//  LearningJourneyBarView.swift
//
//
//  Created by octavianus on 24/01/24.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
public struct LearningJourneyBarView: View {
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
    var backBarColor: Color
    
    var onProgressBarClicked: ( () -> (Void) )?
    
    public init(totalColumn: Int, currentProgress: Int, targetObjectiveAt: Int, backgroundColor: Color, backgroundLineColor: Color, backgroundLineWidth: CGFloat, barColor: Color, targetColor: Color, backBarColor: Color, onProgressBarClicked: ( () -> Void)? = nil) {
        self.totalColumn = totalColumn
        self.currentProgress = currentProgress
        self.targetObjectiveAt = targetObjectiveAt
        self.backgroundColor = backgroundColor
        self.backgroundLineColor = backgroundLineColor
        self.backgroundLineWidth = backgroundLineWidth
        self.barColor = barColor
        self.targetColor = targetColor
        self.backBarColor = backBarColor
        self.onProgressBarClicked = onProgressBarClicked
        
    }
    
    @State var widthGeo:CGFloat = 0
    public var body: some View {
        ZStack{
            if targetObjectiveAt > totalColumn{
                Text("Target objective should not exceed totalLO")
            }else{

                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let rowSize = width / CGFloat(totalColumn)
                    let barHeight = height / 3
                    let overlapBar = rowSize / 4
                    
                    Path{ path in
                        for index in 0...totalColumn{
                            path.move(to:
                                        CGPointMake((CGFloat(index) * rowSize),0))
                            path.addLine(to: 
                                            CGPointMake(
                                CGFloat(index) * rowSize + backgroundLineWidth,
                                0))
                            path.addLine(to:
                                            CGPointMake((CGFloat(index) * rowSize) + backgroundLineWidth,height))
                            path.addLine(to:
                                        CGPointMake((CGFloat(index) * rowSize),height))
                            
                        }
                    }
                    .fill(backgroundLineColor)
                    
                    //Draw Target Color
                    Path { path in
                        path.move(to:CGPointMake(rowSize * CGFloat(targetObjectiveAt),0))
                        path.addLine(to:
                                        CGPointMake(
                                            rowSize * CGFloat(targetObjectiveAt) + backgroundLineWidth,
                            0))
                        path.addLine(to:
                                        CGPointMake(rowSize * CGFloat(targetObjectiveAt) + backgroundLineWidth,height))
                        path.addLine(to:
                                    CGPointMake(rowSize * CGFloat(targetObjectiveAt),height))
                    }
                    .fill(targetColor)
                    
                    //Background Bar
                    if currentProgress != totalColumn{
                        Rectangle()
                            .foregroundColor(
                                isHovering ? barColor:                            backBarColor)
                            
                            .frame(
                                width: rowSize * CGFloat(currentProgress+1) + overlapBar ,
                                height: barHeight)
                            
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 0,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: barHeight / 2,
                                    topTrailingRadius: barHeight / 2
                                )
                            )
                            .onHover(perform: { hovering in
                                isHovering = hovering
                            })
                            .onTapGesture {
                                if let onProgressBarClicked{
                                    onProgressBarClicked()
                                }
                            }
                            .offset(y: height / 2 - (barHeight / 2))
                    }
                    
                    //draw the bar
                    Rectangle()
                        .frame(
                            width:
                                rowSize * CGFloat(currentProgress) + overlapBar,
                            height: barHeight)
                    
                        .foregroundColor(barColor)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: barHeight / 2,
                                topTrailingRadius: barHeight / 2
                            )
                        )
                        .onHover(perform: { hovering in
                            isHovering = hovering
                        })
                        .onTapGesture {
                            if let onProgressBarClicked{
                                onProgressBarClicked()
                            }
                        }
                        .offset(y: height / 2 - (barHeight / 2))
                        


                        
                }
                .background(backgroundColor)
            }
        }
    }
}


#Preview {
    if #available(macCatalyst 16.0, *) {
        ZStack{
            Rectangle()
            LearningJourneyBarView(
                totalColumn: 4,
                currentProgress: 4,
                targetObjectiveAt: 2,
                backgroundColor: .gray,
                backgroundLineColor: .blue,
                backgroundLineWidth: 10,
                barColor: .cyan,
                targetColor: .green,
                backBarColor: .red,
                onProgressBarClicked: nil)
            .frame(width: 300)
        }
        
        
    } else {
        Text("Wrong")
    }
}
