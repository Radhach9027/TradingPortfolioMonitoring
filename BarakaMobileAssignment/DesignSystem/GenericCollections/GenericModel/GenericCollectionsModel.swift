//
//  GenericCollectionsModel.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit


protocol ModelUpdateProtocol: AnyObject {
    associatedtype ModelData
    func update(modelData: ModelData, indexPath: IndexPath)
}

protocol RegisterModelType {
    var reuseIdentifier: String { get }
    func update(cell: UICollectionViewCell, indexPath: IndexPath)
}

struct ConfigureCollectionsModel<T>: RegisterModelType where T: ModelUpdateProtocol {
    public var modelData: [T.ModelData]?
    public let reuseIdentifier: String = NSStringFromClass(T.self).components(separatedBy: ".").last!

    public init(modelData: [T.ModelData]? = nil) {
        self.modelData = modelData
    }

    public func update(cell: UICollectionViewCell, indexPath: IndexPath) {
        guard let cell = cell as? T else { return }
        if let model = modelData?[safe: indexPath.row] {
            cell.update(modelData: model, indexPath: indexPath)
        }
    }
}
