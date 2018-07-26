//
//  MagnitudePickerDataSource.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 25.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation
import UIKit

class MagnitudePickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var magnitudeData = ["All", "Significant"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return magnitudeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return magnitudeData[row]
    }

}
