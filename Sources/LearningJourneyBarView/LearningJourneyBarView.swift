
//
//  LearningJourneyBarView.swift
//
//
//  Created by octavianus on 24/01/24.
//

import Foundation
import SwiftUI
import AppKit

@available(iOS 16.0, *)
public struct LearningJourneyBarView: View {
    
    //For the Hover Bar
    @State private var isMinBarHovering = false
    @State private var isPlusBarHovering = false
    @State private var minBarWidth: CGFloat = 0
    @State private var midBarWidth: CGFloat = 0
    @State private var plusBarWidth: CGFloat = 0
    @State private var selectedIndex: Int? = nil
    @State private var isBarClickable = false
    
    //For View
    @State var rowSize: CGFloat = 0
    @State var overlapBar: CGFloat = 0
    @State var barHeight: CGFloat = 0
    @State var height: CGFloat = 0
    
    var totalColumn: Int
    var currentProgress: Int
    var targetObjectiveAt: Int
    
    var backgroundLineColor: Color
    var backgroundMiddleLineColor: Color
    var backgroundLineWidth: CGFloat = 1
    
    var barColor: Color
    var targetColor: Color
    var backPlusBarHoverColor: Color
    var frontMinBarHoverColor: Color
    
    var onBarClicked: ( (Int) -> (Void) )?
    
    
    public init(totalColumn: Int, currentProgress: Int, targetObjectiveAt: Int, backgroundLineColor: Color,backgroundMiddleLineColor: Color, backgroundLineWidth: CGFloat, barColor: Color, targetColor: Color, backPlusBarHoverColor: Color,frontMinBarHoverColor: Color, onBarClicked: ( (Int) -> Void)? = nil) {
        self.totalColumn = totalColumn
        self.currentProgress = currentProgress
        self.targetObjectiveAt = targetObjectiveAt
        self.backgroundLineColor = backgroundLineColor
        self.backgroundMiddleLineColor = backgroundMiddleLineColor
        self.backgroundLineWidth = backgroundLineWidth
        self.barColor = barColor
        self.targetColor = targetColor
        self.backPlusBarHoverColor = backPlusBarHoverColor
        self.frontMinBarHoverColor = frontMinBarHoverColor
        self.onBarClicked = onBarClicked
        
    }
    
    @State var widthGeo:CGFloat = 0
    public var body: some View {
        ZStack{
            if targetObjectiveAt > totalColumn{
                Text("Target objective should not exceed totalLO")
            }else{
                GeometryReader { geometry in
                    
                    let width = geometry.size.width
                    let height = geometry.size.height + geometry.safeAreaInsets.top
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
                    .onAppear{
                        self.plusBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                        self.height = height
                        self.rowSize = rowSize
                        self.barHeight = barHeight
                        self.overlapBar = overlapBar
                    }
                    
                    
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
                    
                    Rectangle()
                        .frame(width: width + overlapBar + backgroundLineWidth * 2,height: backgroundLineWidth)
                        .offset(y: height / 2 - (backgroundLineWidth / 2))
                    
                    //Background Bar
                    if currentProgress != totalColumn{
                        Rectangle()
                            .foregroundColor(
                                isPlusBarHovering ? barColor:                            backPlusBarHoverColor)
                            .frame(
                                width: plusBarWidth ,
                                height: barHeight)
                            
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 0,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: barHeight / 2,
                                    topTrailingRadius: barHeight / 2
                                )
                            )
                            .offset(y: height / 2 - (barHeight / 2))
                    }
                    
                    //draw the bar
                    
                    Rectangle()
                        .frame(
                            width:
                                midBarWidth,
                            height: barHeight)
                    
                        .foregroundColor(barColor)
                        .onAppear(perform: {
                            midBarWidth = rowSize * CGFloat(currentProgress) + overlapBar
                        })
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: barHeight / 2,
                                topTrailingRadius: barHeight / 2
                            )
                        )
                        .overlay(alignment: .leading, content: {
                            Rectangle()
                                .frame(
                                    width:
                                        minBarWidth,
                                    height: barHeight)
                                .foregroundColor(isMinBarHovering ? .green : .black)
                                .clipShape(
                                    .rect(
                                        topLeadingRadius: 0,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: barHeight / 2,
                                        topTrailingRadius: barHeight / 2
                                    )
                                )
                                
                                
                        })
                        .offset(y: height / 2 - (barHeight / 2))
                }
                .onContinuousHover(coordinateSpace: .local) { phase in
                    switch phase{
                    case .active(let point):
                        guard rowSize != 0 else { return }
                        let currentXIndex = Int(point.x / rowSize) + 1
                        
                        let topBarPosition = height / 2 - (barHeight / 2)
                        let bottomBarPosition = height / 2 + (barHeight / 2)
                        
                        midBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                        minBarWidth = 0
                        plusBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                        self.isBarClickable = false
                        
                        guard (
                            point.y > topBarPosition &&
                            point.y < bottomBarPosition &&
                            point.x < rowSize * CGFloat((totalColumn))) else { return }
                        
                        self.selectedIndex = currentXIndex
                        self.isBarClickable = true
                        
                        
                        if currentXIndex < currentProgress{
                            midBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                            minBarWidth = CGFloat(currentXIndex) * rowSize + overlapBar
                            plusBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                        }else
                        if currentXIndex > currentProgress{
                            midBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                            minBarWidth = 0
                            plusBarWidth = CGFloat(currentXIndex) * rowSize + overlapBar
                        }else{
                            midBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                            minBarWidth = 0
                            plusBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                            self.isBarClickable = false
                        }
                    case .ended:
                        midBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                        minBarWidth = 0
                        plusBarWidth = CGFloat(currentProgress) * rowSize + overlapBar
                        self.isBarClickable = false
                    }
                }
                .onTapGesture {
                    if isBarClickable, let onBarClicked, let selectedIndex{
                        onBarClicked(selectedIndex)
                    }
                }
            }
        }
    }
}


#Preview {
    if #available(macCatalyst 16.0, *) {
        VStack{
            LearningJourneyBarView(
                totalColumn: 6,
                currentProgress: 3,
                targetObjectiveAt: 2,
                backgroundLineColor: .blue,
                backgroundMiddleLineColor: .red,
                backgroundLineWidth: 10,
                barColor: .cyan,
                targetColor: .green,
                backPlusBarHoverColor: .red,
                frontMinBarHoverColor: .green,
                onBarClicked: { index in
                    print("Clicked \(index)")
                })
            .frame(width: 300)
            LearningJourneyBarView(
                totalColumn: 4,
                currentProgress: 0,
                targetObjectiveAt: 2,
                backgroundLineColor: .blue,
                backgroundMiddleLineColor: .red,
                backgroundLineWidth: 10,
                barColor: .cyan,
                targetColor: .green,
                backPlusBarHoverColor: .red,
                frontMinBarHoverColor: .green,
                onBarClicked: { index in
                    print("Clicked \(index)")
                })
            .frame(width: 200)
            
            
        }
        
        
    } else {
        Text("Wrong")
    }
}
