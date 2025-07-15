//
//  Date+EXT.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 08/05/25.
//

import Foundation

extension Date {
    
    func convertToMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        return formatter.string(from: self)
    }
    
}
