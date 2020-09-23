//
//  TestController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/20/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit
import ARKit

class TestController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    let rNode = SCNNode()
    let centerNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = false

        
        
        
        
//        let freedomRing = SCNBox(width: 8, height: 1, length: 1, chamferRadius: 0)
        let freedomRing = SCNTube(innerRadius: 0.1, outerRadius: 0.5, height: 0.0001)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/saturn_rings4.png")
        freedomRing.materials = [material]
        
        rNode.geometry = freedomRing
        rNode.position = SCNVector3(x: 0, y: 0, z: -1)
        
        centerNode.position = SCNVector3(0, 0, 0)
        centerNode.addChildNode(rNode)

        sceneView.scene.rootNode.addChildNode(centerNode)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        let rotate = SCNAction.rotateBy(x: 0.1, y: 0, z: 0, duration: 0.5)
        centerNode.runAction(rotate)
        print("center x:\(centerNode.rotation.x), y:\(centerNode.rotation.y), z:\(centerNode.rotation.z), w: \(centerNode.rotation.w * 180 / .pi)")
        print("center x:\(rNode.rotation.x), y:\(rNode.rotation.y), z:\(rNode.rotation.z), w: \(rNode.rotation.w * 180 / .pi)")
 
    }

}

extension TestController: ARSCNViewDelegate {
    
}
