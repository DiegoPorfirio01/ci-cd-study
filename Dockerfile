# Usar uma imagem base do Node.js
FROM node:18-slim AS build

# Instalar pnpm globalmente
RUN npm install -g pnpm

# Criar e definir o diretório de trabalho
WORKDIR /usr/src/app

# Copiar os arquivos package.json
COPY package*.json ./

# Instalar as dependências do projeto
RUN pnpm install

# Copiar o restante do código do aplicativo
COPY . .

# Construir o aplicativo
RUN pnpm run build

RUN pnpm recursive install --prod

FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Expor a porta na qual a aplicação irá rodar
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["pnpm", "run", "start"]