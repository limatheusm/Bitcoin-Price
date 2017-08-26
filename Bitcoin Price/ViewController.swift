//
//  ViewController.swift
//  Bitcoin Price
//
//  Created by Matheus Lima on 8/26/17.
//  Copyright © 2017 Matheus Lima. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recoveryPrice()
    }
    
    
    @IBAction func updatePrice(_ sender: Any) {
        self.recoveryPrice()
    }
    
    func recoveryPrice() {
        
        self.updateButton.setTitle("Atualizando...", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            // Executando ate obter um retorno
            let task = URLSession.shared.dataTask(with: url) { (data, request, error) in
                if error == nil {
                    // print("Sucesso ao fazer a consulta")
                    if let returnData = data {
                        do {
                            if let objectJson = try JSONSerialization.jsonObject(with: returnData, options: []) as? [String: Any] {
                                if let brl = objectJson["BRL"] as? [String: Any] {
                                    // print(brl)
                                    if let buyPrice = brl["buy"] as? Double {
                                        let priceFormatted = self.priceFormatter(NSNumber(value: buyPrice))
                                        DispatchQueue.main.async(execute: {
                                            self.bitcoinPrice.text = "R$ " + priceFormatted
                                            self.updateButton.setTitle("Atualizar", for: .normal)
                                        })
                                    }
                                }
                            }
                        }
                        catch {
                            print("Erro ao formatar o Retorno")
                        }
                    }
                }
                else {
                    print("Erro ao fazer a consulta")
                }
            }
            
            task.resume() // Inicia requisicao
        }
    }
    
    func priceFormatter(_ price: NSNumber) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let stringPrice = nf.string(from: price) {
            return stringPrice
        }
        
        return "0,00"
    }

    


}

