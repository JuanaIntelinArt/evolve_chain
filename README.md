Evolve RWA Chain: Simulación de DApp de RWA con Control de Cumplimiento (Compliance)
🔗 Introducción
Este proyecto es una aplicación descentralizada (DApp) simple que simula un Smart Contract en una cadena de Real World Assets (RWA) con un mecanismo de cumplimiento (Compliance) integrado. Utiliza Firebase Firestore como la capa de persistencia para simular el estado global de la cadena (saldos y listas blancas), permitiendo transacciones multi-usuario en tiempo real.

Características clave:

Modelo de Gobernanza (Sequencer): El usuario que inicializa la sesión actúa como "Sequencer" o Admin, capaz de ajustar el estado de cumplimiento (Whitelist/Blacklist) de cualquier dirección.

Token RWA: Simulación de transferencia de tokens RWA.

Modificador onlyCompliant: El contrato inteligente simulado solo permite transferencias si la dirección del emisor está marcada como COMPLIANT por el Sequencer/Admin.

🏗️ Arquitectura y Tecnologías
La aplicación es un Single-File HTML/JavaScript que funciona enteramente en el navegador.

Frontend/UI: HTML5, Tailwind CSS (CDN).

Lógica del Contrato: JavaScript Vanilla (RwaChainSim class).

Persistencia (Blockchain State): Firebase Firestore (Base de datos NoSQL en tiempo real) para sincronizar el estado entre todos los usuarios.

Despliegue: Vercel (ideal para inyección segura de credenciales).

🚀 Configuración Local
Sigue estos pasos para clonar y ejecutar el proyecto en tu máquina.

1. Clonar el Repositorio
Abre tu terminal y clona el proyecto:

git clone [https://github.com/tu-usuario/evolve-rwa-chain.git](https://github.com/JuanaIntelinArt/evolve_chain/tree/main))
cd evolve-rwa-chain

2. Configuración de Firebase
Para que la DApp funcione y persista el estado de la cadena, necesitas configurar tu propio proyecto de Firebase.

Crea un Proyecto de Firebase: Ve a la Consola de Firebase y crea un nuevo proyecto.

Configura Firestore: Habilita Cloud Firestore y crea una base de datos en modo de producción.

Habilita la Autenticación: Ve a la sección Authentication y activa el método de inicio de sesión Anónimo (Anonymous).

Obtén tus Credenciales: Ve a Project Settings (Configuración del Proyecto) para obtener la configuración de tu aplicación web (el objeto firebaseConfig). Necesitarás los siguientes valores:

apiKey

authDomain

projectId

storageBucket

messagingSenderId

appId

3. Ejecución Local (Opciones)
Opción A: Ejecutar sin Vercel (Usando Placeholders)
Para ejecutar localmente, debes reemplazar directamente los placeholders en el archivo Evolve_Chain/dapp/index.html con tus claves de Firebase.

Encuentra este bloque en la línea ~19 de index.html:

            // ATENCIÓN: Estos marcadores de posición SERÁN REEMPLAZADOS por los valores que configures en Vercel
            firebaseConfig = {
                apiKey: "%VITE_FIREBASE_API_KEY%", 
                authDomain: "%VITE_FIREBASE_AUTH_DOMAIN%",
                projectId: "%VITE_FIREBASE_PROJECT_ID%",
                storageBucket: "%VITE_FIREBASE_STORAGE_BUCKET%",
                messagingSenderId: "%VITE_FIREBASE_MESSAGING_SENDER_ID%",
                appId: "%VITE_FIREBASE_APP_ID%"
            };

Reemplázalo por tus valores reales, por ejemplo:

            // CONFIGURACIÓN LOCAL (REEMPLAZAR CON TUS VALORES)
            firebaseConfig = {
                apiKey: "AIzaSyC_tu_API_KEY_aqui_456", 
                authDomain: "tu-proyecto.firebaseapp.com",
                projectId: "tu-project-id",
                storageBucket: "tu-project-id.appspot.com",
                messagingSenderId: "1234567890",
                appId: "1:23456789:web:abcdefghij"
            };

Una vez reemplazado, simplemente abre el archivo Evolve_Chain/dapp/index.html en tu navegador para interactuar con la DApp.

⚠️ Advertencia: Si haces commit de este cambio, subirás tus claves secretas a GitHub. Asegúrate de revertir este cambio antes de subirlo si utilizas esta opción.

Opción B: Utilizar un Servidor Local
Para la mejor experiencia de desarrollo, usa una extensión de VS Code como "Live Server" o un servidor HTTP simple para servir la carpeta del proyecto.

# Ejemplo con Python (si tienes Python instalado)
python3 -m http.server 8000 
# Luego navega a http://localhost:8000/Evolve_Chain/dapp/index.html

☁️ Despliegue con Vercel (Recomendado)
Para el despliegue en producción, es crucial inyectar las credenciales de Firebase de forma segura mediante Variables de Entorno.

Conexión: Conecta tu repositorio de GitHub a Vercel.

Variables de Entorno: En la configuración de tu proyecto en Vercel (Settings > Environment Variables), añade tus credenciales de Firebase con los siguientes nombres:

VITE_FIREBASE_API_KEY

VITE_FIREBASE_AUTH_DOMAIN

VITE_FIREBASE_PROJECT_ID

VITE_FIREBASE_STORAGE_BUCKET

VITE_FIREBASE_MESSAGING_SENDER_ID

VITE_FIREBASE_APP_ID

Comando de Construcción (Build Command): Vercel necesita ejecutar un script para reemplazar los placeholders (%VITE_...%) en el index.html con las variables de entorno. En Build & Development Settings, establece el comando de construcción a:

sed -i.bak 's|%VITE_FIREBASE_API_KEY%|'$VITE_FIREBASE_API_KEY'|g' Evolve_Chain/dapp/index.html && sed -i.bak 's|%VITE_FIREBASE_AUTH_DOMAIN%|'$VITE_FIREBASE_AUTH_DOMAIN'|g' Evolve_Chain/dapp/index.html && sed -i.bak 's|%VITE_FIREBASE_PROJECT_ID%|'$VITE_FIREBASE_PROJECT_ID'|g' Evolve_Chain/dapp/index.html && sed -i.bak 's|%VITE_FIREBASE_STORAGE_BUCKET%|'$VITE_FIREBASE_STORAGE_BUCKET'|g' Evolve_Chain/dapp/index.html && sed -i.bak 's|%VITE_FIREBASE_MESSAGING_SENDER_ID%|'$VITE_FIREBASE_MESSAGING_SENDER_ID'|g' Evolve_Chain/dapp/index.html && sed -i.bak 's|%VITE_FIREBASE_APP_ID%|'$VITE_FIREBASE_APP_ID'|g' Evolve_Chain/dapp/index.html

Nota: La ruta del archivo (Evolve_Chain/dapp/index.html) es crítica para que el reemplazo funcione.

Ruta de Producción: Asegúrate de que Vercel sirva el archivo correcto, posiblemente configurando el Root Directory a Evolve_Chain/dapp si es necesario, o asegurando que la ruta del index.html sea accesible.

👥 Reglas de Seguridad de Firestore
Para que el acceso público al estado de la cadena funcione (todos los usuarios compartiendo la misma vista), tus reglas de Firestore deben permitir la lectura y escritura pública en la colección de estado.

Reglas sugeridas (si quieres que el estado sea verdaderamente público y compartido):

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permite que cualquiera (incluidos los usuarios anónimos) lea y escriba
    // en el documento de estado de la cadena compartido.
    match /artifacts/{appId}/public/data/evolveChainState/{docId} {
      allow read, write: if true;
    }
    
    // Regla de seguridad por defecto para otras colecciones privadas
    match /artifacts/{appId}/users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
