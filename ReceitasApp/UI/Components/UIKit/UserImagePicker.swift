import UIKit

protocol UserPhotoPickerViewDelegate: AnyObject {
    func userPhotoPickerView(_ picker: UserPhotoPickerView, didSelect image: UIImage)
}

class UserPhotoPickerView: UIView {

    weak var delegate: UserPhotoPickerViewDelegate?

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: ImageNameConstants.profile)
        return iv
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = AppColor.primaryButton
        button.setImage(UIImage(systemName: ImageNameConstants.plus), for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(imageView)
        addSubview(addButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 125),
            imageView.heightAnchor.constraint(equalToConstant: 125)
        ])

        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 25),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            addButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImageTapped))
        self.addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }
    
    @objc private func selectImageTapped() {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else { return }
        if addButton.isHidden { return }

        let alert = UIAlertController(title: String.stringFor(text: .selectPhoto), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: String.stringFor(text: .fromCamera), style: .default, handler: { _ in
                self.presentImagePicker(source: .camera, from: topController)
            }))
        alert.addAction(UIAlertAction(title: String.stringFor(text: .fromGallery), style: .default, handler: { _ in
                self.presentImagePicker(source: .photoLibrary, from: topController)
            }))
        alert.addAction(UIAlertAction(title: String.stringFor(text: .cancel), style: .cancel))

        topController.present(alert, animated: true)
    }

    private func presentImagePicker(source: UIImagePickerController.SourceType, from controller: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        controller.present(picker, animated: true)
    }
    
    public func setEditable(_ canEdit: Bool) {
        addButton.isHidden = !canEdit
    }
    
    public func setImageFor(link: String?) {
        imageView.setImage(from: link)
    }
}

extension UserPhotoPickerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            imageView.image = image
            delegate?.userPhotoPickerView(self, didSelect: image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
