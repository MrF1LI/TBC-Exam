//
//  SceneDelegate.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var firebaseManager = FirebaseManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Get initial view controller
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if FirebaseManager.currentUser != nil {
            
            // If user reference contains current user id go to main page
            
            let reference = firebaseManager.dbUsers.child(FirebaseManager.currentUser!.uid)
            
            reference.observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    // Go To Main Page
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                } else {
                    let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }
            
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

