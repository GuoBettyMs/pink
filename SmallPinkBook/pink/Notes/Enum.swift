//
//  Enum.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/16.
//
// https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html

import UIKit

// MARK: - 语法
enum CompassPoint {
    case north
    case south
    case east
    case west
}

/*
 
 var directionToHead: CompassPoint = .east
 directionToHead = .north
 
 */

// MARK: - 遍历
enum Beverage: CaseIterable {
    case coffee, tea, juice
}

/*
 
 let numberOfChoices = Beverage.allCases.count
 print("\(numberOfChoices) beverages available")     // Prints "3 beverages available"

 for beverage in Beverage.allCases {
     print(beverage)            // coffee, tea, juice
 }
 
 */

// MARK: - 原始值 Raw Values
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// ASCIIControlCharacter.tab.rawValue         //结果: “  ”

//隐式的给case赋原始值
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

/*
    Planet.earth.rawValue       //3
    Planet.uranus           //uranus
    Planet(rawValue: 7)     //uranus
*/
 
enum CompassPoint1: String {
    case north, south, east, west
}
//CompassPoint1.north.rawValue      //north

// MARK: - 关联值 Associated Values--数据后面跟的是元祖
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
//productBarcode = .qrCode("xxx")

/*
//判断并取出关联值(关联值绑定)--使用元祖的值分解方法,定义每个变量使之一一对应即可分别取出其中的值
switch productBarcode {
    case let .upc(numberSystem, manufacturer, product, check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .qrCode(let productCode):
        print("QR code: \(productCode).")      //QR code: xxx
}

//判断并取出关联值的简写
if case let .qrCode(productCode) = productBarcode{
    print(productCode)      //xxx
}
 
*/
