//
//  FirmaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import UberSignature

class FirmaViewController: UIViewController {
    
    @IBOutlet weak var ViewFirma: UIView!
    @IBOutlet weak var btnConfirmar: UIButton!
    @IBOutlet weak var btnBorrar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    // Se declara una variable para saber quién solicita la firma, si el registro o el perfil.
    static var estaEnModoRegistro = false;
    static var estaEnModoPerfil = false;
    
    private var signatureViewController = SignatureDrawingViewController(image: PerfilViewController.imgFirma);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnConfirmar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnBorrar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCancelar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        // Do any additional setup after loading the view.
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .landscapeRight;
     
        self.precargarFirma();
    }        
    
    override var shouldAutorotate: Bool {
        return false;
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight;
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight;
    }
        
    
    /**
     Permite validar si ya existe una firma, si es así, la muestra según la vista.
     */
    private func precargarFirma () {
        if(FirmaViewController.estaEnModoRegistro) {
            if(RegistroViewController.imgFirma != nil) {
                self.signatureViewController = SignatureDrawingViewController(image: RegistroViewController.imgFirma);
            } else {
                self.signatureViewController = SignatureDrawingViewController();
            }
        }
        
        if(FirmaViewController.estaEnModoPerfil) {
            if(PerfilViewController.imgFirma != nil) {
                self.signatureViewController = SignatureDrawingViewController(image: PerfilViewController.imgFirma);
            } else {
                self.signatureViewController = SignatureDrawingViewController();
            }
        }
        self.signatureViewController.delegate = self;
        ViewFirma.addSubview((self.signatureViewController.view)!);
        self.signatureViewController.didMove(toParent: self);
    }
    
    /**
     Permite cerrar la vista e inacticar la vista horizontal.
     */
    private func cerrarVentanaFirma () {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait;
        
        self.dismiss(animated: true, completion: nil);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionConfirmar(_ sender: UIButton) {
        if let imgFirma = self.signatureViewController.fullSignatureImage {
            if(FirmaViewController.estaEnModoRegistro){
                RegistroViewController.imgFirma = imgFirma;
            } else if(FirmaViewController.estaEnModoPerfil) {
                PerfilViewController.imgFirma = imgFirma;
            }
        }
        self.cerrarVentanaFirma();
    }
    @IBAction func accionBorrar(_ sender: UIButton) {
        self.signatureViewController.reset();
        if(FirmaViewController.estaEnModoRegistro){
            RegistroViewController.imgFirma = nil;
        } else if(FirmaViewController.estaEnModoPerfil) {
            PerfilViewController.imgFirma = nil;
        }
    }
    @IBAction func accionCancelar(_ sender: UIButton) {
        self.cerrarVentanaFirma();
    }
    
}

extension FirmaViewController: SignatureDrawingViewControllerDelegate {
    
    func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
        
    }
}
