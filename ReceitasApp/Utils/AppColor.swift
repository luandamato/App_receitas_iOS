import UIKit

enum AppColor {
    static let primary = UIColor(named: "PrimaryColor")!
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

extension UIButton {
    func applyPrimaryStyle() {
        self.backgroundColor = AppColor.primaryButton
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 10
    }

    func applySecondaryStyle() {
        self.backgroundColor = AppColor.secondaryButton
        self.setTitleColor(AppColor.primary, for: .normal)
        self.layer.cornerRadius = 10
    }
}

extension UIView {
    func applyBackgroundStyle() {
        self.backgroundColor = AppColor.background
    }
}

extension UILabel {
    func applyTitleStyle() {
        self.textColor = AppColor.title
        self.font = UIFont.boldSystemFont(ofSize: 22)
    }

    func applyBodyStyle() {
        self.textColor = AppColor.body
        self.font = UIFont.systemFont(ofSize: 16)
    }
}
