//
//  ValidInputHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 24/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class ValidInputHelper{
    class func isValidUserName(tel: String) -> Bool{
        return tel.characters.count == 9
    }
    
    class func isValidPassword(password: String) -> Bool{
        return password.characters.count >= 0
    }
}
