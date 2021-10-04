//
//  ViewController.swift
//  CryptoCoin
//
//  Created by Izuchukwu Dennis on 10.08.2021.
//

import UIKit


extension ViewController {
    enum UIPickerSections: Int {
        case bitCoinSection = 0
        case currenciesSection = 1
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var cryptoSymbol: UIImageView!
    @IBOutlet weak var cryptoAndCurrencyPicker: UIPickerView!
    
//    instance initialization
    var coinManager = CoinManager()
   
    
//    var and const initialization
    private var crypto = "BTC"
    private var currency = "AUD"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cryptoAndCurrencyPicker.delegate = self
        self.cryptoAndCurrencyPicker.dataSource = self
        self.coinManager.delegate = self
    }
    
    func updateUI(with data: CryptoCurrencyData){
        var cryptoImage: UIImage? {
            if data.crypto == "BTC" {return UIImage(systemName: "bitcoinsign.circle.fill")
                
            }else if data.crypto == "ETH" {
                return UIImage(named: "ethereum.icons8")
            }else {
                return UIImage(named: "dogecoin.icons8")
            }
        }
//        currencyLabel
        currencyLabel.text = data.currency
//        cryptoSymbol
        cryptoSymbol.image = cryptoImage
        
        currentValue.text = String(format: "%.2f" , data.rate)
      
        
    }


}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
//    number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
//    number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let section = UIPickerSections(rawValue: component) else { return 0 }
        
        switch section {
        case .bitCoinSection:
            return coinManager.coinModel.bitCoins.count
        case .currenciesSection:
            return coinManager.coinModel.currencies.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let section = UIPickerSections(rawValue: component) else { return nil }
        switch section {
        case .bitCoinSection:
            return coinManager.coinModel.bitCoins[row]
        case .currenciesSection:
            return coinManager.coinModel.currencies[row]
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        guard let section = UIPickerSections(rawValue: component) else { return }
        switch section {
        case .bitCoinSection:
            crypto = coinManager.coinModel.bitCoins[row]
        case .currenciesSection:
            currency = coinManager.coinModel.currencies[row]
        }
        coinManager.fetchData(crypto: crypto, currency: currency)
//        print(coinManager.currencyArray[component][row])
//        print ("Currency = \(currency); Crypto = \(crypto)")
        // The parameter named row and component represents what was selected.
    }

}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didFailWIthError(error: Error) {
        print(error)
    }
    
    func didUpdateData(_ coinManager: CoinManager, cryptoCurrency: CryptoCurrencyData) {
        DispatchQueue.main.async {
            self.updateUI(with: cryptoCurrency)
        }
       
    }
    
    
}

