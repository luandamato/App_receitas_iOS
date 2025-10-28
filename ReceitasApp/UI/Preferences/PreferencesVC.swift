//
//  PreferencesVC.swift
//  Recipes
//
//  Created by Luan Damato on 23/10/25.
//

import UIKit

final class PreferencsVC: BaseViewController {
    private enum Keys {
        static let language = "prefs_language"
        static let darkMode = "prefs_darkMode"
        static let notifications = "prefs_notifications"
    }
    
    private let languages = ["Português", "English"]
    
    private var darkModeEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.darkMode) }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.darkMode) }
    }
    private var notificationsEnabled: Bool {
        get { UserDefaults.standard.object(forKey: Keys.notifications) as? Bool ?? true }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.notifications) }
    }
    private var selectedLanguage: String {
        get { UserDefaults.standard.string(forKey: Keys.language) ?? languages.first! }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.language) }
    }
    
    //MARK: - UI
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewLanguage: CustomEditText = {
        let view = CustomEditText(titulo: "Idioma")
        view.type = .search
        view.enable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLanguagePicker))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewMode: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblMode: CustomLabel = {
        let view = CustomLabel(text: "Modo escuro", type: .body)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var swtMode: UISwitch = {
        let view = UISwitch()
        view.tintColor = AppColor.primary
        view.addTarget(self, action: #selector(toolgeMode), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewNotification: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblNotification: CustomLabel = {
        let view = CustomLabel(text: "Notificações", type: .body)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var swtNotification: UISwitch = {
        let view = UISwitch()
        view.tintColor = AppColor.primary
        view.addTarget(self, action: #selector(toolgeNotification), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(title: String.stringFor(text: .preferences))
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        
        [viewLanguage, viewMode, viewNotification].forEach {
            contentContainer.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SizeConstants.mediumMargin),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SizeConstants.mediumMargin),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SizeConstants.bigMargin),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            viewLanguage.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: SizeConstants.mediumMargin),
            viewLanguage.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            viewLanguage.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),

            viewMode.topAnchor.constraint(equalTo: viewLanguage.bottomAnchor, constant: SizeConstants.smallMargin),
            viewMode.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            viewMode.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),

            viewNotification.topAnchor.constraint(equalTo: viewMode.bottomAnchor, constant: SizeConstants.smallMargin),
            viewNotification.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            viewNotification.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            viewNotification.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: SizeConstants.bigMargin)
        ])
        
        viewMode.addSubview(lblMode)
        viewMode.addSubview(swtMode)
        NSLayoutConstraint.activate([
            lblMode.leadingAnchor.constraint(equalTo: viewMode.leadingAnchor),
            lblMode.centerXAnchor.constraint(equalTo: viewMode.centerXAnchor),
            
            swtMode.topAnchor.constraint(equalTo: viewMode.topAnchor, constant: SizeConstants.xSmallMargin),
            swtMode.trailingAnchor.constraint(equalTo: viewMode.trailingAnchor),
            swtMode.bottomAnchor.constraint(equalTo: viewMode.bottomAnchor, constant: -SizeConstants.xSmallMargin)
        ])
        
        viewNotification.addSubview(lblNotification)
        viewNotification.addSubview(swtNotification)
        NSLayoutConstraint.activate([
            lblNotification.leadingAnchor.constraint(equalTo: viewNotification.leadingAnchor),
            lblNotification.trailingAnchor.constraint(greaterThanOrEqualTo: swtMode.leadingAnchor),
            lblNotification.centerXAnchor.constraint(equalTo: viewNotification.centerXAnchor),
            
            swtNotification.topAnchor.constraint(equalTo: viewNotification.topAnchor, constant: SizeConstants.xSmallMargin),
            swtNotification.trailingAnchor.constraint(equalTo: viewNotification.trailingAnchor),
            swtNotification.bottomAnchor.constraint(equalTo: viewNotification.bottomAnchor, constant: -SizeConstants.xSmallMargin)
        ])
    }
    
    @objc func openLanguagePicker() {
        let alert = UIAlertController(title: "Selecione o idioma", message: nil, preferredStyle: .actionSheet)
        
        for lang in languages {
            let action = UIAlertAction(title: lang, style: .default) { _ in
                self.selectedLanguage = lang
                // aqui você pode disparar lógica para aplicar tradução, etc.
                print("Idioma selecionado:", lang)
            }
            // marca check no item selecionado (opcional visual)
            if lang == selectedLanguage {
                action.setValue(true, forKey: "checked") // não público, apenas tentativa visual em alguns iOS; não obrigatório
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        // iPad safe: garantir popoverPresentationController para não crashar
        if let pop = alert.popoverPresentationController {
            pop.sourceView = viewLanguage
            pop.sourceRect = viewLanguage.bounds
            pop.permittedArrowDirections = .up
        }

        present(alert, animated: true, completion: nil)
    }
    
    @objc func toolgeMode(_ sender: UISwitch) {
        darkModeEnabled = sender.isOn
        
        let style: UIUserInterfaceStyle = darkModeEnabled ? .dark : .light
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if let scene = scene as? UIWindowScene {
                    for window in scene.windows {
                        window.overrideUserInterfaceStyle = style
                    }
                }
            }
        } else {
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = style
        }
        
        NotificationCenter.default.post(name: Notification.Name("didChangeAppearance"), object: nil)
    }
    
    @objc func toolgeNotification() {
        
    }
}
