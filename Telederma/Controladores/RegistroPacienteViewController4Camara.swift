//
//  RegistroPacienteViewController4_Camara.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//
/**
 - IMPORTANTE:
 
 EN ESTA CLASE SE DEFINEN LAS VARIABLES ESTÁTICAS QUE PERMITEN ADMINISTRAR LA INFORMACIÓN DE LAS FOTOGRAFÍAS. ESTO QUIERE DECIR QUE TANTO LAS FOTOS BÁSICAS, COMO LAS FOTOS DERMATOSCOPÍA AL IGUAL QUE LAS FOTOS DE LOS ANEXOS SE ALMACENAN EN VARIABLES ESTÁTICAS DISPUESTAS AQUÍ.
 
 */
import UIKit
import AVFoundation

class RegistroPacienteViewController4Camara: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var vistaPrincipal: UIView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnTomarFoto: UIButton!
    @IBOutlet weak var stackFotos: UIStackView!
    @IBOutlet weak var btnZoom1: UIButton!
    @IBOutlet weak var btnZoom2: UIButton!
    @IBOutlet weak var scrollStackFotos: UIScrollView!
    @IBOutlet weak var loadingPrincipal: UIActivityIndicatorView!
    @IBOutlet weak var loadingStack: UIActivityIndicatorView!
    
    // Alto del Stackview donde se muestran las imágenes tomadas.
    @IBOutlet weak var altoStackImagenesTomadas: NSLayoutConstraint!
    
    // Elementos imágenes dermatoscópicas
    @IBOutlet weak var lblImagenesDermatoscopia: UILabel!
    @IBOutlet weak var altoTituloDermatoscopia: NSLayoutConstraint!
    
    // Variables para el uso de la cámara.
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var camera: AVCaptureDevice!;
    
    // Lista de botones para asignar eventos al tocar, y tag con la ubicación de cada imagen.
    var listaBotonesGenerados = [UIButton?]();
    
    // Variables dermatoscopia
    var tituloImagenesDermatoscopiaHeightVisible: CGFloat!;
    
    // Alto inicial
    var stackImagenesTomadasHeightVisible: CGFloat!;
    // Se declara un height visible auxiliar que tomará temporalmente el valor de la capa a interactuar.
    var auxiliarHeightVisible: CGFloat!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        // Mostrando actividad en la vista
        self.loadingPrincipal.startAnimating();
        self.loadingStack.startAnimating();
        
        self.configurarCamara();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.captureSession.stopRunning();
    }
    
    private func inits () {
        
        // Ajustando estilos.
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnZoom1.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnZoom2.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.loadingPrincipal.hidesWhenStopped = true;
        self.loadingStack.hidesWhenStopped = true;
        self.btnZoom1.backgroundColor = .systemBlue;
        
        // Se guarda el alto del título dermatoscopia para mostrarlo cuando se necesite.
        self.tituloImagenesDermatoscopiaHeightVisible = self.altoTituloDermatoscopia.constant;
        // La primera vez oculta los elementos de dermatoscopia.
        self.verificarEstilosDermatoscopia();
        
        // Borde para el botón guardar
        let maskPath = UIBezierPath(roundedRect: self.btnGuardar.bounds,                                    byRoundingCorners: [.topLeft, .bottomLeft],cornerRadii: CGSize(width: 10.0, height: 10.0));
        let shape = CAShapeLayer();
        shape.path = maskPath.cgPath;
        self.btnGuardar.layer.mask = shape;
        
        // Se ocultan las opciones de acompañante y resonsable al iniciar la vista.
        self.stackImagenesTomadasHeightVisible = self.altoStackImagenesTomadas.constant;
        self.scrollStackFotos.isHidden = true;
        self.altoStackImagenesTomadas.constant = 0;
        self.stackFotos.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    /**
     Permite ocultar / mostrar elementos de dermatoscopia
     */
    private func verificarEstilosDermatoscopia () {
        // Se oculta / activa el mensaje que indica al usuario que está activa la captura de imágenes para dermatoscopía.
        if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            self.lblImagenesDermatoscopia.isHidden = false;
            self.altoTituloDermatoscopia.constant = self.tituloImagenesDermatoscopiaHeightVisible;
        } else {
            self.lblImagenesDermatoscopia.isHidden = true;
            self.altoTituloDermatoscopia.constant = 0;
        }
    }
    
    private func configurarCamara () {
        
        // Cuando carga nuevamente la cámara debe saber qué ocultar.
        self.verificarEstilosDermatoscopia();
        
        // Configurar la cámara
        self.captureSession = AVCaptureSession();
        self.captureSession.sessionPreset = .high;
        
        self.camera = AVCaptureDevice.default(for: AVMediaType.video);
        
        if(self.camera == nil) {
            print("Cámara no está lista");
            return;
        }
        
        do {
            // La mayoría de dispositivos actuales de Apple soportan el autofocus
            if (self.camera!.isFocusModeSupported(.continuousAutoFocus)) {
                try! self.camera!.lockForConfiguration();
                self.camera!.focusMode = .continuousAutoFocus;
                self.camera!.unlockForConfiguration();
            }
            if(self.camera.isExposureModeSupported(.continuousAutoExposure)) {
                try! self.camera!.lockForConfiguration();
                self.camera!.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure;
                self.camera!.unlockForConfiguration();
            }
            let input = try AVCaptureDeviceInput(device: self.camera!);
            self.stillImageOutput = AVCapturePhotoOutput();
            if self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(self.stillImageOutput) {
                self.captureSession.addInput(input);
                self.captureSession.addOutput(self.stillImageOutput);
                self.setupLivePreview();
            }
        } catch {
            print("Error cámara trasera:  \(error.localizedDescription)");
        }
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        videoPreviewLayer.videoGravity = .resizeAspectFill;
        videoPreviewLayer.connection?.videoOrientation = .portrait;
        self.vistaPrincipal.layer.addSublayer(videoPreviewLayer);
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning();
            DispatchQueue.main.async {
                self.loadingPrincipal.stopAnimating();
                self.videoPreviewLayer.frame = self.vistaPrincipal.bounds;
                self.cargarFotosTomadas();
            }
        }
    }
    
    /**
     Permite mostrar una vista, epara este controller se usa con el espacio del stack view y las fotos que han sido tomadas.
     - Parameter vista: Corresponde a la sección o vista que se desea mostrar.
     - Parameter altoInicial: Corresponde al alto que tenía la vista cuando inicia el controller (NSLayoutConstraint)
     - Parameter animado: Corresponde un valor booleano que permite animar o no el efecto de omostrar la vista.
     */
    private func mostrarSeccion (vista: UIView, altoInicial : NSLayoutConstraint, animado: Bool) {
        altoInicial.constant = self.auxiliarHeightVisible;
        vista.isHidden = false;
        
        if animado {
            UIView.animate(withDuration: 0.2, animations: {
                () -> Void in
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            view.layoutIfNeeded()
        }
    }
    
    /**
     Permite ocultar una sección aplicando o no una animación.
     - Parameter vista: Corresponde a la sección o vista que se desea mostrar.
     - Parameter altoInicial: Corresponde al alto que tenía la vista cuando inicia el controller (NSLayoutConstraint)
     - Parameter animado: Corresponde un valor booleano que permite animar o no el efecto de omostrar la vista.
     */
    private func ocultarSeccion (vista: UIView, altoInicial: NSLayoutConstraint, animado: Bool) {
        altoInicial.constant = 0;
        vista.isHidden = true;
        
        if animado {
            UIView.animate(withDuration: 0.2, animations: {
                () -> Void in
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            view.layoutIfNeeded()
        }
    }
    
    /**
     Permite seleccionar una foto y observarla en tamaño más grande, manteniendo la información de la vista actual.
     */
    @objc func verFoto (_ sender: UIButton) {
        let posicion = sender.tag;
        let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_foto") as! RegistroPacienteViewController4Foto;
        vc.posicion = posicion;
        self.reiniciarVistas();
        self.present(vc, animated: true, completion: nil);
    }
    
    /**
     Permite mejorar la presentación a nivel visual, cuando se retorna a la cámara.
     */
    private func reiniciarVistas () {
        self.loadingPrincipal.startAnimating();
        self.videoPreviewLayer.isHidden = true;
        self.limpiarStackFotosTomadas();
    }
    
    /**
     Permite llenar el stack view con las fotos que se encuentran en la lista de fotos tomadas.
     */
    private func cargarFotosTomadas () {
        // self.ocultarSeccion(vista: self.scrollStackFotos, altoInicial: self.altoStackImagenesTomadas, animado: true);
        
        // Se vacían las listas y los elementos del stackview.
        self.limpiarStackFotosTomadas();
        self.listaBotonesGenerados = [];
        
        // Se declara una lista temporal y contador según el tipo de imágenes con las que se está trabajando.
        var listaImagenesTemporal: [UIImage?];
        var contadorElementosEnLista = 0;
        // Se toma el tamaño y la lista, dependiendo si es normal o dermatoscopia
        // Si dermatoscopía está activa
        if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            
            contadorElementosEnLista = MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!]?.count ?? 0;
            listaImagenesTemporal = MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!] ?? [];
            
        } else {
            // Si está activa Anexos paso 5
            if(MemoriaRegistroConsulta.estaAnexosActiva) {
                contadorElementosEnLista = MemoriaRegistroConsulta.listaFotosAnexos.count;
                listaImagenesTemporal = MemoriaRegistroConsulta.listaFotosAnexos;
            } else {
                // Si corresponde a imágenes base paso 1
                contadorElementosEnLista = MemoriaRegistroConsulta.listaFotosTomadas.count;
                listaImagenesTemporal = MemoriaRegistroConsulta.listaFotosTomadas;
            }
        }
        if (contadorElementosEnLista > 0) {
            // Como la lista está invertida, el contador empieza por el último elemento
            var contador = contadorElementosEnLista - 1;
            
            // Se recorre la lista de imágenes de manera inversa.
            // La lista de imágenes tomadas no se modifica.
            for foto in listaImagenesTemporal.reversed() {
                // Se crea un botón para el manejo de evento de foto individual
                let boton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: self.stackImagenesTomadasHeightVisible));
                boton.widthAnchor.constraint(equalToConstant: 80).isActive = true;
                boton.heightAnchor.constraint(equalToConstant: self.stackImagenesTomadasHeightVisible).isActive = true;
                boton.tag = contador;
                // boton.setTitle(contador.description, for: .normal);
                
                // Se valida que no esté activa la funcionalidad de dermatoscopia ni anexos para ver foto detalle desde la cámara.
                if (!MemoriaRegistroConsulta.estaDermatoscopiaActiva && !MemoriaRegistroConsulta.estaAnexosActiva) {
                    boton.addTarget(self, action: #selector(self.verFoto(_:)), for: .touchUpInside);
                }
                
                // Se agrega la imagen a la lista de fotos tomadas.
                self.listaBotonesGenerados.append(boton);
                
                // let imagenConRotacion = Funcionales.rotarImagen(oldImage: foto!, grados: 90);
                // boton.setBackgroundImage(imagenConRotacion, for: .normal);
                boton.setBackgroundImage(foto, for: .normal);
                
                // Se valida si dermatoscopía está guardada y se busca la foto principal para agregar marca. Y que no esté activa anexos paso 5
                if (MemoriaRegistroConsulta.estaDermatoscopiaGuardada && !MemoriaRegistroConsulta.estaAnexosActiva) {
                    
                    // La lista de fotos principales  no puede estar vacía.
                    if(MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.count > 0) {
                        // Se recorre la lista de principales para obtener el índice y agregar la marca
                        for (_, principal) in MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia {
                            if let indiceImagen = MemoriaRegistroConsulta.listaFotosTomadas.firstIndex(of: principal!) {
                                
                                if (foto!.isEqual(MemoriaRegistroConsulta.listaFotosTomadas[indiceImagen])) {
                                    
                                    // Se agrega marca sobre la imagen para informar que contiene registros dermatoscopía
                                    boton.setImage(UIImage(named: "dermatoscopia_marca"), for: .normal);
                                    boton.imageEdgeInsets.top = 55;
                                    boton.imageEdgeInsets.left = 5;
                                }
                            }
                        }
                    }
                    
                }
                
                // Se añade nuevo botón a la lista de botones que sirven para ver la foto detalle.
                self.stackFotos.addArrangedSubview(boton);
                
                // Mostrar Stack
                self.auxiliarHeightVisible = self.stackImagenesTomadasHeightVisible;
                self.mostrarSeccion(vista: self.scrollStackFotos, altoInicial: self.altoStackImagenesTomadas, animado: true);
                
                contador -= 1;
            }
        }
        self.loadingStack.stopAnimating();
    }
    
    /**
     Permite eliminar la información asociada a imágenes dermatoscopicas.
     Se usa cuando se está usando la cámara dermatoscopía y se regresa a fotos normales.
     */
    private func limpiarInformacionDermatoscopia () {
        // Se reinician los valores y se elimina la etiqueta Dermatoscopia
        if (!MemoriaRegistroConsulta.estaDermatoscopiaGuardada) {
            MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia = [:];
            MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia = nil;
            MemoriaRegistroConsulta.estaDermatoscopiaGuardada = false;
            MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia = [:];
        }
        
        MemoriaRegistroConsulta.estaDermatoscopiaActiva = false;
        MemoriaRegistroConsulta.indiceDermatoscopiaActiva = nil;
        MemoriaRegistroConsulta.listaFotosDermatoscopias = [:];
    }
    
    /**
     Permite vaciar la lista de fotos tomadas al igual que la lista de botones generados para el stackview.
     */
    private func limpiarInformacionFotosTomadas () {
        MemoriaRegistroConsulta.listaFotosTomadas = [];
        self.listaBotonesGenerados = [];
    }
    
    /**
     Permite borrar las vistas dentro del stackview.
     */
    private func limpiarStackFotosTomadas () {
        if (self.stackFotos.subviews.count > 0) {
            for v in self.stackFotos.arrangedSubviews {
                v.removeFromSuperview();
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    /**
     Botón verde que envía hacia la vista para seleccionar las imágenes.
     */
    @IBAction func accionGuardar(_ sender: UIButton) {
        var cantidadMinima = 0;
        var cantidadMaxima = 0;
        
        // Se valida el tipo de imágenes que debe tomar la cámara.
        // Si dermatoscopia está activa
        if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            cantidadMinima = Constantes.CANTIDAD_MINIMA_IMAGENES_DERMATOSCOPIA;
            cantidadMaxima = Constantes.CANTIDAD_MAXIMA_IMAGENES_DERMATOSCOPIA;
        } else {
            // Se valida si son imágenes de los anexos paso 5
            if (MemoriaRegistroConsulta.estaAnexosActiva) {
                cantidadMinima = Constantes.CANTIDAD_MINIMA_IMAGENES_ANEXOS;
                cantidadMaxima = Constantes.CANTIDAD_MAXIMA_IMAGENES_ANEXOS;
            } else {
                // De lo contrario corresponde a imágenes base paso 1
                cantidadMinima = Constantes.CANTIDAD_MINIMA_IMAGENES_TOMADAS;
                cantidadMaxima = Constantes.CANTIDAD_MAXIMA_IMAGENES_TOMADAS;
            }
        }
        if (self.listaBotonesGenerados.count < cantidadMinima) {
            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.FOTOS_CANTIDAD_MINIMA)\(cantidadMinima)");
        } else {
            if(self.listaBotonesGenerados.count > cantidadMaxima) {
                Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.FOTOS_CANTIDAD_MAXIMA)\(cantidadMaxima)");
            } else {
                if (MemoriaRegistroConsulta.estaControlMedicoActivo && MemoriaRegistroConsulta.estaAnexosActiva) {
                    self.dismiss(animated: true, completion: nil);
                } else {
                    self.reiniciarVistas();
                    let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_anadir") as! RegistroPacienteViewController4Anadir;
                    self.present(vc, animated: true, completion: nil);
                }
            }
        }
    }
    
    @IBAction func accionTomarFoto(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg]);
        stillImageOutput.capturePhoto(with: settings, delegate: self);
    }
    @IBAction func accionZoom1(_ sender: UIButton) {
        do {
            try self.camera?.lockForConfiguration();
            let zoomFactor:CGFloat = 1;
            self.camera?.videoZoomFactor = zoomFactor;
            self.camera?.unlockForConfiguration();
            self.btnZoom2.backgroundColor = .lightGray;
            self.btnZoom1.backgroundColor = .systemBlue;
        } catch {
            print("Error zoom 1: \(error)");
        }
    }
    @IBAction func accionZoom2(_ sender: UIButton) {
        do {
            try self.camera?.lockForConfiguration();
            let zoomFactor:CGFloat = 2;
            self.camera?.videoZoomFactor = zoomFactor;
            self.camera?.unlockForConfiguration();
            self.btnZoom1.backgroundColor = .lightGray;
            self.btnZoom2.backgroundColor = .systemBlue;
        } catch {
            print("Error zoom 2: \(error)");
        }
    }
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        // Si está activa dermatoscopía
        if(MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
            // Este es el deber ser en las condiciones correctas para dermatoscopía.
            // Si en la lista de fotos tomadas se encuentra la foto principal dermatoscopía ...
            if let index = MemoriaRegistroConsulta.listaFotosTomadas.firstIndex(of: MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia) {
                
                // Con el índice se inicia la vista de foto detalle cargando la imagen que había sido seleccionada como principal en dermatoscopía y su posición.
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_foto") as! RegistroPacienteViewController4Foto;
                vc.posicion = index;
                self.limpiarInformacionDermatoscopia();
                self.present(vc, animated: true, completion: nil);
            } else {
                // En teoría este camino no debería existir.
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4") as! RegistroPacienteViewController4;
                self.limpiarInformacionDermatoscopia();
                self.present(vc, animated: true, completion: nil);
            }
            
        } else {
            // Se valida si está activa anexos paso 5.
            if(MemoriaRegistroConsulta.estaAnexosActiva) {
                MemoriaRegistroConsulta.estaAnexosActiva = false;                
                self.dismiss(animated: true, completion: nil);
            } else {
                
                // Se valida si está activo control médico
                if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
                    self.dismiss(animated: true, completion: nil);
                } else {
                    // Si se trata de tomar las fotos (parte 1) entonces devuelve al exámen físico.
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4") as! RegistroPacienteViewController4;
                    self.limpiarInformacionDermatoscopia();
                    self.present(vc, animated: true, completion: nil);
                }
            }
        }
    }
    
}

extension RegistroPacienteViewController4Camara: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        // Se crea la imagen a partir de la fotografía.
        let image = Funcionales.rotarImagen(oldImage: UIImage(data: imageData)!, grados: 90);
        
        var contadorFotosTomadas = 0;
        var valorMaximo = 0;
        
        // Se valida según el tipo de contenido que activa la cámara, y la cantidad de imágenes.
        // Si está activa dermatoscopia
        if(MemoriaRegistroConsulta.estaDermatoscopiaActiva){
            contadorFotosTomadas = MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!]?.count ?? 0;
            valorMaximo = Constantes.CANTIDAD_MAXIMA_IMAGENES_DERMATOSCOPIA;
        } else {
            // Si está activo Anexos paso 5
            if(MemoriaRegistroConsulta.estaAnexosActiva) {
                // Corresponde a anexos paso 5.
                contadorFotosTomadas = MemoriaRegistroConsulta.listaFotosAnexos.count;
                valorMaximo = Constantes.CANTIDAD_MAXIMA_IMAGENES_ANEXOS;
            } else {
                // Corresponde a imágenes base.
                contadorFotosTomadas = MemoriaRegistroConsulta.listaFotosTomadas.count;
                valorMaximo = Constantes.CANTIDAD_MAXIMA_IMAGENES_TOMADAS;
            }
        }
        
        if (contadorFotosTomadas < valorMaximo) {
            // Se añade la imagen a la lista de imágenes correspondiente.
            // Si está activa dermtoscopía
            if (MemoriaRegistroConsulta.estaDermatoscopiaActiva) {
                if(MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!] == nil) {
                    MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!] = [];
                }
                MemoriaRegistroConsulta.listaFotosDermatoscopias[MemoriaRegistroConsulta.indiceDermatoscopiaActiva!]!.append(image);
                
            } else {
                // Si está activa anexos paso 5
                if (MemoriaRegistroConsulta.estaAnexosActiva) {
                    MemoriaRegistroConsulta.listaFotosAnexos.append(image);
                } else {
                    // Imágenes base
                    MemoriaRegistroConsulta.listaFotosTomadas.append(image);
                }
            }
            self.cargarFotosTomadas();
        } else {
            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.FOTOS_CANTIDAD_MAXIMA)\(valorMaximo)");
        }
    }
}
