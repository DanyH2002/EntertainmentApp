# EntertainmentApp

EntertainmentApp es una aplicación de entretenimiento que permite a los usuarios explorar **películas y series**, consultar detalles, realizar búsquedas y gestionar una lista de **favoritos personalizados**, todo a través de una API propia y una aplicación móvil desarrollada en SwiftUI.

El proyecto está dividido en dos partes principales:
- **Backend**: API REST desarrollada con Laravel que se conecta con *TMDB API*
- **Frontend**: Aplicación iOS desarrollada con SwiftUI

---

## Funcionalidades principales

### Autenticación
- Registro de usuarios
- Inicio de sesión
- Manejo de sesión mediante token (Bearer Token)

### Contenido multimedia
- Listado de películas populares
- Listado de series populares
- Búsqueda de películas y series
- Vista de detalles de películas y series

### Favoritos
- Agregar películas o series a favoritos
- Listar favoritos separados por películas y series
- Eliminar elementos de favoritos

---
## Tecnologías utilizadas

### Backend
- PHP 8
- Laravel
- Docker y Docker Compose
- MySQL
- Nginx

### Frontend
- SwiftUI
- URLSession
- Async / Await
- iOS

---

## Estructura del proyecto
```bash
EntertainmentApp/
│
├── backend/
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── nginx/
│   └── EntertainmentApp/   # Proyecto Laravel (API REST)
│
├── frontend/
│   └── EntertainmentApp/   # Proyecto iOS (SwiftUI)
│
└── README.md
```


## Configuraciones necesarias

### Variables de entorno (Backend)

En el **backend/EntertainmentApp/** debes crear un archivo `.env` con las siguientes variables:

```env
APP_NAME=EntertainmentApp
APP_ENV=local
APP_KEY=base64:GENERAR_CON_KEY_GENERATE
APP_DEBUG=true
APP_URL=http://127.0.0.1:8000

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=laravel123

TMDB_KEY=GENERAR_DESDE ``#https://www.themoviedb.org/
TMDB_BASE_URL=https://api.themoviedb.org/3/

```

### Levantar el Backend (Laravel + Docker)
Desde la carpeta backend:

    docker-compose up -d


Verificar que el contenedor esté activo:

    docker ps


Ingresar al contenedor de Laravel:

    docker exec -it laravel_app bash


Dentro del contenedor:

    composer install
    cd EntertainmentApp
    php artisan key:generate
    php artisan migrate
    php artisan serve


El backend quedará disponible en:

    http://127.0.0.1:8000

## Ejecución del Frontend (iOS)

### Requisitos:
- macOS
- Xcode
- iOS Simulator

### Pasos
1️⃣ Abrir Xcode

2️⃣ Abrir el proyecto ubicado en:

    frontend/EntertainmentApp/EntertainmentApp.xcodeproj

3️⃣ Ejecutar en un simulador iOS

 * Verificar que el baseUrl del ApiService apunte a: * 

       http://127.0.0.1:8000/api

## Video demostrativo
En el video se muestra:

- Registro de usuario
- Inicio de sesión
- Navegación por películas y series
- Búsquedas
- Agregar y eliminar favoritos

<iframe width="560" height="315"
src="https://www.youtube.com/embed/i3weuLPiGcQ"
title="Video demostrativo EntertainmentApp"
frameborder="0"
allowfullscreen>
</iframe>

🔗 Enlace directo al video:  
https://www.youtube.com/watch?v=i3weuLPiGcQ

## Autor

Hulda Daniela Crisanto Luna
Proyecto académico – Desarrollo de aplicación móvil 
