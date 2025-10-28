import UIKit

enum AppColor {
    static let primary = UIColor(named: "PrimaryAppColor")!
    static let background = UIColor(named: "BackgroundColor")!
    static let title = UIColor(named: "TitleColor")!
    static let body = UIColor(named: "BodyColor")!
    static let primaryButton = UIColor(named: "PrimaryButtonColor")!
    static let primaryButtonDisabled = UIColor(named: "PrimaryButtonDisabledColor")!
    static let secondaryButton = UIColor(named: "SecondaryButtonColor")!
    static let secondaryButtonDisabled = UIColor(named: "SecondaryButtonDisabledColor")!
    static let divider = UIColor(named: "DividerColor")!
    static let success = UIColor(named: "SuccessColor")!
    static let error = UIColor(named: "ErrorColor")!
    static let warning = UIColor(named: "WarningColor")!
}

import SwiftUI

struct AppColorSUI {
    static let primary = Color("PrimaryAppColor")
    static let background = Color("BackgroundColor")
    static let title = Color("TitleColor")
    static let body = Color("BodyColor")
    static let primaryButton = Color("PrimaryButtonColor")
    static let primaryButtonDisabled = Color("PrimaryButtonDisabledColor")
    static let secondaryButton = Color("SecondaryButtonColor")
    static let secondaryButtonDisabled = Color("SecondaryButtonDisabledColor")
    static let divider = Color("DividerColor")
    static let success = Color("SuccessColor")
    static let error = Color("ErrorColor")
    static let warning = Color("WarningColor")
}
