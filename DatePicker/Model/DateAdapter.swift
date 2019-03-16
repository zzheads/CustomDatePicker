//
//  DateAdapter.swift
//  DatePicker
//
//  Created by Алексей Папин on 16/03/2019.
//  Copyright © 2019 ZConcept. All rights reserved.
//

import UIKit

class DateAdapter: NSObject {
    static let maxRows = 10000
    
    let pickerView          : UIPickerView
    var date                : Date
    let calendar            : Calendar = Calendar.current
    let adapterComponents   : [Calendar.Component] = [.day, .month, .year]
    var attributes          : [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .semibold), .foregroundColor: UIColor.darkGray]

    init(_ pickerView: UIPickerView, date: Date = Date()) {
        self.pickerView = pickerView
        self.date = date
        super.init()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    func maxValue(for component: Calendar.Component) -> Int {
        switch component {
        case .day   : return 31
        case .month : return 12
        case .year  : return DateAdapter.maxRows
        default     : return 0
        }
    }
    
    func middleRow(from component: Calendar.Component, value: Int) -> Int {
        let middle = Int(DateAdapter.maxRows / (maxValue(for: component) * 2))
        return middle * maxValue(for: component) + value - 1
    }
    
    func set(_ date: Date) {
        let day = self.calendar.component(.day, from: date)
        let month = self.calendar.component(.month, from: date)
        let year = self.calendar.component(.year, from: date)
        
        self.pickerView.selectRow(middleRow(from: .day, value: day), inComponent: 0, animated: true)
        self.pickerView.selectRow(middleRow(from: .month, value: month), inComponent: 1, animated: true)
        self.pickerView.selectRow(year, inComponent: 2, animated: true)
    }
    
    var currentDate: Date? {
        let day = self.pickerView.selectedRow(inComponent: 0) % 31 + 1
        let month = self.pickerView.selectedRow(inComponent: 1) % 12 + 1
        let year = self.pickerView.selectedRow(inComponent: 2)
        let dateComponents = DateComponents(calendar: self.calendar, timeZone: TimeZone.current, era: nil, year: year, month: month, day: day, hour: 12, minute: 12, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        return self.calendar.date(from: dateComponents)
    }
}

extension DateAdapter: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.adapterComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DateAdapter.maxRows
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch self.adapterComponents[component] {
        case .day   : return NSAttributedString(string: "\(row % 31 + 1)", attributes: self.attributes)
        case .month : return NSAttributedString(string: self.calendar.monthSymbols[row % 12], attributes: self.attributes)
        case .year  : return NSAttributedString(string: "\(row)", attributes: self.attributes)
        default     : return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let date = self.currentDate else {
            print("Wrong date detected!")
            return
        }
        print(date)
        if self.calendar.component(.day, from: date) != pickerView.selectedRow(inComponent: 0) % 31 + 1 {
            set(date)
        }
    }
}
