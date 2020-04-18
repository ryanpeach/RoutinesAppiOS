//
//  SettingsBundleHelper.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/18/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import Foundation

class SettingsBundleHelper {

    class func getResetHour() -> Int {
        return UserDefaults.standard.integer(forKey: "DAY_START_HOUR")
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(build, forKey: "build_preference")
    }
}
