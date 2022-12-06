//
//  ManejoAPPViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/08/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import AVKit

class ManejoAPPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func accionVerVideo(_ sender: UIButton) {
        let videoURL = Bundle.main.url(forResource: "tutorial", withExtension: "mp4");
        let player = AVPlayer(url: videoURL!);
        let playerViewController = AVPlayerViewController();
        playerViewController.player = player;
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play();
        }
    }
    
    @IBAction func accionManejoApp(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_visor_pdf") as! VisorPDFViewController;
        vc.urlDocumento = "manual_de_usuario";
        vc.tituloHeader = "Manejo de la App";
        self.present(vc, animated: true, completion: nil);
    }

}
