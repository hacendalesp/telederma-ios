//
//  Mensajes.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 6/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class Mensajes: NSObject {
    
    private static let MENSAJE_BASE = "Por favor ";
    static let CAMPO_SELECCIONAR = "Seleccionar";
    
    static let CAMPO_FIRMA_SELECCIONAR_DIGITAL = "\(Mensajes.CAMPO_SELECCIONAR) la firma digital";
    static let MENSAJE_SELECCIONAR_FIRMA_DIGITAL = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_FIRMA_SELECCIONAR_DIGITAL)";
    
    static let CAMPO_SELECCIONAR_TIPO_PROFESIONAL = "\(Mensajes.CAMPO_SELECCIONAR) el tipo de profesional";
    static let MENSAJE_SELECCIONAR_TIPO_PROFESIONAL = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_TIPO_PROFESIONAL)";
    
    static let CAMPO_SELECCIONAR_TIPO_IDENTIFICACION = "\(Mensajes.CAMPO_SELECCIONAR) el tipo de identificación";
    static let MENSAJE_SELECCIONAR_TIPO_IDENTIFICACION = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_TIPO_IDENTIFICACION)";
    
    static let CAMPO_SELECCIONAR_UNIDAD_MEDIDA = "\(Mensajes.CAMPO_SELECCIONAR) la unidad de medida";
    static let MENSAJE_SELECCIONAR_UNIDAD_MEDIDA = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_UNIDAD_MEDIDA)";
    
    static let CAMPO_SELECCIONAR_ESTADO_CIVIL = "\(Mensajes.CAMPO_SELECCIONAR) el estado civil";
    static let MENSAJE_SELECCIONAR_ESTADO_CIVIL = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_ESTADO_CIVIL)";
    
    static let CAMPO_SELECCIONAR_DEPARTAMENTO = "\(Mensajes.CAMPO_SELECCIONAR) el departamento";
    static let MENSAJE_SELECCIONAR_DEPARTAMENTO = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_DEPARTAMENTO)";
    
    static let CAMPO_SELECCIONAR_MUNICIPIO = "\(Mensajes.CAMPO_SELECCIONAR) el municipio";
    static let MENSAJE_SELECCIONAR_MUNICIPIO = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_MUNICIPIO)";
    
    static let CAMPO_SELECCIONAR_TIPO_USUARIO = "\(Mensajes.CAMPO_SELECCIONAR) el tipo de usuario";
    static let MENSAJE_SELECCIONAR_TIPO_USUARIO = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_TIPO_USUARIO)";
    
    static let CAMPO_SELECCIONAR_CAUSA_EXTERNA = "\(Mensajes.CAMPO_SELECCIONAR) la causa externa";
    static let MENSAJE_SELECCIONAR_CAUSA_EXTERNA = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_CAUSA_EXTERNA)";
    
    static let CAMPO_SELECCIONAR_ASEGURADORA = "\(Mensajes.CAMPO_SELECCIONAR) la aseguradora";
    static let MENSAJE_SELECCIONAR_ASEGURADORA = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_ASEGURADORA)";
    
    static let CAMPO_SELECCIONAR_CONDICION = "\(Mensajes.CAMPO_SELECCIONAR) la condición";
    static let MENSAJE_SELECCIONAR_CONDICION = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_CONDICION)";
    
    static let CAMPO_SELECCIONAR_INPEC = "\(Mensajes.CAMPO_SELECCIONAR) el número INPEC";
    static let MENSAJE_SELECCIONAR_INPEC = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_INPEC)";
    
    static let CAMPO_SELECCIONAR_NUMERO_LESIONES_INICIALES = "\(Mensajes.CAMPO_SELECCIONAR) el número de lesiones iniciales";
    static let MENSAJE_SELECCIONAR_NUMERO_LESIONES_INICIALES = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_NUMERO_LESIONES_INICIALES)";
    
    static let CAMPO_SELECCIONAR_EVOLUCION_LESIONES = "\(Mensajes.CAMPO_SELECCIONAR) al menos una Evaluación de Lesiones";
    static let MENSAJE_SELECCIONAR_EVOLUCION_LESIONES = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_EVOLUCION_LESIONES)";
    
    static let CAMPO_SELECCIONAR_SINTOMAS = "\(Mensajes.CAMPO_SELECCIONAR) al menos un síntoma";
    static let MENSAJE_SELECCIONAR_SINTOMAS = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_SINTOMAS)";
    
    static let CAMPO_SELECCIONAR_IMPRESION_DIAGNOSTICA = "\(Mensajes.CAMPO_SELECCIONAR) impresión diagnóstica";
    static let MENSAJE_SELECCIONAR_IMPRESION_DIAGNOSTICA = "\(Mensajes.MENSAJE_BASE) \(Mensajes.CAMPO_SELECCIONAR_IMPRESION_DIAGNOSTICA)";
    
    static let MENSAJE_SELECCIONAR_CONSENTIMIENTO = "Ee necesario que firmar consentimiento informado, activando la opción al final del formulario.";
    
    static let NO_INFO = "No hay información relacionada.";
    static let NO_REPORTA = "No reporta";
    static let INFORMACION_OBLIGATORIA = "Recuerde que debe diligenciar la información marcada con asterisco '*'";
    static let SOLO_NUMEROS = "Para la información resaltada sólo se permiten Números.";
    static let SOLO_CORREO = "Para la información resaltada sólo se permite Correo Electrónico.";
    static let MINIMO_CARACTERES = "Para la información resaltada, el número mínimo de caracteres permitido es: ";
    static let MAXIMO_CARACTERES = "Para la información resaltada, el número máximo de caracteres permitido es: ";
    static let USUARIO_IDENTIFICACION_IGUALES = "Usuario e Identificación deben ser iguales.";
    static let PASSWORD_CONFIRMAR_IGUALES = "Contraseña y Confirmar Contraseña deben ser iguales.";
    static let CONFIRMAR_TERMINOS = "Para continuar debe aceptar los términos y condiciones.";
    static let MENSAJE_ALERTA_ERROR = "Por favor revise la siguiente información:\n\n";
    static let PLACEHOLDER_ANTECEDENTES_PERSONALES = "Ingrese antecedentes de tipo: Médicos, Quirúrgicos, Tóxicos, Alérgicos, Ginecológicos, Farmacológicos, Otros.";
    static let SELECCIONAR_CONTROL = "Seleccione un Control";
    
    // Cámara fotográfica
    static let FOTOS_CANTIDAD_MINIMA = "Debe seleccionar imágenes, por lo menos: ";
    static let FOTOS_CANTIDAD_MAXIMA = "Ha llegado al máximo de fotos: ";
    static let TEXTO_ETIQUETA_DERMATOSCOPIA = "Imágenes Dermatoscópicas";
    static let CONFIRMACION_ANEXOS_VACIO = "¿Quieres dejar tu selección de imágenes vacía?";
    
    static let TEXTO_BOTON_RESUMEN = "Guardar e ir al resumen";
    
    // Respuestas servidor
    static let ERROR_CONVERSION_DATA = "No fue posible realizar el registro.";
    static let ERROR_ACTUALIZACIÓN_DATA = "No fue posible actualizar la información.";
    static let ERROR_CONEXION = "No es posible conectarse con el servidor.";
    static let ERROR_INTERNET = "No es posible conectarse a una red. Por favor verifica tu conexión a internet.";
    static let ERROR_DESCARTE = "Por favor revisa el formulario.";
    static let ERROR_ALMACENAMIENTO_INTERNO = "La información se envió a los serviodres pero no se pudo guardar en el dispositivo.";
    
    // Paciente
    static let TITULO_CONFIRMACION = "¿Está seguro de continuar con el campo número de documento vacío?";
    static let MENSAJE_CONFIRMACION = """
    Este campo no será editable  y los únicos tipos de documento que podrás seleccionar serán:
    (AS) Adulto sin identificar
    (MS) Menor sin identifcar
    """;
    
    static let ESTADO_ACTIVO = "Activo";
    static let MENSAJE_CERTIFICACION_MAL = "No alcanzó el 70% requerido para certificarse.";
    // Textos para semiología
    static let DICCIONARIO_SEMIOLOGIA = [
        "ampolla": "Lesión elevada de contenido líquido, compresible, mayor de 5 mm. Es unilocular y su contenido se evacúa al ser puncionada. Puede ser seroso, purulento o hemorrágico. Puede tener localización intraepidérmica y subepidérmica. Las más superficiales son ampollas flácidas frágiles que se rompen fácilmente y dejan erosiones y áreas denudadas. Se ven en pénfigo vulgar, necrólisis epidérmica tóxica. Las subepidérmicas son tensas y perduran más tiempo, son típicas del penfigoide ampolloso.",
        "atrofia": "Adelgazamiento de la piel que se observa como un desnivel respecto a la piel circundante, es secundaria a la disminución en el grosor en alguna o todas las capas de la piel. La atrofia puede ser epidérmica donde se ve la piel con arrugas finas como en papel de cigarrillo; en la atrofia dérmica se ve la piel de aspecto normal pero un poco deprimida; y en la hipodérmica se ve una depresión profunda.",
        "cicatriz": "Formación circunscrita de aspecto fibroso y superficie lisa, de color diferente, más dura y rígida que la piel circundante o de aspecto atrófico con pérdida de anexos y surcos cutáneos naturales. Es producto de neoformación tisular y son definitivas. Ocurre después de un proceso inflamatorio o una solución de continuidad con pérdida de tejido. Se remplaza colágeno organizado por tejido fibroso. Las cicatrices pueden ser atróficas con piel delgada y deprimida. También pueden ser hipopigmentadas y con la piel un poco arrugada; hipertróficas que son elevadas del color de la piel o rosada, de consistencia dura que se limitan al sitio de la injuria; queloide la cual se ve como una cicatriz elevada, de consistencia dura y cuyos bordes se extienden más allá de la zona lesionada.",
        "costra": "Depósito endurecido producto de la desecación de un líquido sobre piel previamente lesionada. Depende del líquido que se seca de las costras pueden ser hemáticas si es sangre, meliflua o melicérica si es pus y serosa si es suero.",
        "erosion": "Solución de continuidad con pérdida únicamente de la epidermis. Ocurre después de la ruptura de una ampolla o vesícula. Se observa una superficie denudada y húmeda que permite sospechar que hubo un contenido líquido. Resuelven sin dejar cicatriz. Se ven en impétigo y pénfigo vulgar.",
        "escama": "Fragmento laminar seco y blanquecino de queratina secundario a desprendimiento en bloque del estrato córneo. Fisiológicamente se produce una descamación imperceptible; cuando se hace aparente hay aumento de grosor de estrato córneo, puede ocurrir por aumento en la velocidad del proceso de queratinización o una retención anormal del estrato córneo.",
        "esclerosis": "Induración de la piel con pérdida de la elasticidad y aspecto tenso, brillante y acartonado. La piel no permite pellizcarla ni desplazarla sobre planos profundos.",
        "excoriacion": "Solución de continuidad superficial, de distribución usualmente lineal y secundaria a rascado.",
        "fistula": "Orificio en la piel conformado por líquido seco y/u otra sustancia orgánica secundario a comunicación entre una cavidad interna y la piel; corresponde a un trayecto tisular anormal, revestido de epitelio, de origen congénito, traumático o inflamatorio.",
        "fisura": "Solución de continuidad lineal de la piel que compromete dermis. Suele seguir pliegues cutáneos y es dolorosa. Secundaria a disminución de elasticidad de la piel o por tensión excesiva.",
        "liquenificacion": "Engrosamiento de la piel con cambios en la pigmentación, induración y acentuación de su cuadriculado normal. Usualmente se da por rascado o roce continuo y se encuentra en dermatosis pruriginosas crónicas. Generalmente se encuentran costras hemáticas y excoriaciones.",
        "macula": "Lesión que se caracteriza solamente por cambio de color de la piel sin otras alteraciones en la superficie. Puede ocurrir por: a) Cambios en el pigmento con relación a la piel normal. Corresponde a una mácula  hiperpigmentada si se ven de color pardo claro o pardo oscuro y mácula  hipopigmentada si se ven color más claro que la piel adyacente. Se habla de acromía cuando hay pérdida total de color de la piel (completamente blanca, como en el vitíligo). b) Cambios vasculares por vasodilatación, usualmente desaparece a la presión. Cuando hay extravasación de eritrocitos se denomina púrpura y no cede a la digitopresión.",
        "nodulo": """
        Lesión sólida profunda más palpable que visible mayor de 5 mm. Pueden ser también lesiones elevadas induradas usualmente eritematosas. Son típicos los nódulos de eritema nodoso, nódulos en acné y nódulo quístico. Entre los nódulos se incluyen gomas que son de curso subagudo o crónico y tienen diferentes estadios de evolución: solidez, reblandecimiento, ulceración, supuración y cicatriz. Se presentan en esporotricosis, sífilis terciaria y escrofuloderma.
        
        Los abscesos son nódulos inflamatorios de consistencia más blanda, conformados por una colección de PMN que se observa clínicamente como pus. El material inflamatorio y el contenido purulento son profundos por lo que no se pueden visualizar.
        """,
        "papula": "Lesión circunscrita y sólida de 5 mm o menor diámetro que usualmente desaparecen sin dejar cicatriz. Pueden ocurrir por edema, inflamación, proliferación celular o depósito de alguna sustancia. Puede tener diversas formas y cambios en la superficie. Ejemplos: verruga viral, pápula inflamatoria de acné, molusco contagioso y liquen plano.",
        "parche": "Lesión plana ligeramente palpable, consiste en un cambio de color con descamación fina en la superficie.",
        "placa": "Lesión elevada, palpable, más extensa que alta, usualmente mayor de 5 mm. Pueden formarse por confluencia de lesiones primarias (pápulas, vesículas) y puede haber varios tipos de lesiones formando la placa.",
        "poiquilodermia": "Cambio de la piel que se caracteriza por atrofia epidérmica, hiper e hipopigmentación y telangiectasias. Es típica en dermatomiositis y daño actínico crónico.",
        "pustula": "Lesión elevada menor de 5 mm, eritematosa con acumulación de material purulento amarillo o blanquecino. Pueden ser foliculares o no. Se presentan en foliculitis bacteriana, rosácea, acné, tiña pedis, psoriasis pustulosa y pustulosis exantemática generalizada aguda.",
        "quiste": "Lesión circunscrita y esférica que puede o no ser elevada, corresponde a una cavidad con un contenido líquido o semisólido. Tiene un revestimiento epitelial en caso de quistes verdaderos (cápsula de quiste epidérmico). Las lesiones que parecen quistes pero no poseen esta cápsula se llaman seudoquistes. Se presentan por ejemplo en acné como lesiones renitentes.",
        "roncha": "Lesión elevada, edematosa, pruriginosa y eritematosa con zona central más clara que usualmente desaparece a la presión. Suele ser de inicio rápido y fugaz. Se presenta en picaduras de insectos y urticaria.",
        "telangiectasia": "Vaso sanguíneo de calibre menor de 1mm, superficial, visible y dilatado, con ramificaciones. Es permanente y no desaparece a la presión. Pueden verse en rosácea.",
        "tumor": "Lesión indurada, elevada, profunda y polimorfa de carácter expansivo que altera las estructuras de la piel adyacente. Puede tener tamaño variable.",
        "ulcera": """
        Solución de continuidad profunda que compromete todas las capas de la piel; siempre deja cicatriz. Puede ser una lesión primaria o secundaria. Las causas pueden ser traumáticas, infecciosas, neoplásicas, vasculares, neuropáticas e inflamatorias.
        
        Se deben describir características como cambios en la textura, color o aspecto de la piel circundante y cambios vasculares asociados. Describir el tamaño midiendo su diámetro, forma, borde que puede ser en sacabocados o biselado, profundidad, fondo y si este es limpio, sucio, con aspecto de empedrado como en Leishmaniasis, si hay costra serosa, necrótica, purulenta, si hay secreciones y sus características. Se prefiere ablandar la costra en agua o suero fisiológico y removerla para visualizar el fondo. Si hay fetidez y características de síntomas asociados. Estos datos permiten orientar la etiología de la úlcera.

        """,
        "vegetaciones": "Proyecciones papilares múltiples y agrupadas similares a un coliflor de consistencia blanda. Se presenta como un cambio de superficie verrugosa o vegetante de las pápulas, placas o nódulos o puede presentarse como lesión primaria. Cuando la capa córnea que es la más superficial de la epidermis es muy gruesa, las proyecciones son poco evidentes y se tornan duras y secas.",
        "vesicula": "Lesión elevada de contenido líquido,  menor de 5 mm. Suelen presentarse múltiples y pueden extenderse en una zona como en el eczema de contacto o ser arracimadas como en herpes simple. El contenido puede ser seroso o hemorrágico. Pueden ser superficiales (intraepidérmicas) por separación de las células de la piel o por edema intracelular o subepidérmicas cuando la separación ocurre en la unión dermoepidérmica. Las más superficiales suelen romperse fácilmente. El contenido de las vesículas se seca y forma costras."
    ];
    
    // Mensajes archivar y compartir consulta
    
    static let ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE = "Esta consulta no se puede archivar porque se encuentra en estado pendiente.";
    static let ARCHIVAR_MENSAJE_REVISAR_CORREO = "La información se ha compartido al correo electrónico ingresado."
    static let ENVIAR_INFORMACION_OFFLINE = "La información se ha almacenado en el dispositivo y se sincronizará cuando se conecte a una red."
}
