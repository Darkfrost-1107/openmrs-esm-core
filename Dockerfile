FROM node:18-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache python3 make g++ git

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# Copiar workspaces
COPY packages ./packages
COPY e2e ./e2e

# Instalar dependencias
RUN yarn install

# Copiar el resto del código
COPY . .

# Setup inicial (construir paquetes necesarios)
RUN yarn build --concurrency 1 || yarn setup

# Exponer puerto para el dev server
EXPOSE 8080

# Comando por defecto para desarrollo
CMD ["yarn", "run:shell", "--allowed-hosts", "all", "--host", "0.0.0.0"]