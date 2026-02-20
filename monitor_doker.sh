#!/bin/bash

# --- CONFIGURACIÓN ---
TOKEN="TU_TOKEN_AQUÍ"
CHAT_ID="TU_CHAT_ID_AQUÍ"
FLAG_FILE="/tmp/docker_error_detected"

# 1. Obtener nombres de contenedores que NO están en estado 'running'
# Usamos un formato específico para que solo nos de los nombres
CONTENEDORES_CAIDOS=$(docker ps -a --filter "status=exited" --filter "status=dead" --filter "status=restarting" --format "{{.Names}}")

# 2. Contar cuántos hay caídos
NUM_CAIDOS=$(echo "$CONTENEDORES_CAIDOS" | grep -c -v '^$')

# --- LÓGICA DE NOTIFICACIÓN ---

if [ "$NUM_CAIDOS" -gt 0 ]; then
    # Si hay caídos y NO hemos avisado antes (el flag no existe)
    if [ ! -f "$FLAG_FILE" ]; then
        MENSAJE="⚠️ *Alerta Docker en Raspberry Pi* ⚠️%0A%0AContenedores caídos:%0A$CONTENEDORES_CAIDOS"
        
        curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
             -d "chat_id=$CHAT_ID" \
             -d "text=$MENSAJE" \
             -d "parse_mode=Markdown"
        
        # Creamos el flag para no repetir el mensaje
        touch "$FLAG_FILE"
    fi
else
    # Si todo está bien pero existía un flag (significa que se arregló)
    if [ -f "$FLAG_FILE" ]; then
        MENSAJE="✅ *Sistema Recuperado* %0ATodos los contenedores están funcionando de nuevo."
        
        curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
             -d "chat_id=$CHAT_ID" \
             -d "text=$MENSAJE" \
             -d "parse_mode=Markdown"
        
        # Borramos el flag para estar listos para el próximo error
        rm "$FLAG_FILE"
    fi
fi
