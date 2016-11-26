import UIKit
import CoreData

struct AttributeObjectPair {
  let object: NSManagedObject
  let attribute: NSAttributeDescription
  func value<T>() -> T? {
    return object.value(forKey: attribute.name) as? T
  }
}

protocol AttributeCellDelegate: class {
  func attributeCell(_ cell: AttributeCell, didChangeValue value: Any?)
  func presentingViewController(for attributeCell: AttributeCell) -> UIViewController
}

class AttributeCell: UITableViewCell {
  // MARK: - Globals
  class var identifier: String {
    return "AttributeCell"
  }
  // MARK: - Properties
  let attributeNameLabel = UILabel()
  let stackView = UIStackView()
  var attributeObjectPair: AttributeObjectPair?
  private let validationIndicator = ValidationIndicator()
  weak var delegate: AttributeCellDelegate?
  // MARK: - Creating
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: type(of: self).identifier)
    configureCell()
  }
  init() {
    super.init(style: .default, reuseIdentifier: type(of: self).identifier)
    configureCell()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Configure
  private func configureCell() {
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    let margins = contentView.layoutMarginsGuide

    stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    
    attributeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    attributeNameLabel.textColor = .lightGray
    attributeNameLabel.font = UIFont.systemFont(ofSize: 10.0)
    stackView.addArrangedSubview(attributeNameLabel)
  }
  func configure(with attributeObjectPair: AttributeObjectPair) {
    validationIndicator.sizeToFit()
    accessoryView = validationIndicator
    let invalidAttributes = attributeObjectPair.object.invalidAttributes() ?? []
    let isInvalid = invalidAttributes.contains(attributeObjectPair.attribute)
    validationIndicator.indicatesValidState = !isInvalid
    self.attributeObjectPair = attributeObjectPair
    attributeNameLabel.text = attributeObjectPair.attribute.name
  }
}