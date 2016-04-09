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
import SwiftTask

private let ApiBaseURL: String = "https://bloom-api.herokuapp.com"

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
        let numberList: Array<Int>
        let stringList: Array<String>
        
        init(unboxer: Unboxer) {
            message = unboxer.unbox("message")
            number = unboxer.unbox("number")
            numberList = unboxer.unbox("numberlist")
            stringList = unboxer.unbox("stringlist")
        }
    }
}

final class BloomAPI {
    static func testCall() -> Task<Void, TestResponse, NSError> {
        return Task<Void, TestResponse, NSError> { progress, fulfill, reject, configure in
            Alamofire.request(.GET, ApiBaseURL).responseJSON { (response) in
                if response.result.isSuccess {
                    if let resultValue = response.result.value as? UnboxableDictionary {
                        if let parsedValue: TestResponse = Unbox(resultValue) {
                            fulfill(parsedValue)
                        } else {
                            assertionAPIIsBroken()
                        }
                    } else {
                        assertionAPIIsBroken()
                    }
                } else if let error = response.result.error {
                    printErrorResponse(response)
                    reject(error)
                } else {
                    assertionAPIIsBroken()
                }
            }
        }
    }
}

extension BloomAPI {
    struct SigninResponse: Unboxable {
        let user: User
        
        init(unboxer: Unboxer) {
            self.user = unboxer.unbox("user")
        }
        
        struct User: Unboxable {
            let id: String
            let name: String
            let imageURL: String
            
            init(unboxer: Unboxer) {
                self.id = unboxer.unbox("id")
                self.name = unboxer.unbox("name")
                self.imageURL = unboxer.unbox("image_url")
            }
        }
    }
    
    static func signin(organizationName: String, email: String, password: String) -> Task<Void, SigninResponse, NSError> {
        return Task<Void, SigninResponse, NSError> { progress, fulfill, reject, configure in
            Alamofire.request(.POST, ApiBaseURL + "/auth/signin", parameters: ["organization_name":organizationName, "email":email, "password":password], encoding: .JSON, headers: ["token":"dummytoken"]).responseJSON { (response) in
                if response.result.isSuccess {
                    if let resultValue = response.result.value as? UnboxableDictionary {
                        if let parsedValue: SigninResponse = Unbox(resultValue) {
                            fulfill(parsedValue)
                        } else {
                            assertionAPIIsBroken()
                        }
                    } else {
                        assertionAPIIsBroken()
                    }
                } else if let error = response.result.error {
                    printErrorResponse(response)
                    reject(error)
                } else {
                    assertionAPIIsBroken()
                }
            }
        }
    }
}

private func assertionAPIIsBroken() {
    assertionFailure("API is broken")
}

private func printErrorResponse(response: Response<AnyObject, NSError>) {
    print("status:\(response.response!.statusCode) error:\(response.result.error!)")
}
