//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Michael Gimara on 30/03/2019.
//  Copyright © 2019 Michael Gimara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - Constants
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray =
    [
        "AUD","BRL","CAD","CNY","EUR","GBP","HKD",
        "IDR","ILS","INR","JPY","MXN","NOK","NZD",
        "PLN","RON","RUB","SEK","SGD","USD","ZAR"
    ]
    
    let currencySymbols =
    [
        "$", "R$", "$", "¥", "€", "£", "$",
        "Rp", "₪", "₹", "¥", "$", "kr", "$",
        "zł", "lei", "₽", "kr", "$", "$", "R"
    ]
    
    //MARK: - Variables
    var finalURL = ""

    //MARK: - Outlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        finalURL = baseURL + currencyArray[0]
        getBitcoinCurrencyData(url: finalURL)
    }
    
    //MARK: - UIPickerView DataSource & Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinCurrencyData(url: finalURL)
    }

    //MARK: - Networking
    func getBitcoinCurrencyData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let currencyJSON: JSON = JSON(response.result.value!) // value != nil for sure!
                print("Success! Got the bitcoin currency data")
                self.updateCurrencyData(json: currencyJSON)
                
            } else if response.result.isFailure {
                if let error = response.result.error {
                    print("Error: \(error.localizedDescription)")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
        }
    }

    //MARK: - JSON Parsing
    func updateCurrencyData(json: JSON) {
        let lastCurrency = json["last"].doubleValue
        updateUIWithCurrencyData(currency: lastCurrency)
    }
    
    //MARK: - UI Updates
    func updateUIWithCurrencyData(currency: Double) {
        let currencySymbol = currencySymbols[currencyPicker.selectedRow(inComponent: 0)]
        self.bitcoinPriceLabel.text = "\(currencySymbol)\(currency)"
    }
}

