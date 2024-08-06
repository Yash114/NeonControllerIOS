//
//  PremiumController.swift
//  Neon Controller
//
//  Created by Yashua Evans on 11/21/23.
//

import Foundation
import StoreKit

class PremiumController : NSObject, SKProductsRequestDelegate, SKRequestDelegate {
    
    var productsRequest : SKProductsRequest?
    var products = [String : SKProduct]()
    
    func fetchProducts() {
        let productIdentifiers = Set(["yearly_premium_100", "monthly_premium_10", "weekly_premium"])
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
        print("fetching")

    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("recieved something: \(response.products.count)")
        
        for product in response.products {
            print("Product: \(product.localizedTitle) - \(product.price)")
            
            products.updateValue(product, forKey: product.localizedTitle)
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func requestDidFinish(_ request: SKRequest) {
        print("Done requesting")
    }
    
    func purchase(product: String) {
        
        if let product = products[product] {

            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            
        } else {
            
            print("invalid product")
        }
    }
    
}
