//
//  Reusable.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import UIKit
import Foundation

protocol Reusable {
    static func reuseIdentifier() -> String
}

extension Reusable where Self: UIView {

    static var nibName: String {
         return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle.init(for: self))
    }

    static func fromNib() -> Self {
        guard let nib = Bundle(for: self).loadNibNamed(nibName, owner: nil, options: nil) else {
            fatalError("Failed loading the nib named \(nibName) for 'NibLoadable' view of type '\(self)'.")
        }
        guard let view = (nib.first { $0 is Self }) as? Self else {
            fatalError("Did not find 'NibLoadable' view of type '\(self)' inside '\(nibName).xib'.")
        }
        return view
    }
}


extension Reusable {
    static func reuseIdentifier() -> String {
        return String(describing: Self.self) // Identifier is equal to type name of class that adopts protocol
    }

    static var nibName: String {
         return String(describing: self)
    }
}

extension UITableView {
    func register<CellType: UITableViewCell & Reusable>(_ cellClass: CellType.Type) {
        register(cellClass, forCellReuseIdentifier: CellType.reuseIdentifier())
    }

    func registerForHeaderFooterView<CellType: UITableViewHeaderFooterView & Reusable>(_ cellClass: CellType.Type) {
        register(cellClass, forHeaderFooterViewReuseIdentifier: CellType.reuseIdentifier())
    }

    func dequeueReusableCell<CellType: UITableViewCell & Reusable>(_ cellClass: CellType.Type, for indexPath: IndexPath? = nil) -> CellType {
        var cell: CellType?
        if let indexPath = indexPath {
            cell = dequeueReusableCell(withIdentifier: CellType.reuseIdentifier(), for: indexPath) as? CellType
        } else {
            cell = dequeueReusableCell(withIdentifier: CellType.reuseIdentifier()) as? CellType
        }

        guard let result = cell else {
            fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(cellClass.reuseIdentifier())")
        }
        return result
    }

    func dequeueReusableHeaderFooterView<CellType: UITableViewHeaderFooterView & Reusable>(_ cellClass: CellType.Type) -> CellType {
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: CellType.reuseIdentifier()) as? CellType
            else { fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(cellClass.reuseIdentifier())") }

        return cell
    }
}

extension UICollectionView {
    func register<CellType: UICollectionViewCell & Reusable>(_ cellClass: CellType.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier())
    }

    func register<CellType: UICollectionReusableView & Reusable>(_ cellClass: CellType.Type, forSupplementaryViewOfKind kind: String) {
        register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: cellClass.reuseIdentifier())
    }

    func dequeueReusableCell<CellType: UICollectionViewCell & Reusable>(_ cellClass: CellType.Type, for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CellType.reuseIdentifier(), for: indexPath) as? CellType else {
            fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(cellClass.reuseIdentifier())")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<CellType: UICollectionReusableView & Reusable>(
        _ cellClass: CellType.Type,
        ofKind kind: String,
        for indexPath: IndexPath) -> CellType {

        guard let cell = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: cellClass.reuseIdentifier(),
                for: indexPath) as? CellType
        else {
            fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(cellClass.reuseIdentifier())")
        }

        return cell
    }
}

protocol ReusableProtocol {}

extension ReusableProtocol {
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: self.identifier, bundle: Bundle.main)
    }
}
extension UIView: ReusableProtocol {}
extension UIViewController: ReusableProtocol {}
