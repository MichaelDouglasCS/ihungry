//
//  FoodVO.swift
//  iHungry
//
//  Created by Michael Douglas on 21/01/17.
//  Copyright © 2017 Michael Douglas. All rights reserved.
//

import Foundation

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Struct -
//
//**************************************************************************************************

struct FoodVO {
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    var category: String?
    var name: String?
    var price: Double?
    var image: String?
    var quantity: Int?
    
    //*************************************************
    // MARK: - Constructors
    //*************************************************
    
    init() {
        
    }
    
    init(foodFromJSON: JSONDictionary) {
        self.category = foodFromJSON["category"] as? String
        self.name = foodFromJSON["name"] as? String
        self.price = foodFromJSON["price"] as? Double
        self.image = foodFromJSON["image"] as? String
        self.quantity = 0
    }
    
    init(foodFromObject: JSONDictionary) {
        self.category = foodFromObject["category"] as? String
        self.name = foodFromObject["name"] as? String
        self.price = foodFromObject["price"] as? Double
        self.image = foodFromObject["image"] as? String
        self.quantity = foodFromObject["quantity"] as? Int
    }
    
    //*************************************************
    // MARK: - Public Methods
    //*************************************************
    
    func getFoodTotalPrice() -> Double? {
        var result = Double()
        result = (self.price! * Double(self.quantity!))
        return result
    }
    
}
