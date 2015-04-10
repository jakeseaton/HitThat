//
//  Colors.swift
//  HitThat
//
//  Created by Jake Seaton on 3/31/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation
struct Colors{

    static let color1 = UIColor(red:255/255, green:136/255, blue:74/255, alpha:1.0)
    static let color2 = UIColor(red: 255/255, green: 47/255, blue: 0/255, alpha: 1.0)

    // static let color1 = UIColor(red:255/255, green:138/255, blue:119/255, alpha:1.0)
    // static let color2 = UIColor(red: 210/255, green: 22/255, blue: 30/255, alpha: 1.0)
    static let navBarTintColor = color1 //UIColor.redColor()
    //    static let navBarTintColor = UIColor(red:255/255, green:136/255, blue:74/255, alpha:1.0)
        //    static let navbarTintColor = UIColor(red: 255.0/255, green: 168.0/255, blue: 69.0/255, alpha: 0.5)
    //    static let tabbarBarTintColor = UIColor(red: 255.0/255, green: 168.0/255, blue: 69.0/255, alpha: 0.5)
    //    static let navbarTintColor = UIColor(red: 35/255, green: 194/255, blue: 255/255, alpha: 1)
    static let navbarTintColor = UIColor.yellowColor()
    static let tabbarBarTintColor = UIColor(red: 35/255, green: 194/255, blue: 255/255, alpha: 1)
    //    static let tabbarTintColor = UIColor.whiteColor()
    static let tabbarTintColor = UIColor(red: 254/255, green:220/255, blue: 64/255, alpha: 1)
    
    static let TurquoiseColor = UIColor(red: 0.10196078431372549, green: 0.7372549019607844, blue: 0.611764705882353, alpha: 1.0)
    static let GreenSeaColor = UIColor(red:0.08627450980392157, green: 0.6274509803921569, blue: 0.5215686274509804, alpha: 1.0)
    static let EmeraldColor = UIColor(red:0.1803921568627451, green: 0.8, blue:0.44313725490196076, alpha: 1.0)
    static let NephritisColor = UIColor(red:0.15294117647058825, green: 0.6823529411764706, blue:0.3764705882352941, alpha: 1.0)
    static let PeterRiverColor = UIColor(red:0.20392156862745098, green: 0.596078431372549, blue:0.8588235294117647, alpha: 1.0)
    static let BelizeHoleColor = UIColor(red:0.1607843137254902, green: 0.5019607843137255, blue:0.7254901960784313, alpha: 1.0)
    static let AmethystColor = UIColor(red:0.6078431372549019, green: 0.34901960784313724, blue:0.7137254901960784, alpha: 1.0)
    static let WisteriaColor = UIColor(red: 0.5568627450980392, green: 0.26666666666666666, blue:0.6784313725490196, alpha: 1.0)
    static let WetAsphaltColor = UIColor(red:0.20392156862745098, green: 0.28627450980392155, blue:0.3686274509803922, alpha: 1.0)
    static let MidnightBlueColor = UIColor(red:0.17254901960784313, green: 0.24313725490196078, blue:0.3137254901960784, alpha: 1.0)
    static let SunFlowerColor = UIColor(red:0.9450980392156862, green: 0.7686274509803922, blue:0.058823529411764705, alpha: 1.0)
    static let OrangeColor = UIColor(red:0.9529411764705882, green: 0.611764705882353, blue:0.07058823529411765, alpha: 1.0)
    static let CarrotColor = UIColor(red:0.9019607843137255, green: 0.49411764705882355, blue:0.13333333333333333, alpha: 1.0)
    static let PumpkinColor = UIColor(red: 0.9058823529411765, green: 0.2980392156862745, blue:0.23529411764705882, alpha: 1.0)
    static let AlizarinColor = UIColor(red: 0.9058823529411765, green: 0.2980392156862745, blue:0.23529411764705882, alpha: 1.0)
    static let PomegranateColor = UIColor(red:0.7529411764705882, green: 0.2235294117647059, blue:0.16862745098039217, alpha: 1.0)
    static let CloudsColor = UIColor(red:0.9254901960784314, green: 0.9411764705882353, blue:0.9450980392156862, alpha: 1.0)
    static let SilverColor = UIColor(red:0.7411764705882353, green: 0.7647058823529411, blue:0.7803921568627451, alpha: 1.0)
    static let ConcreteColor = UIColor(red: 0.5843137254901961, green:0.6470588235294118, blue: 0.6509803921568628, alpha: 1.0)
    static let AsbestosColor = UIColor(red: 0.4980392156862745, green: 0.5490196078431373, blue: 0.5529411764705883, alpha: 1.0)
    static let ColorsArray = [Colors.TurquoiseColor, Colors.GreenSeaColor, Colors.EmeraldColor, Colors.NephritisColor, Colors.PeterRiverColor, Colors.BelizeHoleColor, Colors.AmethystColor, Colors.WisteriaColor, Colors.WetAsphaltColor, Colors.MidnightBlueColor, Colors.SunFlowerColor, Colors.OrangeColor, Colors.CarrotColor, Colors.PumpkinColor, Colors.AlizarinColor, Colors.PomegranateColor, Colors.CloudsColor, Colors.SilverColor, Colors.ConcreteColor, Colors.AsbestosColor]
    var versusLabelTextColor:UIColor{
        get{
            return Colors.ColorsArray.randomItem()
        }
    }
    func gradient(vc: UIViewController){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [Colors.color1.CGColor, Colors.color2.CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: vc.view.frame.size.width, height: vc.view.frame.size.height)
        vc.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    func configureStaminaBar(bar:YLProgressBar){
        bar.hideStripes = true
        bar.indicatorTextLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        bar.progressTintColors = [Colors.color1, Colors.color2]
        bar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.Progress
    }
    func favoriteBackGroundColor(vc:UIViewController){
        vc.view.backgroundColor = Colors.color1 //Colors.SilverColor
    }
}
