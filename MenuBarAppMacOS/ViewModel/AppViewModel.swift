//
//  AppViewModel.swift
//  MenuBarAppMacOS
//
//  Created by Volodymyr Pysarenko on 14.06.2024.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var coins: [CryptoModel]?
    @Published var currentCoin: CryptoModel?
    
    init() {
        Task{
            do {
                try await fetchCryptoData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCryptoData() async throws {
        guard let url = url else { return }
        let session = URLSession.shared
        
        let responce = try await session.data(from: url)
        let jsonData = try JSONDecoder().decode([CryptoModel].self, from: responce.0)
        
        await MainActor.run {
            self.coins = jsonData
            if let firstCoin = jsonData.first {
                self.currentCoin = firstCoin
            }
        }
    }
}
