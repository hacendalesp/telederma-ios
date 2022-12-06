//
//  InternoImagenesViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 2/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

/**
 Se obtienen los registros de las imagenes de lesiones según el control que se ha seleccionado.
 Se carga temporalmente una imagen por defecto.
 Cuando se se recarga la tabla, se descarga la imagen de cada celda.
 Se guarda el orden de las imágenes para cada control en variable de clase.
 Se guarda la imagen descargada en la variable de clase y se actualiza la imagen de la celda.
 */

import UIKit

class InternoImagenesViewController: UIViewController {
    
    @IBOutlet weak var btnControles: UIButton!
    @IBOutlet weak var lblTipoConsulta: UILabel!
    @IBOutlet weak var lblFechaConsulta: UILabel!
    @IBOutlet weak var coleccionImagenes: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // View Controller para el selector de controles médicos.
    var viewSelectorController: UIViewController!;
    
    // Variables para menejo de la información
    var consulta: ConsultaMedica!;
    var listaImagenesLesionConsulta = [ImagenLesion]();
    var listaControles = [ControlMedico]();
    
    let imagenCargando = UIImage(named: "cargando");
    
    let fileManager = FileManager.default;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajuste de estilos
        self.btnControles.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnControles.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnControles.layer.borderColor = Constantes.BORDE_COLOR;
        
        self.loading.hidesWhenStopped = true;
        
        self.coleccionImagenes.delegate = self;
        self.coleccionImagenes.dataSource = self;
        
        // Se asigna la posición del control seleccionado.
        self.btnControles.tag = MemoriaHistoriaClinica.posicionControlActivo;
        self.cargarInformacionSelectores();
    }
    
    private func obtenerIdConsultaControl () -> Int {
        var consultaControlId: Int;
        if (self.btnControles.tag == 0) {
            consultaControlId = self.consulta.id!;
        } else {
            consultaControlId = self.listaControles[self.btnControles.tag].id!;
        }
        return consultaControlId;
    }
    
    /**
     Se almacenan las imágenes en una lista de forma ordenada.
     - Parameter consulta: Corresponde a un objeto de ConsultaMedica.
     */
    private func descargarImagenesConsulta () {
        // Se inicializa la lista.
        self.listaImagenesLesionConsulta = [];
        // Se valida si hay lesiones de la consulta padre.
        if (MemoriaHistoriaClinica.lesiones.count > 0) {
            let lesiones = MemoriaHistoriaClinica.lesiones.filter({$0.consultation_id == self.consulta.id});
            if (lesiones.count > 0) {
                // Por cada lesión guardo las imágenes asociadas.
                for lesion in lesiones {
                    
                    let lesionImagenes = MemoriaHistoriaClinica.imagenesLesiones.filter({$0.injury_id == lesion.id && $0.image_injury_id == nil});
                    
                    if (lesionImagenes.count > 0) {
                        for imagen in lesionImagenes {
                            if (imagen.photo != "") {
                                self.listaImagenesLesionConsulta.append(imagen);
                            }
                        }
                    }
                }
                
                if (MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag] == nil) {
                    // Se reserva el espacio para las imagenes descargadas la primera vez.
                    MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag] = [:];
                }
            } else {
                print("No lesiones consulta");
            }
        } else {
            print("No lesiones general");
        }
    }
    
    private func descargarImagenesControl () {
        // Se carga el control seleccionado.
        let control = self.listaControles[self.btnControles.tag];
        self.listaImagenesLesionConsulta = [];
        // Se valida si hay lesiones de la consulta padre.
        if (MemoriaHistoriaClinica.lesiones.count > 0) {
            let lesiones = MemoriaHistoriaClinica.lesiones.filter({$0.consultation_control_id == control.consultation_control_id});
            if (lesiones.count > 0) {
                // Por cada lesión guardo las imágenes asociadas.
                for lesion in lesiones {
                    let lesionImagenes = MemoriaHistoriaClinica.imagenesLesiones.filter({$0.injury_id == lesion.id && $0.image_injury_id == nil});
                    if (lesionImagenes.count > 0) {
                        for imagen in lesionImagenes {
                            if (imagen.photo != "") {
                                self.listaImagenesLesionConsulta.append(imagen);
                            }
                        }
                    }
                }
                if (MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag] == nil) {
                    // Se reserva el espacio para las imagenes descargadas la primera vez.
                    MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag] = [:];
                }
            } else {
                print("No lesiones control");
            }
        } else {
            print("No lesiones general");
        }
    }
    
    /**
     Permite consultar en la base de datos, la información que se debe mostrar en las listas desplegables.
     */
    private func cargarInformacionSelectores () {
        // Se consulta el ID del médico que ha iniciado sesión.
        let doctorId = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as! Int;
        // Se obtienen las consultas internas por doctor.
        let internas = MemoriaHistoriaClinica.controlesMedicos.filter({$0.consultation_id == self.consulta.id}).filter({$0.doctor_id == doctorId});
        
        if (internas.count > 0) {
            for interna in internas {
                // Ingresa control padre
                //self.listaControles.append(interna);
                
                let control = MemoriaHistoriaClinica.controlesMedicos.filter({$0.consultation_control_id == interna.id});
                if (control.count > 0) {
                    // Ingresa controles hijos
                    self.listaControles += control;
                }
                
            }
            // Se ordena de forma ascendente.
            let sortedControles = self.listaControles.sorted {$0.id! < $1.id!};
            self.listaControles = sortedControles;
        }
        
        // Se declara un objeto por defecto.
        let controlDefault = ControlMedico();
        controlDefault.id = 0;
        controlDefault.created_at = Mensajes.CAMPO_SELECCIONAR;
        
        self.listaControles.insert(controlDefault, at: 0);
        
        if (self.listaControles.count == 1) {
            self.btnControles.isEnabled = false;
        }
        
        // Se valida si el usuario ha seleccionado un control entre las pestañas.
        self.cargarInformacionControl();
    }
    
    /**
     Permite mostrar un modal para la selección de las opciones de tipo de profesional.
     No requiere de parámetros y no retorna.
     */
    private func mostrarPickerSelectores (titulo: String) {
        
        self.viewSelectorController = UIViewController();
        self.viewSelectorController.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200));
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        // si es mayor a cero es que ya ha sido seleccionado y se ubica en el selector.
        if (self.btnControles.tag > 0) {
            pickerView.selectRow(self.btnControles.tag, inComponent: 0, animated: true);
        }
        
        self.viewSelectorController.view.addSubview(pickerView);
        
        let opcionesAlert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert);
        opcionesAlert.setValue(self.viewSelectorController, forKey: "contentViewController");
        opcionesAlert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil));
        
        self.present(opcionesAlert, animated: true);
    }
    
    private func cargarInformacionControl () {
        
        let control = self.listaControles[self.btnControles.tag];
        let texto = control.created_at!;
        
        Funcionales.ajustarTextoBotonSelector(boton: self.btnControles, texto: texto);
        
        if (self.btnControles.tag > 0) {
            self.lblTipoConsulta.text = "Control médico";
            self.lblFechaConsulta.text = control.created_at;
            self.descargarImagenesControl();
        } else {
            self.lblTipoConsulta.text = "Consulta médica";
            self.lblFechaConsulta.text = self.consulta.created_at;
            self.descargarImagenesConsulta();
        }
        
        
        // Se asigna el orden de las imágenes padre.
        for imagenLesion in self.listaImagenesLesionConsulta {
            if (MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag] == nil) {
                MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag] = [];
            }
            // Se evita repetir elementos en las listas de orden.
            if (!(MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag]?.contains(imagenLesion.id!))!) {
                MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag]!.append(imagenLesion.id!);
            }
            
            // Por cada imagen padre, se busca si tiene imágenes hijas.
            let hijas = MemoriaHistoriaClinica.imagenesLesiones.filter({$0.image_injury_id == imagenLesion.id?.description});
            if (hijas.count > 0) {
                for hija in hijas {
                    if (MemoriaHistoriaClinica.ordenHija[imagenLesion.id!] == nil) {
                        MemoriaHistoriaClinica.ordenHija[imagenLesion.id!] = [];
                    }
                    // MemoriaHistoriaClinica.imagenesHijas[imagenLesion.id!][hija.id] = imagen;
                    if (hija.photo != nil) {
                        MemoriaHistoriaClinica.ordenHija[imagenLesion.id!]?.append(hija.id!);
                        let nombre = self.generarNombreImagen(imagen: hija);
                        
                        if (Funcionales.dispositivoEstaConectado) {
                            self.descargarImagenHija(imagenHija: hija, nombre: nombre, padre: imagenLesion);
                        }
                    }
                }
            }
        }
        self.coleccionImagenes.reloadData();
    }
    
    /**
     Permite descargar las imágenes padre de la consulta o controles y actualizar la vista de la colección.
     - Parameter imagenUrl: Corresponde a la url desde donde se descarga la imagen.
     - Parameter nombre: Corresponde al texto del nombre con el cual se guarda la imagen en el dispositivo.
     - Parameter celda: Corresponde a la celda de la colección a la cual pertenece la imagen.
     - Parameter fila: Corresponde a la fila de la lista de elementos que están en el selector.
     */
    private func descargarImagenPadre (imagenUrl: String, nombre: String, celda: ImagenCollectionViewCell, fila: Int) {
        let imagenLesion = self.listaImagenesLesionConsulta[fila].id;
        MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]![imagenLesion!] = self.imagenCargando;
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imagenFallida = UIImage(named: "error_cargar");
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                let resultado = Funcionales.descargarImagenSincrono(imagenUrl: imagenUrl);
                DispatchQueue.main.async(execute: {
                    switch (resultado.result) {
                    case let .success(image):
                        
                        var imageData: Data? = nil;
                        if let data = image.jpegData(compressionQuality: 0.8) {
                            imageData = data;
                        } else if let data = image.pngData() {
                            imageData = data;
                        }
                        
                        if(imageData != nil) {
                            
                            let filename = tDocumentDirectory.appendingPathComponent(nombre);
                            do {
                                try imageData!.write(to: filename);
                                celda.imagen.image = image;
                                // Se valida que el id esté en la lista de orden para evitar agregar imágenes que no pertenecen.
                                if (MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag] != nil) {
                                    if (MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag]!.contains(imagenLesion!)) {
                                        MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]![imagenLesion!] = image;
                                    }
                                }
                            } catch {
                                celda.imagen.image = imagenFallida;
                            }
                            celda.imagen.contentMode = .scaleAspectFill;
                        }
                        break;
                        
                    case let .failure(error):
                        print(error);
                        celda.imagen.image = imagenFallida;
                        
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                        break;
                    }
                    
                });
            });
        }
    }
    
    /**
     Permite descargar las imágenes hijas de la consulta o controles y actualizar la vista de la colección.
     - Parameter imagenUrl: Corresponde a la url desde donde se descarga la imagen.
     - Parameter nombre: Corresponde al texto del nombre con el cual se guarda la imagen en el dispositivo.
     - Parameter padre: Corresponde a la imagen lesión padre a la cual pertenece.
     */
    private func descargarImagenHija (imagenHija: ImagenLesion, nombre: String, padre: ImagenLesion) {
        
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                let resultado = Funcionales.descargarImagenSincrono(imagenUrl: imagenHija.photo!);
                DispatchQueue.main.async(execute: {
                    switch (resultado.result) {
                    case let .success(image):
                        
                        var imageData: Data? = nil;
                        if let data = image.jpegData(compressionQuality: 0.8) {
                            imageData = data;
                        } else if let data = image.pngData() {
                            imageData = data;
                        }
                        
                        if(imageData != nil) {
                            
                            let filename = tDocumentDirectory.appendingPathComponent(nombre);
                            do {
                                try imageData!.write(to: filename);
                                // Se valida que el id esté en la lista de orden para evitar agregar imágenes que no pertenecen.
                                if (MemoriaHistoriaClinica.imagenesHijas[padre.id!] == nil) {
                                    MemoriaHistoriaClinica.imagenesHijas[padre.id!] = [:];
                                }
                                if (MemoriaHistoriaClinica.ordenHija[padre.id!]!.contains(imagenHija.id!)) {
                                    MemoriaHistoriaClinica.imagenesHijas[padre.id!]![imagenHija.id!] = image;
                                }
                            } catch {
                                
                            }
                        }
                        break;
                        
                    case let .failure(error):
                        print(error);
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                        break;
                    }
                });
            });
        }
    }
    
    private func generarNombreImagen (imagen: ImagenLesion) -> String {
        var consultaControlTexto: String? = nil;
        if (self.btnControles.tag == 0) {
            consultaControlTexto = "CONSULTA\(self.consulta.id!.description)";
        } else {
            let control = self.listaControles[self.btnControles.tag];
            consultaControlTexto = "CONTROL\(control.id!.description)";
        }
        // GRUPO IDImagen IDImagenPadre IDLesion IDControl/Consulta
        let nombreFinal = "\(Constantes.GRUPO_LESION)\(imagen.id!.description)_\(imagen.image_injury_id ?? "")_\(imagen.injury_id!)_\(consultaControlTexto ?? "").png";
        return nombreFinal;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionControl(_ sender: UIButton) {
        self.mostrarPickerSelectores(titulo: Mensajes.SELECCIONAR_CONTROL);
    }
    
}

extension InternoImagenesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listaImagenesLesionConsulta.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda_interno_imagen", for: indexPath) as! ImagenCollectionViewCell;
        let imagen = self.listaImagenesLesionConsulta[indexPath.row];
        
        
        celda.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        celda.layer.borderWidth = Constantes.BORDE_GROSOR;
        celda.layer.borderColor = Constantes.BORDE_COLOR;
        
        // El nombre de la imagen es IDImagen, IDLesion, IDConsulta/IDControl
        let nombreFinal = self.generarNombreImagen(imagen: imagen);
        
        // Se valida para descargar si es primera vez o precargar desde memoria.
        if (MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]![imagen.id!] == nil || MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]![imagen.id!] == self.imagenCargando) {
            celda.imagen.image = self.imagenCargando;
            celda.imagen.contentMode = .scaleAspectFit;
            MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]![imagen.id!] = self.imagenCargando;
            
            if (Funcionales.dispositivoEstaConectado) {
                self.descargarImagenPadre(imagenUrl: imagen.photo!, nombre: nombreFinal, celda: celda, fila: indexPath.row);
            }
        } else {
            if let imagenGuardada = MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]![imagen.id!] {
                celda.imagen.image = imagenGuardada;
                celda.imagen.contentMode = .scaleAspectFill;
            }
        }
        
        // Se valida si tiene imagenes internas dermatoscopía.
        let imagenesDermatoscopia = MemoriaHistoriaClinica.imagenesLesiones.filter({$0.image_injury_id == imagen.id?.description});
        
        if (imagenesDermatoscopia.count > 0) {
            celda.lblImagenesPadre.text = "Imágenes dermatoscópicas - \(imagenesDermatoscopia.count)";
            celda.lblImagenesPadre.isHidden = false;
        } else {
            celda.lblImagenesPadre.isHidden = true;
        }
        
        return celda;
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listaControles.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listaControles[row].created_at;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.btnControles.tag = row;
        MemoriaHistoriaClinica.posicionControlActivo = row;
        self.viewSelectorController.dismiss(animated: true, completion: nil);
        self.cargarInformacionControl();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celda = collectionView.cellForItem(at: indexPath) as! ImagenCollectionViewCell;
        if (celda.imagen.image != self.imagenCargando) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_imagen_historia_clinica") as! ImagenHistoriaClinicaViewController;
            
            vc.imagenPrincipal = celda.imagen.image;
            vc.listaImagenesPadre = MemoriaHistoriaClinica.imagenesPadre[self.btnControles.tag]!;
            vc.listaImagenesHijas = MemoriaHistoriaClinica.imagenesHijas;
            vc.orden = MemoriaHistoriaClinica.ordenPadre[self.btnControles.tag]!;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
}
