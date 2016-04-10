//
//  PagingAPIController.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/10/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import Foundation
import SwiftTask

protocol PagingAPISource{
    associatedtype AssociatedType
    func callPagingAPI(beginId: Int?) -> Task<Void, AssociatedType, NSError>
}

class PagingAPIController<U:PagingAPISource> {
    let source: U
    var isLoading = false
    
    init(source: U) {
        self.source = source
    }
    
    func reload() -> Task<Void, U.AssociatedType, NSError>? {
        guard self.isLoading == false else {
            return nil
        }
        
        self.isLoading = true
        
        let task = source.callPagingAPI(nil)
        task.success {[unowned self] (_) in
            self.isLoading = false
        }.failure { (error, isCancelled) in
            self.isLoading = false
        }
        return task
    }
    
    func loadNext(beginId: Int) -> Task<Void, U.AssociatedType, NSError>? {
        guard self.isLoading == false else {
            return nil
        }
        
        self.isLoading = true
        
        let task = source.callPagingAPI(beginId)
        task.success {[unowned self] (_) in
            self.isLoading = false
        }
        return task
    }
}
