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
    
    @StateObject var appModel: AppViewModel = .init()
    
    var body: some View {
        VStack{
            CustomSegmentedControl()
                .padding()
            
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    if let coins = appModel.coins {
                        ForEach(coins) { coin in
                            VStack(spacing: 8){
                                CardView(coin: coin)
                                Divider()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            
//            LineGraph()
//                .frame(height: 220)
//                .padding(.top, 25)
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
    func CardView(coin: CryptoModel) -> some View {
        HStack{
            VStack(alignment: .leading, spacing: 6, content: {
                Text(coin.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.gray)
            })
            .frame(width: 80, alignment: .leading)
            
            LineGraph(data: coin.last_7days_price.price, profit: coin.price_change > 0)
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(coin.current_price.convertToCurrency())
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(coin.price_change > 0 ? .green : .red )
            })
        }
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

extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
