//
//  ContentView.swift
//  AR-Physics
//
//  Created by Fatih Emre Sarman on 11.07.2024.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var showGameOver = false
    @State private var highScores = UserDefaults.standard.array(forKey: "highScores") as? [(String, Int)] ?? []
    @State private var cubesRemaining = 100
    @State private var currentScore = 0
    
    var body: some View {
        VStack {
            if showGameOver {
                GameOverView(currentScore: currentScore, highScores: $highScores, onRestart: restartGame)
            } else {
                ARViewContainer(cubesRemaining: $cubesRemaining, currentScore: $currentScore, onGameOver: gameOver)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack {
                            HStack {
                                Text("Cubes Remaining: \(cubesRemaining)")
                                Spacer()
                                Text("Score: \(currentScore)")
                            }
                            .padding()
                            Spacer()
                        }
                    )
            }
        }
    }
    
    func gameOver() {
        showGameOver = true
    }
    
    func restartGame() {
        cubesRemaining = 100
        currentScore = 0
        showGameOver = false
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var cubesRemaining: Int
    @Binding var currentScore: Int
    var onGameOver: () -> Void
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        
        let planeAnchor = AnchorEntity(plane: .horizontal)
        let plane = ModelEntity(mesh: MeshResource.generatePlane(width: 2, depth: 2), materials: [SimpleMaterial(color: .orange, isMetallic: true)])
        plane.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        plane.collision = CollisionComponent(shapes: [.generateBox(size: [2, 0.1, 2])])
        
        planeAnchor.addChild(plane)
        arView.scene.addAnchor(planeAnchor)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        context.coordinator.view = arView
        context.coordinator.cubesRemaining = $cubesRemaining
        context.coordinator.currentScore = $currentScore
        context.coordinator.onGameOver = onGameOver
       
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
//{
//    ContentView()
//}
