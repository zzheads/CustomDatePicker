//
//  ViewController.swift
//  DatePicker
//
//  Created by Алексей Папин on 16/03/2019.
//  Copyright © 2019 ZConcept. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var adapter = DateAdapter(self.pickerView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adapter.set(Date())
    }


}

