//
//  System-Extensions.swift
//  LittlePinkBook
//
//  Created by isdt on 2022/9/15.
//
/*
    基础扩展
 */

import UIKit
import DateToolsSwift
import AVFoundation


// MARK: -
extension Int{
    //将Int数据转为String类型进行显示
    var formattedStr: String{
        let num = Double(self)
        let tenThousand = num / 10_000                  //万
        let hundredMillion = num / 100_000_000          //亿
        
        if tenThousand < 1{
            return "\(self)"
        }else if hundredMillion >= 1{           
            return "\(round(hundredMillion * 10) / 10)亿"        //round函数 四舍五入
        }else{
            return "\(round(tenThousand * 10) / 10)万"
        }
    }
}
// MARK: -
extension String{
    
    //对空字符串进行判断:将空格和Newlines去掉后,是否有其他字符
    var isBlank: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    //matches 对电话号码进行判断是否符合 kPhoneRegEx 条件
    //Int(self) 判断String能不能转为Int,能则不为空
    var isPhoneNum: Bool{
        Int(self) != nil && NSRegularExpression(kPhoneRegEx).matches(self)
    }
    
    //matches 对验证码进行判断是否符合 kAuthCodeRegEx 条件
    //Int(self) 判断String能不能转为Int,能则不为空
    var isAuthCode: Bool{
        Int(self) != nil && NSRegularExpression(kAuthCodeRegEx).matches(self)
    }
    
    //验证密码规范性
    var isPassword: Bool{ NSRegularExpression(kPasswordRegEX).matches(self)}
    
    //随机字符串
    static func randomString(_ length: Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })        //随机从letters中取出一个,取length次
    }
    
    //拼接富文本,NSMutableAttributedString可修改String类型
    func spliceAttrStr(_ dateStr: String) -> NSMutableAttributedString{
        let attrText = toAttrStr()
        let attrDate = " \(dateStr)".toAttrStr(12, .secondaryLabel)
        attrText.append(attrDate)
        return attrText
    }
    
    //普通字符串转化为富文本
    func toAttrStr(_ fontSize: CGFloat = 14, _ color: UIColor = .label) -> NSMutableAttributedString{
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: color
        ]
        return NSMutableAttributedString(string: self, attributes: attr)
    }
   
    /// 富文本设置 字体大小 行间距 字间距
    func attributedString(font: UIFont, textColor: UIColor, lineSpaceing: CGFloat, wordSpaceing: CGFloat) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpaceing
        let attributes = [
                NSAttributedString.Key.font             : font,
                NSAttributedString.Key.foregroundColor  : textColor,
                NSAttributedString.Key.paragraphStyle   : style,
                NSAttributedString.Key.kern             : wordSpaceing]
            
            as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        
        // 设置某一范围样式
        // attrStr.addAttribute(<#T##name: NSAttributedString.Key##NSAttributedString.Key#>, value: <#T##Any#>, range: <#T##NSRange#>)
        return attrStr
    }
}

// MARK: -
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            fatalError("非法的正则表达式")//因不能确保调用父类的init函数
        }
    }
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
// MARK: -
//给可选String 进行安全解包
extension Optional where Wrapped == String{
    var unwrappedText: String { self ?? "" }
}
// MARK: -
extension Date{
    
    //本项目5种时间表示方式:
    //1.刚刚/5分钟前;2.今天21:10;3.昨天21:10;4.09-15;5.2019-09-15
    var formattedData: String{
        let currentYear = Date().year
        
        if year == currentYear{             //今年
            if isToday{                     //今天
                if minutesAgo > 10 {        //note发布(或存草稿)超过10分钟即显示'今天xx:xx'
                    return "今天\(format(with: "HH:mm"))"
                }else {
                    return timeAgoSinceNow  //刚刚note发布(或存草稿)
                }
            }else if isYesterday{           //昨天
                return "昨天\(format(with: "HH:mm"))"
            }else {                         //前天或更早的时间
                return format(with: "MM-dd")
            }
        }else if year < currentYear {       //去年或更早
            return format(with: "yyyy-MM-dd")
        }else {
            return "明年或更远,目前项目暂不会用到"
        }
    }
}
// MARK: -
extension URL{
    
    //从视频中生成封面图
    var thumbnail: UIImage{
        let asset = AVAsset(url: self)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //如果视频尺寸确定的话可以用下面这句提高处理性能
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return imagePH
        }
    }
}


 

    // MARK: -
extension Bundle{
    
    //TabBarC 文件中,33行,存图片进相册App的'我的相簿'里的文件夹名称
    var appName: String{
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String{
            return appName
        }else{
            return infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
    
    //静态属性和方法优点--1.直接用类名进行调用,2.省资源
    // MARK: static和class的区别
    //static能修饰class/struct/enum的存储属性、计算属性、方法;class能修饰类的计算属性和方法
    //static修饰的类方法不能继承；class修饰的类方法可以继承
    //在protocol中要使用static
    
    //加载xib上的view
    //为了更通用，使用泛型。as?后需接类型，故形式参数需为T.Type，实质参数为XXView.self--固定用法
    static func loadView<T>(fromNib name: String, with type: T.Type) -> T{
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T{
            return view
        }
        fatalError("加载\(type)类型的view失败")
    }
}

    // MARK: -
extension FileManager{
    
    // MARK: 添加url
    //对url添加子路径常用appendingPathComponent,对path添加就直接字符串拼接/插值
    //1.path转URL,URL转path
    //2.创建文件夹和文件时都需要先规定URL
    //3.一般都会使用fileExists先判断文件夹或文件是否存在
    func save(_ data: Data?, to dirName: String, as fileName: String) -> URL?{
        guard let data = data else {
//            print("要写入本地的data为nil")
            return nil
        }
        
        // MARK: 添加url - 创建沙盒文件夹 dirName
        //"file:///xx/xx/tmp/dirName"
        //这里的URL(fileURLWithPath: NSTemporaryDirectory())也可使用temporaryDirectory
 
        let dirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(dirName, isDirectory: true)
        if !fileExists(atPath: dirURL.path){
            guard let _ = try? createDirectory(at: dirURL, withIntermediateDirectories: true) else {
//                print("创建文件夹失败")
                return nil
            }
        }
        
        // MARK: 添加url - 写入文件
        //"file:///xx/xx/tmp/dirName/fileName"
        let fileURL = dirURL.appendingPathComponent(fileName)
        if !fileExists(atPath: fileURL.path){
            guard let _ =  try? data.write(to: fileURL) else {
//                print("写入/保存文件失败")
                return nil
            }
        }
        return fileURL
        
    }
}

extension UserDefaults{
    //草稿笔记递增1
    static func increase(_ key: String, by val:Int = 1){
        standard.set(standard.integer(forKey: key) + val, forKey: key)
    }
    
    //草稿笔记递减1
    static func decrease(_ key: String, by val:Int = 1){
        standard.set(standard.integer(forKey: key) - val, forKey: key)
    }
    
}
