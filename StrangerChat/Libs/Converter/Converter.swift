//
//  Converter.swift
//  Rize
//
//  Created by Hoang Chi Quan on 11/23/16.
//  Copyright © 2016 Vmodev. All rights reserved.
//

import UIKit

class Converter {
    static let shared = Converter()
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    final func number(from text: String, style: NumberFormatter.Style) -> NSNumber? {
        numberFormatter.numberStyle = style
        return numberFormatter.number(from: text)
    }
    
    // MARK: - Date
    
    final func date(from string: String, format: String) -> Date? {
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    final func string(from date: Date?, format: String) -> String? {
        if let date = date {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
        return nil
    }


}
