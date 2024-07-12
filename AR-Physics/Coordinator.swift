//
//  Coordinator.swift
//  AR-Physics
//
//  Created by Fatih Emre Sarman on 11.07.2024.
//

import SwiftUI
import RealityKit
import Combine
import ARKit

class Coordinator: NSObject, ARSessionDelegate {
    weak var view: ARView?
    var cubesRemaining: Binding<Int>!
    var currentScore: Binding<Int>!
    var onGameOver: (() -> Void)?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = view, cubesRemaining.wrappedValue > 0 else { return }
        
        let location = recognizer.location(in: view)
        let results = view.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchor = AnchorEntity(raycastResult: result)
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: .green, isMetallic: true)])
            box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic)
            box.generateCollisionShapes(recursive: true)
            box.position = simd_make_float3(0, 1.1, 0)
            
            anchor.addChild(box)
            view.scene.anchors.append(anchor)
            
            cubesRemaining.wrappedValue -= 1
            currentScore.wrappedValue += 1
            
            if cubesRemaining.wrappedValue == 0 {
                onGameOver?()
            }
        }
    }
}
