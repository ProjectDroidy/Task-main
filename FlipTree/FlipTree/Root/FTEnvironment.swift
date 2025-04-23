//
//  FTEnvironment.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation
import SwiftUI

/// An environment class responsible for managing FlipTree app settings and states.
class FTEnvironment: ObservableObject {
    
    /// An AppStorage property that stores whether a session has been created.
    @AppStorage("session_created")
    var sSessionCreated = false
    
    /// A published property that indicates whether the session has started.
    @Published
    var sessionStarted = false
}

