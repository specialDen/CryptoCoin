//
//  CrptoCurrencyData.swift
//  CryptoCoin
//
//  Created by Izuchukwu Dennis on 10.08.2021.
//  Copyright © 2021 Izuchukwu Dennis. All rights reserved.
//

import Foundation

struct CryptoCurrencyData: Codable {
    let rate: Double
    let crypto: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case crypto = "asset_id_base"
        case currency = "asset_id_quote"
        case rate = "rate"
        
    }
    
    
}
