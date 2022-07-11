//
//      2022  Betty Godier
//      Coding challenge
//

import SwiftUI

final class AlertView {
    var title: String
    var message: String
    var primaryButton: Alert.Button

    init(title: String = "Error",
         message: String = "Due to a network issue, you are unable load places at this time",
         primaryButton: Alert.Button = .default(Text("OK"))) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
    }
}

extension Alert.Button {
    static func `default`(_ label: String, action: (() -> Void)? = nil) -> Alert.Button {
        .default(Text(label), action: action)
    }
}

extension Alert {
    init(view: AlertView) {
        self.init(title: Text(view.title),
             message: Text(view.message),
             dismissButton: view.primaryButton)
    }
}
