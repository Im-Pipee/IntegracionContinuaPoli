FROM nginx:alpine

# Crear directorio y establecer permisos correctos
RUN mkdir -p /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Copiar archivos del frontend
COPY . /usr/share/nginx/html/

# Establecer permisos correctos después de copiar
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 644 /usr/share/nginx/html/* && \
    chmod 755 /usr/share/nginx/html

# Exponer puerto
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]