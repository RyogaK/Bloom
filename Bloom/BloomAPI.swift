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
}

extension BloomAPI {
    struct SigninResponse: Unboxable {
        let user: User
        let token: String
        
        init(unboxer: Unboxer) {
            self.user = unboxer.unbox("user")
            self.token = unboxer.unbox("token")
        }
        
        struct User: Unboxable {
            let id: Int
            let name: String
            let imageURL: String?
            
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
                guard let httpResponse = response.response else {
                    assertionAPIIsBroken()
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let error = response.result.error {
                        printErrorResponse(response)
                        reject(error)
                    } else {
                        if let resultValue = response.result.value as? UnboxableDictionary {
                            do {
                                let parsedValue: SigninResponse = try UnboxOrThrow(resultValue)
                                fulfill(parsedValue)
                            } catch let error as NSError {
                                assertionAPIIsBroken(error)
                            }
                        } else {
                            assertionAPIIsBroken()
                        }
                    }
                    break
                case 400:
                    reject(NSError(domain: "Bad request", code: httpResponse.statusCode, userInfo: nil))
                    break
                case 404:
                    reject(NSError(domain: "Not found", code: httpResponse.statusCode, userInfo: nil))
                    break
                default:
                    assertionAPIIsBroken()
                    break
                }
            }
        }
    }
}

private func assertionAPIIsBroken() {
    assertionFailure("API is broken")
}

private func assertionAPIIsBroken(error: NSError) {
    assertionFailure("API is broken: \(error)")
}

private func printErrorResponse(response: Response<AnyObject, NSError>) {
    print("status:\(response.response!.statusCode) error:\(response.result.error!)")
}
