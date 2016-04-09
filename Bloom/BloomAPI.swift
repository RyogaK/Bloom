//
//  BloomAPI.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/9/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

private let ApiBaseURL: String = "https://bloom-api.herokuapp.com/"

struct TestResponse: Unboxable {
    let error: String?
    let result: Result
    
    init(unboxer: Unboxer) {
        error = unboxer.unbox("error")
        result = unboxer.unbox("result")
    }
    
    struct Result: Unboxable {
        let message: String
        let number: Int
        let numberlist: Array<Int>
        let stringlist: Array<String>
        
        init(unboxer: Unboxer) {
            message = unboxer.unbox("message")
            number = unboxer.unbox("number")
            numberlist = unboxer.unbox("numberlist")
            stringlist = unboxer.unbox("stringlist")
        }
    }
}

final class BloomAPI {
    static func testCall() {
        Alamofire.request(.GET, ApiBaseURL).responseJSON { (response) in
            if let resultValue = response.result.value as? UnboxableDictionary {
                let parsedValue: TestResponse? = Unbox(resultValue)
                print(parsedValue)
            }
        }
    }
}
