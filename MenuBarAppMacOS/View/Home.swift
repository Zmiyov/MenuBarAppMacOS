//
//  Home.swift
//  MenuBarAppMacOS
//
//  Created by Volodymyr Pysarenko on 13.06.2024.
//

import SwiftUI

struct Home: View {
    @State var currentTab: String = "Crypto"
    @Namespace var animation
    var body: some View {
        VStack{
            CustomSegmentedControl()
                .padding()
            
            LineGraph()
                .frame(height: 220)
                .padding(.top, 25)
            Spacer()
            
            HStack{
                Button(action: {
                    
                }, label: {
                    Image(systemName: "gearshape.fill")
                })
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "power")
                })
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.black)
        }
        .frame(width: 320, height: 450)
        .background(Color.bg)
        .preferredColorScheme(.dark)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0){
            
            ForEach(["Crypto", "Stocks"], id: \.self) { tab in
                Text(tab)
                    .fontWeight(currentTab == tab ? .semibold : .regular)
                    .foregroundStyle(currentTab == tab ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background{
                        if currentTab == tab {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.tab)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            currentTab = tab
                        }
                    }
            }
        }
        .padding(2)
        .background{
            Color.black.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

#Preview {
    Home()
}
