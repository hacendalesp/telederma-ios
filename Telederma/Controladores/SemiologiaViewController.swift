//
//  SemiologiaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/08/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import AVKit

class SemiologiaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func verDetalle (elemento: String, titulo: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_semiologia_detalle") as! SemiologiaDetalleViewController;
        vc.imagen = UIImage(named: "img_\(elemento)");
        vc.ilustracion = UIImage(named: "ilu_\(elemento)");
        vc.texto = Mensajes.DICCIONARIO_SEMIOLOGIA[elemento];
        vc.titulo = titulo;
        self.present(vc, animated: true, completion: nil);
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
    
    @IBAction func accionVideoSemiologia(_ sender: UIButton) {
        let videoURL = Bundle.main.url(forResource: "video_semiologia", withExtension: "mp4");
        let player = AVPlayer(url: videoURL!);
        let playerViewController = AVPlayerViewController();
        playerViewController.player = player;
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play();
        }
    }
    
    @IBAction func accionAmpolla(_ sender: UIButton) {
        self.verDetalle(elemento: "ampolla", titulo: "Ampolla");
    }
    
    @IBAction func accionAtrofia(_ sender: UIButton) {
        self.verDetalle(elemento: "atrofia", titulo: "Atrofia");
    }
    
    @IBAction func accionCicatriz(_ sender: UIButton) {
        self.verDetalle(elemento: "cicatriz", titulo: "Cicatriz");
    }
    
    @IBAction func accionCostra(_ sender: UIButton) {
        self.verDetalle(elemento: "costra", titulo: "Costra");
    }
    
    @IBAction func accionErosion(_ sender: UIButton) {
        self.verDetalle(elemento: "erosion", titulo: "Erosión");
    }
    
    @IBAction func accionEscama(_ sender: UIButton) {
        self.verDetalle(elemento: "escama", titulo: "Escama");
    }
    
    @IBAction func accionEsclerosis(_ sender: UIButton) {
        self.verDetalle(elemento: "esclerosis", titulo: "Esclerosis");
    }
    
    @IBAction func accionExcoriacion(_ sender: UIButton) {
        self.verDetalle(elemento: "excoriacion", titulo: "Excoriación");
    }
    
    @IBAction func accionFistula(_ sender: UIButton) {
        self.verDetalle(elemento: "fistula", titulo: "Fístula");
    }
    
    @IBAction func accionFisura(_ sender: UIButton) {
        self.verDetalle(elemento: "fisura", titulo: "Fisura");
    }
    
    @IBAction func accionRoncha(_ sender: UIButton) {
        self.verDetalle(elemento: "roncha", titulo: "Roncha");
    }
    
    @IBAction func accionLiquenificacion(_ sender: UIButton) {
        self.verDetalle(elemento: "liquenificacion", titulo: "Liquenificación");
    }
    
    @IBAction func accionMacula(_ sender: UIButton) {
        self.verDetalle(elemento: "macula", titulo: "Mácula");
    }
    
    @IBAction func accionNodulo(_ sender: UIButton) {
        self.verDetalle(elemento: "nodulo", titulo: "Nódulo");
    }
    
    @IBAction func accionPapula(_ sender: UIButton) {
        self.verDetalle(elemento: "papula", titulo: "Pápula");
    }
    
    @IBAction func accionParche(_ sender: UIButton) {
        self.verDetalle(elemento: "parche", titulo: "Parche");
    }
    
    @IBAction func accionPlaca(_ sender: UIButton) {
        self.verDetalle(elemento: "placa", titulo: "Placa");
    }
    
    @IBAction func accionPoiquilodermia(_ sender: UIButton) {
        self.verDetalle(elemento: "poiquilodermia", titulo: "Poiquilodermia");
    }
    
    @IBAction func accionPostula(_ sender: UIButton) {
        self.verDetalle(elemento: "pustula", titulo: "Pústula");
    }
    
    @IBAction func accionQuiste(_ sender: UIButton) {
        self.verDetalle(elemento: "quiste", titulo: "Quiste");
    }
    
    @IBAction func accionTelangiectasia(_ sender: UIButton) {
        self.verDetalle(elemento: "telangiectasia", titulo: "Telangiectasia");
    }
    
    @IBAction func accionTumor(_ sender: UIButton) {
        self.verDetalle(elemento: "tumor", titulo: "Tumor");
    }
    
    @IBAction func accionUlcera(_ sender: UIButton) {
        self.verDetalle(elemento: "ulcera", titulo: "Úlcera");
    }
    
    @IBAction func accionVegetaciones(_ sender: UIButton) {
        self.verDetalle(elemento: "vegetaciones", titulo: "Vegetaciones");
    }
    
    @IBAction func accionVesicula(_ sender: UIButton) {
        self.verDetalle(elemento: "vesicula", titulo: "Vesícula");
    }
    
    @IBAction func accionAnexosCutaneos(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_visor_pdf") as! VisorPDFViewController;
        vc.urlDocumento = "semiologia_anexos";
        vc.tituloHeader = "Anexos cutáneos";
        self.present(vc, animated: true, completion: nil);
    }
}
