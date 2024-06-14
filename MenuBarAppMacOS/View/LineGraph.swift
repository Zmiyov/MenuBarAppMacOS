//
//  LineGraph.swift
//  MenuBarAppMacOS
//
//  Created by Volodymyr Pysarenko on 14.06.2024.
//

import SwiftUI

struct LineGraph: View {
    
    var data: [Double] = [989, 1200, 750, 790, 650, 950, 1200, 600, 500, 600, 890, 1203, 1400, 900, 1250, 1600, 1200]
    var profit: Bool = false
    
    @State var currentPlot: String = ""
    @State var offset: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    @GestureState var isDrag: Bool = false
    
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap{ item -> CGPoint in
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                let pathHeight = progress * (height)
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth , y: -pathHeight + height)
            }
            
            ZStack{
                
                AnimatablePath(progress: graphProgress, points: points)
                .fill(
                    LinearGradient(colors: [
                        profit ? .profit : .loss,
                        profit ? .profit : .loss
                    ], startPoint: .leading, endPoint: .trailing)
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
                .opacity(graphProgress)
            }
        }
//        .background(
//        
//            VStack(alignment: .leading){
//                
//                let max = data.max() ?? 0
//                let min = data.min() ?? 0
//                
//                Text(max.convertToCurrency())
//                    .font(.caption.bold())
//                
//                Spacer()
//                
//                Text(min.convertToCurrency())
//                    .font(.caption.bold())
//                    .offset(y: 15)
//            }
//                .frame(maxWidth: .infinity, alignment: .leading)
//        )
        .padding(.horizontal, 10)
        .onChange(of: isDrag, { _, newValue in
            if !isDrag{ showPlot = false }
        })
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { _, newValue in
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        let color: Color = profit ? Color.profit : Color.loss
        //Path background
        LinearGradient(colors: [
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.1)]
                       + Array(repeating: color.opacity(0.1), count: 4)
                       + Array(repeating: Color.clear, count: 2)
                       , startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    Home()
}

struct AnimatablePath: Shape {
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat{
        get{return progress}
        set{progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}
