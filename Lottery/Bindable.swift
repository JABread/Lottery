//
//  Binder.swift
//  Lottery
//
//  Created by 张俊安 on 2018/5/25.
//  Copyright © 2018年 Jon.Zhang. All rights reserved.
//

import Foundation

class Bindable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
