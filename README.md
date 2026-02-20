# 🐳 Docker Monitor Telegram Bot

Un script ligero en Bash para monitorear el estado de los contenedores Docker en una Raspberry Pi (o cualquier servidor Linux) y enviar notificaciones instantáneas a través de un bot de Telegram cuando un servicio se cae o se recupera.

## 🚀 Características

* **Monitoreo en tiempo real:** Detecta contenedores en estado `exited`, `dead` o `restarting`.
* **Anti-Spam:** Utiliza un sistema de "flag files" para enviarte solo una notificación cuando ocurre el error y una cuando se soluciona.
* **Ligero:** No requiere Python ni dependencias pesadas, solo `curl` y el motor de `docker`.
* **Ideal para Homelabs:** Diseñado para correr directamente en el SO (Systemd/Cron) para mayor fiabilidad.

---

## 🛠️ Requisitos Previos

1. **Telegram Bot:**
   - Haber creado un bot con [@BotFather](https://t.me/botfather) para obtener el `API Token`.
   - Obtener tu `Chat ID` personal.
2. **Dependencias:**
   - `docker`
   - `curl`

---

## 📂 Instalación y Configuración

1. **Clona este repositorio (o descarga el script):**
   
```bash
mkdir -p ~/scripts/docker-monitor
cd ~/scripts/docker-monitor
```
   
## Configuración de Credenciales 

```bash
TOKEN="TU_TELEGRAM_TOKEN_AQUI"
CHAT_ID="TU_CHAT_ID_AQUI"
```

## Asigna Permisos

```bash
chmod +x monitor_doker.sh
```

## Automatización con Cron

```bash
crontab -e
```

Añade la siguiente línea al final del archivo:

```bash
* * * * * /bin/bash /home/TU_USUARIO/scripts/docker-monitor/monitor_doker.sh
```

## 📝 Cómo funciona el Script

El script sigue una lógica de estados para evitar saturar tu Telegram con mensajes:

Inspección: Consulta al daemon de Docker por contenedores que no estén "running".

Alerta: Si encuentra fallos y no existe un archivo de error previo en /tmp, envía una alerta y crea el archivo.

Persistencia: Mientras el contenedor siga caído, el script verá que el archivo existe y no enviará más mensajes.

Recuperación: Cuando el contenedor vuelve a estar en línea, el script detecta que ya no hay errores, envía un mensaje de "Sistema Recuperado" y borra el archivo temporal.
   


⚠️ Notas de Seguridad
No subas tus API Keys: Asegúrate de que el archivo .sh con tus tokens reales no sea público.

Permisos: El usuario que ejecuta el cron debe pertenecer al grupo docker para poder consultar el estado de los contenedores sin sudo.


