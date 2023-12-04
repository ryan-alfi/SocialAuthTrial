//
//  BaseViewModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

class BaseViewModel {
    
    var data: Loadable<Any> = .none {
        didSet {
            onDataChanged?(data)
        }
    }
    var onDataChanged: ((Loadable<Any>) -> Void)?
}
