//
//  ViewControllerUtilities.swift
//  FlipTree
//
//  Created by Abishek Robin on 15/10/23.
//

import Foundation
import SwiftUI

/// A structure that holds a reference to a view controller.
public struct ViewControllerHolder {
    weak var value: UIViewController?
}

/// An environment key for accessing the view controller.
public struct ViewControllerKey: EnvironmentKey {
    
    /// The default value for `ViewControllerKey`.
    public static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

public extension EnvironmentValues {
    
    /// A property for accessing the view controller.
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    
    /// Presents a SwiftUI view as a modal within the current view controller.
    ///
    /// - Parameters:
    ///   - style: The presentation style for the modal view.
    ///   - transitionStyle: The transition style for the modal view.
    ///   - builder: A closure that builds the SwiftUI view to be presented.
    public func present<Content: View>(
        style: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        @ViewBuilder builder: () -> Content
    ) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.modalTransitionStyle = transitionStyle
        toPresent.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        self.present(toPresent, animated: true, completion: nil)
    }
}
