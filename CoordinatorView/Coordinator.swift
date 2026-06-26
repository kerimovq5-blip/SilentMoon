//
//  Coordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//
import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}

