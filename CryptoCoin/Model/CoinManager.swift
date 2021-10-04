//
//  CoinManager.swift
//  CryptoCoin
//
//  Created by Izuchukwu Dennis on 10.08.2021.
//  Copyright © 2021 Izuchukwu Dennis. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didFailWIthError(error: Error)
    func didUpdateData(_ coinManager: CoinManager, cryptoCurrency: CryptoCurrencyData)
}


struct CoinData {
    let bitCoins: [String]
    let currencies: [String]
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    
    // let apiKey: String     //input apikey here
    let coinModel: CoinData = .init(
        bitCoins: ["BTC","ETH","DOGE"],
        currencies: ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    )
    
//    let currencyArray = [["BTC","ETH","DOGE"],["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]]

//    https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=1D95B99E-4703-45A0-A006-464FDA43F0EC
    
    
    
    var delegate: CoinManagerDelegate?
    
    func fetchData(crypto: String, currency: String) {
        let urlString = "\(baseURL)\(crypto)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
        
    }
    func performRequest(with urlString: String) {
        //        1. Create an URL
        //        2. Create an URLSession
        //        3. Give the session a break
        //        4. Start the task
        
        //        1. Create an URL
        if let url = URL(string: urlString){
            //        2. Create an URLSession
            let session = URLSession(configuration: .default)
            //        3. Give the session a break
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWIthError(error: error!)
                    return
                }
                if let safeData = data {
//                    _ = String(data: safeData, encoding: .utf8)
                    if let cryptoCurrency =  parseJSON(safeData){
                        self.delegate?.didUpdateData(self, cryptoCurrency: cryptoCurrency)
                        
                    }
                }
            }
            //        4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ cryptoData: Data) -> CryptoCurrencyData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CryptoCurrencyData.self, from: cryptoData)
            let crypto = decodedData.crypto
//            _ = decodedData.weather.first?.description ?? "nil"
            let currency = decodedData.currency
            let rate = decodedData.rate
            let currentRate = CryptoCurrencyData(rate: rate, crypto: crypto, currency: currency)

            return currentRate
        } catch {
            delegate?.didFailWIthError(error: error)
            return nil
        }
    }
}
