//
//  ViewModelType.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import SwiftUI
import Combine

protocol ViewModelType: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    
    func action(_ action: Action)
}
