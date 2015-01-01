//
//  CountryCurrency.swift
//  tips
//
//  Created by Chen, Anthony on 12/28/14.
//  Copyright (c) 2014 Chen, Anthony. All rights reserved.
//

import Foundation

// Given a country name, return the currency symbol
func getCurrencyForCountry(country: String) -> String {
  switch country {
  case "United States":
    return "$"
  case "China", "Japan":
    return "¥"
  case "France", "Germany":
    return "€"
  default:
    return "$"
  }
}