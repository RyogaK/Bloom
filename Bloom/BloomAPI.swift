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
//private let ApiBaseURL: String = "http://172.24.245.106:3000"

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
        let organization: Organization
        
        init(unboxer: Unboxer) {
            self.user = unboxer.unbox("user")
            self.token = unboxer.unbox("token")
            self.organization = unboxer.unbox("organization")
        }
        
        struct User: Unboxable {
            let id: Int
            let email: String
            let name: String
            let imageURL: String?
            
            init(unboxer: Unboxer) {
                self.id = unboxer.unbox("id")
                self.email = unboxer.unbox("email")
                self.name = unboxer.unbox("name")
                self.imageURL = unboxer.unbox("image_url")
            }
        }
        
        struct Organization: Unboxable {
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

extension BloomAPI {
    static func postFlowers(userId: Int, receiverId: Int, flowerName: String, message: String?) -> Task<Void, Void, NSError> {
        var params : [String:AnyObject] = ["sender_id": userId, "flower_name": flowerName]
        if let message = message {
            params["message"] = message
        }
        
        return Task<Void, Void, NSError> { progress, fulfill, reject, configure in
            Alamofire.request(.POST, ApiBaseURL + "/users/\(receiverId)/flowers", parameters: params, encoding: .JSON, headers: ["token":"dummytoken"]).responseJSON { (response) in
                guard let httpResponse = response.response else {
                    assertionAPIIsBroken()
                    return
                }
                
                switch httpResponse.statusCode {
                case 201:
                    if let error = response.result.error {
                        printErrorResponse(response)
                        reject(error)
                    } else {
                        fulfill()
                    }
                    break
                default:
                    assertionAPIIsBroken()
                    break
                }
            }
        }
    }
}

extension BloomAPI {
    struct OrganizationFlowersResponse: Unboxable {
        let send: Array<Send>
        
        init(unboxer: Unboxer) {
            self.send = unboxer.unbox("send")
        }
        
        struct Send: Unboxable {
            let sendId: Int
            let flowerName: String
            let message: String?
            let sendDate: NSDate
            
            init(sendId: Int, flowerName: String, message: String?, sendDate: NSDate) {
                self.sendId = sendId
                self.message = message
                self.flowerName = flowerName
                self.sendDate = sendDate
            }
            
            init(unboxer: Unboxer) {
                self.sendId = unboxer.unbox("send_id")
                self.flowerName = unboxer.unbox("flower_name")
                self.message = unboxer.unbox("message")
                let formatter = NSDateFormatter()
                formatter.dateFormat = "YYYY:MM:DD"
                self.sendDate = unboxer.unbox("send_date", formatter:formatter)
            }
        }
    }
    
    static func organizationFlowers(organizationId: Int, beginId: Int?) -> Task<Void, OrganizationFlowersResponse?, NSError> {
        var params = [String:AnyObject]()
        if let beginId = beginId {
            params["begin_id"] = beginId
        }
        
        return Task<Void, OrganizationFlowersResponse?, NSError> { progress, fulfill, reject, configure in
            Alamofire.request(.GET, ApiBaseURL + "/organizations/\(organizationId)/flowers", parameters: params, encoding: .JSON, headers: ["token":"dummytoken"]).responseJSON { (response) in
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
                                let parsedValue: OrganizationFlowersResponse = try UnboxOrThrow(resultValue)
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
//    assertionFailure("API is broken")
}

private func assertionAPIIsBroken(error: NSError) {
    assertionFailure("API is broken: \(error)")
}

private func printErrorResponse(response: Response<AnyObject, NSError>) {
    print("status:\(response.response!.statusCode) error:\(response.result.error!)")
}
