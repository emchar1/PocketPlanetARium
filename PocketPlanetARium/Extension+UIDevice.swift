//
//  Extension+UIDevice.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/8/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isiPad: Bool {
        return modelInfo.name.contains("iPad")
    }
    
    static var spriteScale: CGFloat {
        let scale: CGFloat
        
        switch modelInfo.ratio {
        case 19.5/9:    scale = 0.94    //2.1666666667 - iPhone 14 Pro
        case 16/9:      scale = 0.94    //1.777777778 - iPhone SE 3rd gen
        case 4.6/3:     scale = 0.84    //1.5333333333 - iPad mini 6th gen
        case 23/16:     scale = 0.8     //1.4375 - iPad 10th gen
        case 10/7:      scale = 0.79    //1.428571429 - iPad Pro 11" 4th gen
        case 4/3:       scale = 0.75    //1.333333333 - iPad 12.9" 6th gen
        default:        scale = 1       //New Device - need to define!!
        }
        
        return scale
    }
    
    static let modelInfo: (name: String, ratio: CGFloat, topSafeArea: CGFloat, bottomSafeArea: CGFloat) = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> (name: String, ratio: CGFloat, topSafeArea: CGFloat, bottomSafeArea: CGFloat) { // swiftlint:disable:this cyclomatic_complexity
            let safe: (top: CGFloat, btm: CGFloat) = (20, 40)
            let safeNew: (top: CGFloat, btm: CGFloat) = (200, 100)

            
            // TODO: - VERY IMPORTANT!!! ADD NEW iOS DEVICES AS THEY COME OUT!!!!!!
            #if os(iOS)
            switch identifier {
                
            //--iPHONES--
            case "iPod5,1":                                       return ("iPod touch (5th generation)", 16/9, safe.top, safe.btm)
            case "iPod7,1":                                       return ("iPod touch (6th generation)", 16/9, safe.top, safe.btm)
            case "iPod9,1":                                       return ("iPod touch (7th generation)", 16/9, safe.top, safe.btm)
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return ("iPhone 4", 4/3, safe.top, safe.btm)
            case "iPhone4,1":                                     return ("iPhone 4s", 4/3, safe.top, safe.btm)
            case "iPhone5,1", "iPhone5,2":                        return ("iPhone 5", 16/9, safe.top, safe.btm)
            case "iPhone5,3", "iPhone5,4":                        return ("iPhone 5c", 16/9, safe.top, safe.btm)
            case "iPhone6,1", "iPhone6,2":                        return ("iPhone 5s", 16/9, safe.top, safe.btm)
            case "iPhone7,2":                                     return ("iPhone 6", 16/9, safe.top, safe.btm)
            case "iPhone7,1":                                     return ("iPhone 6 Plus", 16/9, safe.top, safe.btm)
            case "iPhone8,1":                                     return ("iPhone 6s", 16/9, safe.top, safe.btm)
            case "iPhone8,2":                                     return ("iPhone 6s Plus", 16/9, safe.top, safe.btm)
            case "iPhone9,1", "iPhone9,3":                        return ("iPhone 7", 16/9, safe.top, safe.btm)
            case "iPhone9,2", "iPhone9,4":                        return ("iPhone 7 Plus", 16/9, safe.top, safe.btm)
            case "iPhone10,1", "iPhone10,4":                      return ("iPhone 8", 16/9, safe.top, safe.btm)
            case "iPhone10,2", "iPhone10,5":                      return ("iPhone 8 Plus", 16/9, safe.top, safe.btm)
            case "iPhone8,4":                                     return ("iPhone SE", 16/9, safe.top, safe.btm)
            case "iPhone12,8":                                    return ("iPhone SE (2nd generation)", 16/9, safe.top, safe.btm)
            case "iPhone14,6":                                    return ("iPhone SE (3rd generation)", 16/9, safe.top, safe.btm)
            case "iPhone10,3", "iPhone10,6":                      return ("iPhone X", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone11,2":                                    return ("iPhone XS", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone11,4", "iPhone11,6":                      return ("iPhone XS Max", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone11,8":                                    return ("iPhone XR", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone12,1":                                    return ("iPhone 11", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone12,3":                                    return ("iPhone 11 Pro", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone12,5":                                    return ("iPhone 11 Pro Max", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone13,1":                                    return ("iPhone 12 mini", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone13,2":                                    return ("iPhone 12", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone13,3":                                    return ("iPhone 12 Pro", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone13,4":                                    return ("iPhone 12 Pro Max", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone14,4":                                    return ("iPhone 13 mini", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone14,5":                                    return ("iPhone 13", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone14,2":                                    return ("iPhone 13 Pro", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone14,3":                                    return ("iPhone 13 Pro Max", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone14,7":                                    return ("iPhone 14", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone14,8":                                    return ("iPhone 14 Plus", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone15,2":                                    return ("iPhone 14 Pro", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone15,3":                                    return ("iPhone 14 Pro Max", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone15,4":                                    return ("iPhone 15", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone15,5":                                    return ("iPhone 15 Plus", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone16,1":                                    return ("iPhone 15 Pro", 19.5/9, safeNew.top, safeNew.btm)
            case "iPhone16,2":                                    return ("iPhone 15 Pro Max", 19.5/9, safeNew.top, safeNew.btm)
                
            //--iPADS--
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return ("iPad 2", 4/3, safe.top, safe.btm)
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return ("iPad (3rd generation)", 4/3, safe.top, safe.btm)
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return ("iPad (4th generation)", 4/3, safe.top, safe.btm)
            case "iPad6,11", "iPad6,12":                          return ("iPad (5th generation)", 4/3, safe.top, safe.btm)
            case "iPad7,5", "iPad7,6":                            return ("iPad (6th generation)", 4/3, safe.top, safe.btm)
            case "iPad7,11", "iPad7,12":                          return ("iPad (7th generation)", 4/3, safe.top, safe.btm)
            case "iPad11,6", "iPad11,7":                          return ("iPad (8th generation)", 4/3, safe.top, safe.btm)
            case "iPad12,1", "iPad12,2":                          return ("iPad (9th generation)", 4/3, safe.top, safe.btm)
            case "iPad13,18", "iPad13,19":                        return ("iPad (10th generation)", 23/16, safe.top, safe.btm) //**deviation
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return ("iPad Air", 4/3, safe.top, safe.btm)
            case "iPad5,3", "iPad5,4":                            return ("iPad Air 2", 4/3, safe.top, safe.btm)
            case "iPad11,3", "iPad11,4":                          return ("iPad Air (3rd generation)", 4/3, safe.top, safe.btm)
            case "iPad13,1", "iPad13,2":                          return ("iPad Air (4th generation)", 23/16, safe.top, safe.btm) //**deviation
            case "iPad13,16", "iPad13,17":                        return ("iPad Air (5th generation)", 23/16, safe.top, safe.btm) //**deviation
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return ("iPad mini", 4/3, safe.top, safe.btm)
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return ("iPad mini 2", 4/3, safe.top, safe.btm)
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return ("iPad mini 3", 4/3, safe.top, safe.btm)
            case "iPad5,1", "iPad5,2":                            return ("iPad mini 4", 4/3, safe.top, safe.btm)
            case "iPad11,1", "iPad11,2":                          return ("iPad mini (5th generation)", 4/3, safe.top, safe.btm)
            case "iPad14,1", "iPad14,2":                          return ("iPad mini (6th generation)", 4.6/3, safe.top, safe.btm) //**deviation
            case "iPad6,3", "iPad6,4":                            return ("iPad Pro (9.7-inch)", 4/3, safe.top, safe.btm)
            case "iPad7,3", "iPad7,4":                            return ("iPad Pro (10.5-inch)", 4/3, safe.top, safe.btm)
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return ("iPad Pro (11-inch) (1st generation)", 10/7, safe.top, safe.btm)
            case "iPad8,9", "iPad8,10":                           return ("iPad Pro (11-inch) (2nd generation)", 10/7, safe.top, safe.btm)
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return ("iPad Pro (11-inch) (3rd generation)", 10/7, safe.top, safe.btm)
            case "iPad14,3", "iPad14,4":                          return ("iPad Pro (11-inch) (4th generation)", 10/7, safe.top, safe.btm)
            case "iPad6,7", "iPad6,8":                            return ("iPad Pro (12.9-inch) (1st generation)", 4/3, safe.top, safe.btm)
            case "iPad7,1", "iPad7,2":                            return ("iPad Pro (12.9-inch) (2nd generation)", 4/3, safe.top, safe.btm)
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return ("iPad Pro (12.9-inch) (3rd generation)", 4/3, safe.top, safe.btm)
            case "iPad8,11", "iPad8,12":                          return ("iPad Pro (12.9-inch) (4th generation)", 4/3, safe.top, safe.btm)
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return ("iPad Pro (12.9-inch) (5th generation)", 4/3, safe.top, safe.btm)
            case "iPad14,5", "iPad14,6":                          return ("iPad Pro (12.9-inch) (6th generation)", 4/3, safe.top, safe.btm)
                
            //--MISC DEVICES--
            case "AppleTV5,3":                                    return ("Apple TV", 16/9, safe.top, safe.btm)
            case "AppleTV6,2":                                    return ("Apple TV 4K", 16/9, safe.top, safe.btm)
            case "AudioAccessory1,1":                             return ("HomePod", 16/9, safe.top, safe.btm)
            case "AudioAccessory5,1":                             return ("HomePod mini", 16/9, safe.top, safe.btm)
            case "i386", "x86_64", "arm64":
                return mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS")
              
            //--DEFAULT CASE--
            default:
                if identifier.contains("iPad") {
                    return (identifier, 4/3, safe.top, safe.btm)
                }
                else {
                    return (identifier, 19.5/9, safeNew.top, safeNew.btm)
                }
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return ("Apple TV 4", 16/9, safe.top, safe.btm)
            case "AppleTV6,2": return ("Apple TV 4K", 16/9, safe.top, safe.btm)
            case "i386", "x86_64": return mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS")
            default: return (identifier, 0, 0, 0)
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
