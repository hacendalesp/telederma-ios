//
//  RegistroPacienteViewController2.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 12/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SearchTextField

class RegistroPacienteViewController2: UIViewController {
    // Header
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var imgFooter: UIImageView!
    
    // Campos de texto
    @IBOutlet weak var txtPeso: UITextField!
    @IBOutlet weak var txtTiempo: UITextField!
    @IBOutlet weak var txtFactoresAgravantes: UITextField!
    @IBOutlet weak var txtAntecedentesFamiliares: UITextField!
    @IBOutlet weak var txtAntecedentesPersonales: UITextView!
    @IBOutlet weak var txtTratamientoRecibido: UITextField!
    @IBOutlet weak var txtOtrasSustancias: UITextField!
    @IBOutlet weak var txtEfectoTratamiento: UITextField!
    @IBOutlet weak var txtImpresionDiagnostica: SearchTextField!
    
    // Botones
    @IBOutlet weak var btnUnidadMedida: UIButton!
    @IBOutlet weak var btnNumeroLesiones: UIButton!
    
    // Switches
    @IBOutlet weak var switchSangran: UISegmentedControl!
    @IBOutlet weak var switchExudan: UISegmentedControl!
    @IBOutlet weak var switchSupuran: UISegmentedControl!
    @IBOutlet weak var switchOtrosFactores: UISwitch!
    @IBOutlet weak var switchAntecedentes: UISwitch!
    @IBOutlet weak var switchTratamiento: UISwitch!
    @IBOutlet weak var switchOtrasSusteancias: UISwitch!
    @IBOutlet weak var switchEfectoTratamiento: UISwitch!
    
    
    // Vistas
    @IBOutlet weak var vistaSintomas: UIView!
    @IBOutlet weak var vistaCambiosEvidentes: UIView!
    @IBOutlet weak var vistaAntecedentes: UIView!
    @IBOutlet weak var vistaEmpeoran: UIView!
    @IBOutlet weak var vistaEvolucion: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Altos de elementos a ocultar
    @IBOutlet weak var altoOtrosFactores: NSLayoutConstraint!
    @IBOutlet weak var altoAntecedentes: NSLayoutConstraint!
    @IBOutlet weak var altoTratamiento: NSLayoutConstraint!
    @IBOutlet weak var altoOtrasSustancias: NSLayoutConstraint!
    @IBOutlet weak var altoEfectoTratamiento: NSLayoutConstraint!
    
    // Altos mínimos para elementos dínamicos
    @IBOutlet weak var altoMinimoCambios: NSLayoutConstraint!
    @IBOutlet weak var altoMinimoSintomas: NSLayoutConstraint!
    @IBOutlet weak var altoMinimoEmpeoran: NSLayoutConstraint!
    @IBOutlet weak var altoMinimoEvolucion: NSLayoutConstraint!
    
    @IBOutlet weak var btnSiguiente: UIButton!
    
    // Se declaran los altos iniciales para los elementos que se desea ocultar
    var antecedentesHeightVisible: CGFloat!;
    var otrosFactoresHeightVisible: CGFloat!;
    var tratamientoHeightVisible: CGFloat!;
    var otrasSustanciasHeightVisible: CGFloat!;
    var efectoTratamientoHeightVisible: CGFloat!;
    var empeoranHeightVisible: CGFloat!;
    // Se declara un height visible auxiliar que tomará temporalmente el valor de la capa a interactuar.
    var auxiliarHeightVisible: CGFloat!;
    
    // Se declara la conexión para hacer las consultas
    let conexion = Conexion();
    
    // Variables para almacenar elección del usuario
    var sintomasSeleccionados = [String]();
    var empeoranSeleccionado = 0;
    var evolucionSeleccionados = [String]();
    var unidadMedidaSeleccionada = 0;
    var numeroLesionesInicialesSeleccionada = 0;
    var impresionDiagnosticaSeleccionada = String();
    
    // Se declara un arreglo para manejar los botones que se comportan como radios.
    var botonosEmpeoran = [UIButton]();
    var botonesSintomas = [UIButton]();
    
    // Permiten cargar en memoria la información traída de la base de datos.
    var listaUnidadMedida = [ConstanteValor]();
    var listaNumeroLesionesIniciales = [ConstanteValor]();
    var listaImpresionDiagnostica = [Cie10]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        
        // Se ajustan estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.btnUnidadMedida.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnNumeroLesiones.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.btnUnidadMedida.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnUnidadMedida.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnNumeroLesiones.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnNumeroLesiones.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.txtAntecedentesPersonales.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtAntecedentesPersonales.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Se ocultan las opciones de acompañante y resonsable al iniciar la vista.
        self.antecedentesHeightVisible = self.altoAntecedentes.constant;
        self.vistaAntecedentes.isHidden = true;
        self.altoAntecedentes.constant = 0;
        
        self.otrosFactoresHeightVisible = self.altoOtrosFactores.constant;
        self.txtFactoresAgravantes.isHidden = true;
        self.altoOtrosFactores.constant = 0;
        
        self.tratamientoHeightVisible = self.altoTratamiento.constant;
        self.txtTratamientoRecibido.isHidden = true;
        self.altoTratamiento.constant = 0;
        
        self.otrasSustanciasHeightVisible = self.altoOtrasSustancias.constant;
        self.txtOtrasSustancias.isHidden = true;
        self.altoOtrasSustancias.constant = 0;
        
        self.efectoTratamientoHeightVisible = self.altoEfectoTratamiento.constant;
        self.txtEfectoTratamiento.isHidden = true;
        self.altoEfectoTratamiento.constant = 0;
        
        self.empeoranHeightVisible = self.altoMinimoEmpeoran.constant;
        self.vistaEmpeoran.isHidden = true;
        self.altoMinimoEmpeoran.constant = 0;
        
        self.switchExudan.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected);
        self.switchSangran.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected);
        self.switchSupuran.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected);
        
        self.switchExudan.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal);
        self.switchSangran.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal);
        self.switchSupuran.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal);
        
        // Se valida si ya se ha diligenciado todo el proceso y está activo terminación
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.btnSiguiente.setTitle(Mensajes.TEXTO_BOTON_RESUMEN, for: .normal);
        }
        
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        
        // Se obtiene la conexión con la base de datos.
        self.conexion.conectarBaseDatos();
        
        // Carga de información
        self.cargarInformacionSelectores();
    }
    
    
    
    /**
     Permite consultar en la base de datos, la información que se debe mostrar en las listas desplegables.
     */
    private func cargarInformacionSelectores () {
        // Se declara un objeto ConstanteValor por defecto para los campos de constantes.
        let constanteValorDefault = ConstanteValor();
        constanteValorDefault.value = 0;
        constanteValorDefault.title = Mensajes.CAMPO_SELECCIONAR;
        constanteValorDefault.id = 0;
        
        // Se crea un objeto Cie10 por defecto para anteponer la opción Selección, con valor 0
        let impresionDiagnosticaDefault = Cie10();
        impresionDiagnosticaDefault.name = Mensajes.CAMPO_SELECCIONAR;
        impresionDiagnosticaDefault.id = 0;
        
        self.listaUnidadMedida = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "unit_measurement");
        self.listaUnidadMedida.insert(constanteValorDefault, at: 0);
        
        self.listaNumeroLesionesIniciales = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "number_injuries");
        self.listaNumeroLesionesIniciales.insert(constanteValorDefault, at: 0);
        
        self.listaImpresionDiagnostica = FachadaIndependientesSQL.seleccionarTodoCie10(conexion: conexion);
        self.listaImpresionDiagnostica.insert(impresionDiagnosticaDefault, at: 0);
        
        // Así como se prepararon los demás elemmentos especiales, se procede con el buscador de Impresión Diagnóstica.
        self.prepararImpresionDiagnosticaAutocompletar();
        
        // Se termina de crear el resto de la información
        self.crearEvoluciones();
        self.crearSintomas();
        self.crearEmpeoran();
        self.precargarInformacion();
    }
    
    /**
     Permite configurar y preparar el campo de texto de Impresión Diagnóstica para poder buscar y seleccionar entre las opciones.
     */
    private func prepararImpresionDiagnosticaAutocompletar () {
        // Se configuran las variables de estilos y el comportamiento de la lista.
        self.txtImpresionDiagnostica.theme.font = UIFont.systemFont(ofSize: 13);
        self.txtImpresionDiagnostica.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.95);
        self.txtImpresionDiagnostica.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1);
        self.txtImpresionDiagnostica.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8);
        self.txtImpresionDiagnostica.theme.fontColor = .black;
        self.txtImpresionDiagnostica.theme.placeholderColor = .lightGray;
        self.txtImpresionDiagnostica.theme.cellHeight = 50;
        self.txtImpresionDiagnostica.comparisonOptions = .caseInsensitive;
        self.txtImpresionDiagnostica.minCharactersNumberToStartFiltering = 3;
        // Al seleccionar una opción se muestra el nombre en el campo de texto y se consulta en la base de datos para obtener el ID.
        self.txtImpresionDiagnostica.itemSelectionHandler = {
            item, itemPosition in
            // Se obtiene el nombre del elemento seleccionado de la lista.
            let nombre = item[itemPosition].title;
            // Se valida si ese nombre existe en la base de datos. Se crea un objeto con el resultado de la consulta en BD.
            if let cie10 = FachadaIndependientesSQL.seleccionarPorNombreCie10(conexion: self.conexion, nombre: nombre) {
                // Del objeto creado por medio de la consulta a BD se obtiene el ID para se guardado en la variable impresionDiagnosticaSeleccionada.
                self.impresionDiagnosticaSeleccionada = cie10.code!;
                // Se asigna ese nombre como valor en el campo de texto que inició la búsqueda.
                self.txtImpresionDiagnostica.text = "\(cie10.name!) - \(cie10.code!)";
            } else {
                // Si no hay coincidencias en la base de datos, entonces se inicializa el valor de la variable aseguradoraSeleccionada en 0.
                self.impresionDiagnosticaSeleccionada = "";
                Funcionales.vaciarCamposTexto(campos: [self.txtImpresionDiagnostica]);
            }
        }
        
        self.transformarInformacionImpresionDiagnostica();
    }
    
    /**
     Permite tomar la lista de aseguradoras en memoria y pasarla a SearchTextFieldItem's para que se puedan mostrar y seleccionar.
     Esto sucede si la lista tiene al menos un elemento. De manera inmediata se cargan al campo de texto a través del método filterItems de la librería.
     */
    private func transformarInformacionImpresionDiagnostica () {
        if (self.listaImpresionDiagnostica.count > 0) {
            var listaBusqueda = [SearchTextFieldItem]();
            for cie10 in self.listaImpresionDiagnostica {
                let item = SearchTextFieldItem(title: cie10.name!, subtitle: nil, image: nil);
                listaBusqueda.append(item);
            }
            self.txtImpresionDiagnostica.filterItems(listaBusqueda);
        }
    }
    
    /**
     Permite mostrar un modal para la selección de las opciones de tipo de profesional.
     No requiere de parámetros y no retorna.
     */
    private func mostrarPickerSelectores (grupo: String, titulo: String) {
        // Se declara un tag que permita identificar sobre cuál picker trabajarán los delegados.
        var tag = 0;
        // Se declara una variable que permitira precargar el selector cuando el valor es mayor a 0.
        var itemSeleccionado = 0;
        // Se reinicia el valor por defecto a la variable que representa la selección del usuario.
        switch grupo {
        case "unit_measurement":
            itemSeleccionado = self.unidadMedidaSeleccionada;
            tag = 1;
        case "number_injuries":
            itemSeleccionado = self.numeroLesionesInicialesSeleccionada;
            tag = 2;
            
        default:
            self.unidadMedidaSeleccionada = 0;            
        }
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200));
        pickerView.tag = tag;
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        // si es mayor a cero es que ya ha sido seleccionado y se ubica en el selector.
        if (itemSeleccionado > 0) {
            pickerView.selectRow(itemSeleccionado, inComponent: 0, animated: true);
        }
        
        vc.view.addSubview(pickerView);
        
        let opcionesAlert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert);
        opcionesAlert.setValue(vc, forKey: "contentViewController");
        opcionesAlert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil));
        
        self.present(opcionesAlert, animated: true);
    }
    
    /**
     Permite crear la lista de evoluciones desde la base de datos interna.
     */
    private func crearEvoluciones () {
        let listaEvoluciones = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "evolution_injuries");
        let cantidadEvoluciones = listaEvoluciones.count;
        if (cantidadEvoluciones > 0) {
            var altoSiguienteBoton = 0;
            let anchoBoton = Constantes.BOTON_DINAMICO_ANCHO;
            let altoBoton = Constantes.BOTON_DINAMICO_ALTO;
            // Ajustar el alto de la vista de síntomas según la cantidad de elementos.
            self.altoMinimoEvolucion.constant *= CGFloat(cantidadEvoluciones);
            for item in listaEvoluciones {
                let button = UIButton(type: .custom);
                button.setTitle(item.title, for: .normal);
                button.setTitleColor(.darkGray, for: .normal);
                button.frame = CGRect(x: Constantes.BOTON_DINAMICO_X, y: altoSiguienteBoton, width: anchoBoton, height: altoBoton);
                button.contentHorizontalAlignment = .left;
                button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
                button.tag = item.value!;
                button.tintColor = .darkGray;
                button.titleEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO;
                button.imageEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN;
                button.addTarget(self, action: #selector(self.accionCambiarEvolucion(sender:)), for: .touchUpInside);
                
                // Posición en Y para el siguiente botón
                altoSiguienteBoton += altoBoton + Constantes.BOTON_DINAMICO_SIGUIENTE_BOTON_Y;
                
                // Precarga de información
                if let informacionConsultaAlmacenada = MemoriaRegistroConsulta.consultaMedica {
                    
                    let arregloEvolucionLesiones = informacionConsultaAlmacenada.evolution_injuries?.split(separator: ",");
                    
                    if (arregloEvolucionLesiones!.count > 0) {
                        
                        // Si el item que se está creando, es uno de los que habían sido seleccionados.
                        if(arregloEvolucionLesiones!.contains(Substring(item.value!.description))) {
                            self.accionCambiarEvolucion(sender: button);
                        }
                    }
                }
                
                self.vistaEvolucion.addSubview(button);
            }
        }
    }
    
    
    /**
     Permite crear la lista de síntomas desde la base de datos interna.
     */
    private func crearSintomas () {
        let listaSintomas = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "symptom");
        let cantidadSintomas = listaSintomas.count;
        if (cantidadSintomas > 0) {
            var altoSiguienteBoton = 0;
            let anchoBoton = Constantes.BOTON_DINAMICO_ANCHO;
            let altoBoton = Constantes.BOTON_DINAMICO_ALTO;
            // Ajustar el alto de la vista de síntomas según la cantidad de elementos.
            self.altoMinimoSintomas.constant *= CGFloat(cantidadSintomas);
            for item in listaSintomas {
                let button = UIButton(type: .custom);
                button.setTitle(item.title, for: .normal);
                button.setTitleColor(.darkGray, for: .normal);
                button.frame = CGRect(x: Constantes.BOTON_DINAMICO_X, y: altoSiguienteBoton, width: anchoBoton, height: altoBoton);
                button.contentHorizontalAlignment = .left;
                // Si es diferente de NINGUNO, mientra no exista información guardada.
                if (item.value! != 4) {
                    button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
                } else {
                    // Al crear validando información existente.
                    // Si está creando NINGUNO y ya hay elementos, no se incluye como seleccionado por defecto.
                    if (self.sintomasSeleccionados.contains("4") || MemoriaRegistroConsulta.consultaMedica == nil) {
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_ON), for: .normal);
                        self.sintomasSeleccionados.append(item.value!.description);
                    } else {
                        // Se crea apagado y no se añade a la lista de seleccionados.
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
                    }
                    self.botonesSintomas.append(button);
                }
                
                button.tag = item.value!;
                button.tintColor = .darkGray;
                button.titleEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO;
                button.imageEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN;
                button.addTarget(self, action: #selector(self.accionCambiarSintoma(sender:)), for: .touchUpInside);
                
                altoSiguienteBoton += altoBoton + Constantes.BOTON_DINAMICO_SIGUIENTE_BOTON_Y;
                
                // Precarga de información
                if let informacionConsultaAlmacenada = MemoriaRegistroConsulta.consultaMedica {
                    
                    let arregloSintomas = informacionConsultaAlmacenada.symptom?.split(separator: ",");
                    
                    if (arregloSintomas!.count > 0) {
                        
                        // Si el item que se está creando, es uno de los que habían sido seleccionados.
                        if(arregloSintomas!.contains(Substring(item.value!.description))) {
                            self.accionCambiarSintoma(sender: button);
                        }
                    }
                }
                
                self.vistaSintomas.addSubview(button);
            } // End for
        }
    }
    
    /**
     Permite crear la lista de síntomas desde la base de datos interna.
     */
    private func crearEmpeoran () {
        let listaEmpeoran = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "change_symptom");
        let cantidadEmpeoran = listaEmpeoran.count;
        if (cantidadEmpeoran > 0) {
            var altoSiguienteBoton = 0;
            let anchoBoton = Constantes.BOTON_DINAMICO_ANCHO;
            let altoBoton = Constantes.BOTON_DINAMICO_ALTO;
            // Ajustar el alto de la vista de síntomas según la cantidad de elementos.
            let altoTotalVista = Constantes.VISTA_DINAMICA_ALTO * CGFloat(cantidadEmpeoran);
            self.empeoranHeightVisible = altoTotalVista;
            for item in listaEmpeoran {
                let button = UIButton(type: .custom);
                button.setTitle(item.title, for: .normal);
                button.setTitleColor(.darkGray, for: .normal);
                button.frame = CGRect(x: Constantes.BOTON_DINAMICO_X, y: altoSiguienteBoton, width: anchoBoton, height: altoBoton);
                button.contentHorizontalAlignment = .left;
                
                if (item.value == 3) {
                    if (MemoriaRegistroConsulta.consultaMedica == nil || MemoriaRegistroConsulta.consultaMedica?.change_symptom == 3) {
                        
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
                        self.empeoranSeleccionado = item.value!;
                    } else {
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                    }
                } else {
                    button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                }
                button.tag = item.value!;
                button.tintColor = .darkGray;
                button.titleEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO;
                button.imageEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN;
                button.addTarget(self, action: #selector(self.accionCambiarEmpeora(sender:)), for: .touchUpInside);
                self.botonosEmpeoran.append(button);
                
                altoSiguienteBoton += altoBoton + Constantes.BOTON_DINAMICO_SIGUIENTE_BOTON_Y;
                
                // Precarga de información
                if let informacionConsultaAlmacenada = MemoriaRegistroConsulta.consultaMedica {
                    
                    if (item.value == informacionConsultaAlmacenada.change_symptom) {
                        
                        // Se actualiza el botón
                        self.accionCambiarEmpeora(sender: button);
                    }
                }
                
                self.vistaEmpeoran.addSubview(button);
            } // End for
        }
        
        if(!self.sintomasSeleccionados.contains("4")) {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaEmpeoran, altoInicial: self.altoMinimoEmpeoran, altoAuxiliar: self.empeoranHeightVisible, animado: true);
        }
    }
    
    
    /**
     Permite controlar la elección de evoluciones y actualizar el boton para mostrarse según la acción del usuario: seleccionado o no.
     */
    @objc func accionCambiarEvolucion(sender: UIButton!) {
        // Si el id del evolución ya se encuentra en los seleccionados ...
        if let index = self.evolucionSeleccionados.firstIndex(of: sender.tag.description) {
            sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
            self.evolucionSeleccionados.remove(at: index);
        } else {
            sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_ON), for: .normal);
            self.evolucionSeleccionados.append(sender.tag.description);
        }
    }
    
    private func quitarSeleccionBotonesSintomas (unico: Int?) {
        // Los botones si se eliminan de la lista
        if (self.botonesSintomas.count > 0) {
            for boton in self.botonesSintomas {
                if (unico != nil) {
                    if (boton.tag == unico) {
                        boton.setImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
                        break;
                    }
                } else {
                    boton.setImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
                }
            }
        }
    }
    
    /**
     Permite controlar la elección de síntomas y actualizar el boton para mostrarse según la acción del usuario: seleccionado o no.
     */
    @objc func accionCambiarSintoma(sender: UIButton!) {
        // Si el id del síntoma ya se encuentra en los seleccionados ...
        if let index = self.sintomasSeleccionados.firstIndex(of: sender.tag.description) {
            self.quitarSeleccionBotonesSintomas(unico: sender.tag);
            sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
            self.sintomasSeleccionados.remove(at: index);
        } else {
            if (sender.tag == 4) {
                self.quitarSeleccionBotonesSintomas(unico: nil);
                self.sintomasSeleccionados = [];
                
                // Se resetea empeora
                self.quitarSeleccionBotonesEmpeoran();
                // Se añade el botón con opción No
                if let botonNo = self.botonosEmpeoran.first(where: {$0.tag == 3}) {
                    self.accionCambiarEmpeora(sender: botonNo);
                }
                
                // Cuando se selecciona NINGUNO entonces se oculta Empeora
                Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaEmpeoran, altoInicial: self.altoMinimoEmpeoran, animado: true);
            } else {
                self.quitarSeleccionBotonesSintomas(unico: 4);
                if let unico = self.sintomasSeleccionados.firstIndex(of: "4") {
                    self.sintomasSeleccionados.remove(at: unico);
                }
                // Cuando se selecciona diferente de NINGUNO se debe habilitar Empeoran
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaEmpeoran, altoInicial: self.altoMinimoEmpeoran, altoAuxiliar: self.empeoranHeightVisible, animado: true);
            }
            self.sintomasSeleccionados.append(sender.tag.description);
            sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_ON), for: .normal);
            self.botonesSintomas.append(sender);
        }
    }
    
    private func quitarSeleccionBotonesEmpeoran () {
        // Los botones no se eliminan de la lista, se usan para desactivarlos.
        if (self.botonosEmpeoran.count > 0) {
            for boton in self.botonosEmpeoran {
                boton.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            }
            self.empeoranSeleccionado = 0;
        }
    }
    
    /**
     Permite controlar la elección de empeora y actualizar el boton para mostrarse según la acción del usuario: seleccionado o no.
     */
    @objc func accionCambiarEmpeora(sender: UIButton!) {
        self.quitarSeleccionBotonesEmpeoran();
        
        sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
        self.empeoranSeleccionado = sender.tag;
    }
    
    /**
     Permite validar si los datos obligatorios del formuario se diligenciaron correctamente.
     - Returns: Devuelve True si todo es correcto y False en caso contrario.
     */
    private func sonCamposCorrectos () -> Bool {
        
        // Mostrar modal cuando diagnóstico está vacío
        // Se evalúa si el usuario seleccionó alguna Impresion Diagnostica.
        // Por defecto 4569, Trastorno de la piel y del tejido subcutáneo, no especificado
        var impresionDiagnosticaOK = false;
        if (self.impresionDiagnosticaSeleccionada == "") {
            let accionAceptar = UIAlertAction(title: "Continuar", style: .default, handler: {
                (UIAlertAction) in
                if let cie10 = FachadaIndependientesSQL.seleccionarPorIdCie10(conexion: self.conexion, idRegistro: 4568) {
                    self.txtImpresionDiagnostica.text = "\(cie10.name!) - \(cie10.code!)";
                    self.impresionDiagnosticaSeleccionada = cie10.code!;
                    self.txtImpresionDiagnostica.becomeFirstResponder();
                    self.scrollView.scrollToBottom();
                    Validacion.pintarCorrectoCampoFormulario(view: self.txtImpresionDiagnostica, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
                    impresionDiagnosticaOK = true;
                } else {
                    Funcionales.vaciarCamposTexto(campos: [self.txtImpresionDiagnostica]);
                    self.impresionDiagnosticaSeleccionada = "";
                }
            });
            let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil);
            let alertaImpresionDiagnostica = UIAlertController(title: "¿Estás seguro de no agregar una impresión diagnóstica?", message: "El sistema agregará por defecto el CIE10 Trastorno de la piel y del tejido subcutáneo, no especificado.", preferredStyle: .alert);
            alertaImpresionDiagnostica.addAction(accionAceptar);
            alertaImpresionDiagnostica.addAction(accionCancelar);
            
            self.present(alertaImpresionDiagnostica, animated: true, completion: nil);
        } else {
            impresionDiagnosticaOK = true;
        }
        
        let campos = [self.txtPeso!, self.txtTiempo!];
        
        // Primero se valida que los campos de texto no estén vacíos.
        let camposVaciosOK = !Validacion.sonCamposVacios(textos: campos);
        // Si no pasa la validación de campos vacíos no continúa con la siguientes validaciones.
        if !camposVaciosOK {
            Validacion.pintarErrorCampoFormulario(view: self.txtPeso.text!.isEmpty ? self.txtPeso : self.txtTiempo);
            (self.txtPeso.text!.isEmpty ? self.txtPeso : self.txtTiempo).becomeFirstResponder();
            self.scrollView.scrollToView(view: self.txtPeso, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            return false;
        }
        
        // Se evalúan los campos numéricos
        let camposNumericosOK = Validacion.sonCamposNumericos(textos: [self.txtPeso, self.txtTiempo]);
        // Si no pasa la validación de campos numéricos no contnúa con la siguiente.
        if !camposNumericosOK {
            Validacion.pintarErrorCampoFormulario(view: self.txtPeso.text!.isEmpty ? self.txtPeso : self.txtTiempo);
            (self.txtPeso.text!.isEmpty ? self.txtPeso : self.txtTiempo).becomeFirstResponder();
            self.scrollView.scrollToView(view: self.txtPeso, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_NUMEROS);
            return false;
        }
        
        
        // Se evalúa número máximo de caracteres peso.
        let pesoOK = Validacion.sonCamposCaracteresMaximos(campos: [self.txtPeso], max: 4);
        // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
        if !pesoOK {
            Validacion.pintarErrorCampoFormulario(view: self.txtPeso);
            self.txtPeso.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.txtPeso, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MAXIMO_CARACTERES) 4");
            return false;
        }
        
        // Se evalúa número máximo de caracteres tiempo.
        let tiempoOK = Validacion.sonCamposCaracteresMaximos(campos: [self.txtTiempo], max: 2);
        // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
        if !tiempoOK {
            Validacion.pintarErrorCampoFormulario(view: self.txtTiempo);
            self.txtTiempo.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.txtTiempo, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MAXIMO_CARACTERES) 2");
            return false;
        }
        
        
        // Se evalúa si se ha seleccionado un unidad de medida.
        let unidadMedidaOK = (self.unidadMedidaSeleccionada > 0) ? true : false;
        if !unidadMedidaOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnUnidadMedida);
            self.txtTiempo.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnUnidadMedida, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_UNIDAD_MEDIDA);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnUnidadMedida, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado el número de lesiones iniciales.
        let numeroLesionesInicialesOK = (self.numeroLesionesInicialesSeleccionada > 0) ? true : false;
        if !numeroLesionesInicialesOK {
            Validacion.pintarErrorCampoFormulario(view: self.btnNumeroLesiones);
            self.txtTiempo.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.btnNumeroLesiones, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_NUMERO_LESIONES_INICIALES);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnNumeroLesiones, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado una evolución.
        let evaluacionLesionesOK = (self.evolucionSeleccionados.count > 0) ? true : false;
        if !evaluacionLesionesOK {
            Validacion.pintarErrorCampoFormulario(view: self.vistaEvolucion);
            self.txtTiempo.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.vistaEvolucion, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_EVOLUCION_LESIONES);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.vistaEvolucion, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        // Se evalúa si se ha seleccionado un síntoma.
        let sintomasOK = (self.sintomasSeleccionados.count > 0) ? true : false;
        if !sintomasOK {
            Validacion.pintarErrorCampoFormulario(view: self.vistaSintomas);
            self.txtImpresionDiagnostica.becomeFirstResponder();
            self.scrollView.scrollToView(view: self.vistaSintomas, animated: true);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_SINTOMAS);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.vistaSintomas, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        
        if (!impresionDiagnosticaOK) {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_IMPRESION_DIAGNOSTICA);
            return false;
        }
        
        return true;
    }
    
    /**
     Permite rellenar el formulario cuando el usuario pasa del paso 3 al paso 2.
     No aplica cuando pasa del paso 1 al paso 2 la primera vez.
     */
    private func precargarInformacion () {
        if let informacionConsultaAlmacenada = MemoriaRegistroConsulta.consultaMedica {
            
            self.txtPeso.text = informacionConsultaAlmacenada.weight;
            self.txtTiempo.text = informacionConsultaAlmacenada.evolution_time?.description;
            
            // Unidad de medida
            if let unidadMedidaId = informacionConsultaAlmacenada.unit_measurement {
                
                // Se busca el índice donde coincida el ID dentro de la lista.
                if let unidadFila = self.listaUnidadMedida.firstIndex(where: {$0.value == unidadMedidaId}) {
                    
                    self.unidadMedidaSeleccionada = unidadFila;
                    Funcionales.ajustarTextoBotonSelector(boton: self.btnUnidadMedida, texto: self.listaUnidadMedida[self.unidadMedidaSeleccionada].title!);
                }
            }
            
            // Número de lesiones
            if let numeroLesionesId = informacionConsultaAlmacenada.number_injuries {
                
                // Se busca el índice donde coincida el ID dentro de la lista.
                if let numeroLesionesFila = self.listaNumeroLesionesIniciales.firstIndex(where: {$0.value == numeroLesionesId}) {
                    
                    self.numeroLesionesInicialesSeleccionada = numeroLesionesFila;
                    Funcionales.ajustarTextoBotonSelector(boton: self.btnNumeroLesiones, texto: self.listaNumeroLesionesIniciales[self.numeroLesionesInicialesSeleccionada].title!);
                }
            }
            
            // La precarga de los evolución se hace en la creación
            // La precarga de los síntomas se hace en la creación
            // La precarga de los empeoran se hace en la creación
            
            self.switchSangran.selectedSegmentIndex = informacionConsultaAlmacenada.blood ?? false ? 0 : 1;
            
            self.switchExudan.selectedSegmentIndex =  informacionConsultaAlmacenada.exude ?? false ? 0 : 1;
            
            self.switchSupuran.selectedSegmentIndex =  informacionConsultaAlmacenada.suppurate ?? false ? 0 : 1;
            
            self.switchOtrosFactores.isOn = informacionConsultaAlmacenada.other_factors_is_on ?? false;
            self.switchAntecedentes.isOn = informacionConsultaAlmacenada.history_is_on ?? false;
            self.switchTratamiento.isOn = informacionConsultaAlmacenada.treatment_received_is_on ?? false;
            self.switchOtrasSusteancias.isOn = informacionConsultaAlmacenada.other_substances_is_on ?? false;
            self.switchEfectoTratamiento.isOn = informacionConsultaAlmacenada.treatment_effects_is_on ?? false;
            
            // Se muestran las vistas si están activos.
            if (self.switchOtrosFactores.isOn) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtFactoresAgravantes, altoInicial: self.altoOtrosFactores, altoAuxiliar: self.otrosFactoresHeightVisible, animado: true);
            }
            
            if (self.switchTratamiento.isOn) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtTratamientoRecibido, altoInicial: self.altoTratamiento, altoAuxiliar: self.tratamientoHeightVisible, animado: true);
            }
            
            if (self.switchAntecedentes.isOn) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaAntecedentes, altoInicial: self.altoAntecedentes, altoAuxiliar: self.antecedentesHeightVisible, animado: true);
            }
            
            if (self.switchOtrasSusteancias.isOn) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtOtrasSustancias, altoInicial: self.altoOtrasSustancias, altoAuxiliar: self.otrasSustanciasHeightVisible, animado: true);
            }
            
            if (self.switchEfectoTratamiento.isOn) {
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtEfectoTratamiento, altoInicial: self.altoEfectoTratamiento, altoAuxiliar: self.efectoTratamientoHeightVisible, animado: true);
            }
            
            self.txtFactoresAgravantes.text = informacionConsultaAlmacenada.aggravating_factors;
            self.txtAntecedentesPersonales.text = informacionConsultaAlmacenada.personal_history;
            self.txtAntecedentesFamiliares.text = informacionConsultaAlmacenada.family_background;
            self.txtTratamientoRecibido.text = informacionConsultaAlmacenada.treatment_received;
            self.txtOtrasSustancias.text = informacionConsultaAlmacenada.applied_substances;
            self.txtEfectoTratamiento.text = informacionConsultaAlmacenada.treatment_effects;
            
            // Impresión diagnóstica
            if let impresionDiagnostica = FachadaIndependientesSQL.seleccionarPorCodigoCie10(conexion: self.conexion, codigo: informacionConsultaAlmacenada.diagnostic_impression ?? "") {
                
                self.txtImpresionDiagnostica.text = "\(impresionDiagnostica.name!) - \(impresionDiagnostica.code!)";
                
                self.impresionDiagnosticaSeleccionada = impresionDiagnostica.code!;
            }
            
        }
    }
    
    /**
     Permite capturar la información al momento de enviarla, previa validación.
     Se almacena en una variable estática en Memoria.
     */
    private func capturarInformacionConsulta () {
        let consultaMedica = ConsultaMedica();
        consultaMedica.evolution_time = self.txtTiempo.text == "" ? nil : Int(self.txtTiempo.text!);
        consultaMedica.unit_measurement = self.listaUnidadMedida[self.unidadMedidaSeleccionada].value!;
        consultaMedica.weight = self.txtPeso.text!;
        consultaMedica.number_injuries = self.listaNumeroLesionesIniciales[self.numeroLesionesInicialesSeleccionada].value!;
        // Pendiente respuesta se SERGIO
        consultaMedica.evolution_injuries = self.evolucionSeleccionados.joined(separator: ",");
        consultaMedica.blood = self.switchSangran.selectedSegmentIndex == 0 ? true: false;
        consultaMedica.exude = self.switchExudan.selectedSegmentIndex == 0 ? true: false;
        consultaMedica.suppurate = self.switchSupuran.selectedSegmentIndex == 0 ? true: false;
        // Pendiente respuesta SERGIO
        consultaMedica.symptom = self.sintomasSeleccionados.joined(separator: ",");
        consultaMedica.change_symptom = self.empeoranSeleccionado;
        consultaMedica.aggravating_factors = self.txtFactoresAgravantes.text;
        consultaMedica.personal_history = self.txtAntecedentesPersonales.text == Mensajes.PLACEHOLDER_ANTECEDENTES_PERSONALES ? "" : self.txtAntecedentesPersonales.text;
        consultaMedica.family_background = self.txtAntecedentesFamiliares.text;
        consultaMedica.treatment_received = self.txtTratamientoRecibido.text;
        consultaMedica.applied_substances = self.txtOtrasSustancias.text;
        consultaMedica.treatment_effects = self.txtEfectoTratamiento.text;
        //consultaMedica.ciediezcode = self.impresionDiagnosticaSeleccionada;
        
        // Es la única excepción que no guardar la fila o el id sinó que guarda directamente el código.
        consultaMedica.diagnostic_impression = self.impresionDiagnosticaSeleccionada;
        
        consultaMedica.doctor_id = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as? Int;
        
        // Como aplica únicamente para médicos el valor es 1
        consultaMedica.type_professional = 1;
        
        // Switches, con información adicional
        consultaMedica.other_factors_is_on = self.switchOtrosFactores.isOn;
        consultaMedica.history_is_on = self.switchAntecedentes.isOn;
        consultaMedica.treatment_received_is_on = self.switchTratamiento.isOn;
        consultaMedica.other_substances_is_on = self.switchOtrasSusteancias.isOn;
        consultaMedica.treatment_effects_is_on = self.switchEfectoTratamiento.isOn;
        
        if let examenFisico = MemoriaRegistroConsulta.consultaMedica?.description_physical_examination {
            consultaMedica.description_physical_examination = examenFisico;
        }
        
        // Se almacena en la variable estática en memoria.
        MemoriaRegistroConsulta.consultaMedica = consultaMedica;
        
        Funcionales.imprimirObjetoConPropiedades(objeto: MemoriaRegistroConsulta.consultaMedica!, titulo: "Información Consulta:");
    }
    
    // Comportamiento teclado para que se recupere el espacio que ocupa al aparecer
    @objc func keyboardWillShow(notification: NSNotification) {
        if (self.txtImpresionDiagnostica.isEditing || self.txtTratamientoRecibido.isEditing || self.txtOtrasSustancias.isEditing || self.txtEfectoTratamiento.isEditing) {
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return;
            }
            
            self.view.frame.origin.y = 0 - keyboardSize.height;
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionUnidadMedida(_ sender: UIButton) {
        self.view.endEditing(true);
        self.mostrarPickerSelectores(grupo: "unit_measurement", titulo: Mensajes.CAMPO_SELECCIONAR_UNIDAD_MEDIDA);
    }
    @IBAction func accionNumeroLesiones(_ sender: UIButton) {
        self.view.endEditing(true);
        self.mostrarPickerSelectores(grupo: "number_injuries", titulo: Mensajes.CAMPO_SELECCIONAR_NUMERO_LESIONES_INICIALES);
    }
    @IBAction func accionOtrosFactores(_ sender: UISwitch) {
        self.view.endEditing(true);
        if (!sender.isOn) {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.txtFactoresAgravantes, altoInicial: self.altoOtrosFactores, animado: true);
        } else {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtFactoresAgravantes, altoInicial: self.altoOtrosFactores, altoAuxiliar: self.otrosFactoresHeightVisible, animado: true);
        }
    }
    @IBAction func accionAntecedentes(_ sender: UISwitch) {
        self.view.endEditing(true);
        if (!sender.isOn) {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaAntecedentes, altoInicial: self.altoAntecedentes, animado: true);
        } else {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaAntecedentes, altoInicial: self.altoAntecedentes, altoAuxiliar: self.antecedentesHeightVisible, animado: true);
        }
    }
    @IBAction func accionTratamientoRecibido(_ sender: UISwitch) {
        if (!sender.isOn) {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.txtTratamientoRecibido, altoInicial: self.altoTratamiento, animado: true);
        } else {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtTratamientoRecibido, altoInicial: self.altoTratamiento, altoAuxiliar: self.tratamientoHeightVisible, animado: true);
        }
    }
    @IBAction func accionOtrasSustancias(_ sender: UISwitch) {
        self.view.endEditing(true);
        if (!sender.isOn) {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.txtOtrasSustancias, altoInicial: self.altoOtrasSustancias, animado: true);
        } else {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtOtrasSustancias, altoInicial: self.altoOtrasSustancias, altoAuxiliar: self.otrasSustanciasHeightVisible, animado: true);
        }
    }
    @IBAction func accionEfectoTratamiento(_ sender: UISwitch) {
        self.view.endEditing(true);
        if (!sender.isOn) {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.txtEfectoTratamiento, altoInicial: self.altoEfectoTratamiento, animado: true);
        } else {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.txtEfectoTratamiento, altoInicial: self.altoEfectoTratamiento, altoAuxiliar: self.efectoTratamientoHeightVisible, animado: true);
        }
    }
    
    @IBAction func accionSwitchSangran(_ sender: UISegmentedControl) {
        self.view.endEditing(true);
    }
    @IBAction func accionSwitchExudan(_ sender: UISegmentedControl) {
        self.view.endEditing(true);
    }
    @IBAction func accionSwitchSupuran(_ sender: UISegmentedControl) {
        self.view.endEditing(true);
    }
    
    @IBAction func accionSiguiente(_ sender: UIButton) {
        self.view.endEditing(true);
        if (self.sonCamposCorrectos()) {
            // Se toma la información del formulario
            self.capturarInformacionConsulta();
            
            // Si está activa la consulta lista para enviar se dirige al último paso del proceso
            if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
                let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
                self.present(vc, animated: true, completion: nil);
                
            } else {
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_3") as! RegistroPacienteViewController3;
                self.present(vc, animated: true, completion: nil);
            }
        }
    }
    
}

extension RegistroPacienteViewController2: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.listaUnidadMedida.count;
        case 2:
            return self.listaNumeroLesionesIniciales.count;
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return self.listaUnidadMedida[row].title;
        case 2:
            return self.listaNumeroLesionesIniciales[row].title;
        default:
            return nil;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            let texto = self.listaUnidadMedida[row].title!;
            self.unidadMedidaSeleccionada = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnUnidadMedida, texto: texto);
            
        case 2:
            let texto = self.listaNumeroLesionesIniciales[row].title!;
            self.numeroLesionesInicialesSeleccionada = row;
            Funcionales.ajustarTextoBotonSelector(boton: self.btnNumeroLesiones, texto: texto);
            
        default:
            break;
        }
        
    }
    
}
