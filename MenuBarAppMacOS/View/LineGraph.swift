//
//  LineGraph.swift
//  MenuBarAppMacOS
//
//  Created by Volodymyr Pysarenko on 14.06.2024.
//

import SwiftUI

struct LineGraph: View {
    
    var data: [CGFloat] = [989, 1200, 750, 790, 650, 950, 1200, 600, 500, 600, 890, 1203, 1400, 900, 1250, 1600, 1200]
    
    @State var currentPlot: String = ""
    @State var offset: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count)
            
            let maxPoint = (data.max() ?? 0) + 100
            
            let points = data.enumerated().compactMap{ item -> CGPoint in
                let progress = item.element / maxPoint
                let pathHeight = progress * height
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth , y: -pathHeight + height)
            }
            
            ZStack{
                
                Path{ path in
                    
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [.gradient1, .gradient2], startPoint: .leading, endPoint: .trailing)
                )
                
                FillBG()
                
                .clipShape(
                
                    Path{ path in
                        
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
                .padding(.top, 12)
                
            }
            .overlay(
            
                VStack(spacing: 0){
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.gradient1, in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(.gradient1)
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(.gradient1)
                        .frame(width: 22, height: 22)
                        .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 10, height: 10)
                        )
                    
                    Rectangle()
                        .fill(.gradient1)
                        .frame(width: 1, height: 45)
                }
                    .frame(width: 80, height: 170)
                    .offset(y: 70)
                    .opacity(showPlot ? 1 : 0)
                    .offset(offset),
                
                alignment: .leading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation {
                    showPlot = true
                }
                
                let translation = value.location.x - 40
                
                let index = max(min(Int((translation / width).rounded() - 1), data.count - 1), 0)
                
                currentPlot = "$ \(data[index])"
                self.translation = translation
                
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation {
                    showPlot = false
                }
            }))
        }
        .overlay(
        
            VStack(alignment: .leading){
                
                let max = data.max() ?? 0
                
                Text("$ \(Int(max))")
                    .font(.caption.bold())
                
                Spacer()
                
                Text("$ 0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        //Path background
        LinearGradient(colors: [
            .gradient1.opacity(0.3),
            .gradient2.opacity(0.2),
            .gradient2.opacity(0.1)]
                       + Array(repeating: Color.gradient1.opacity(0.1), count: 4)
                       + Array(repeating: Color.clear, count: 2)
                       , startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    Home()
}