# Build context: repo root (see docker/docker-compose.yml)
#
# Imagem que RODA a suite Cucumber + Playwright (nivel de UI) de
# automation/ui-tests contra um frontend + backend reais, ja de pe no perfil
# "automation". Usa a imagem oficial do Playwright NA MESMA VERSAO travada em
# automation/ui-tests/package-lock.json (@playwright/test 1.63.0): os
# browsers ja vem instalados, sem precisar baixar nada em build/run.

FROM mcr.microsoft.com/playwright:v1.63.0-noble AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM deps AS runtime
COPY . .

# http://frontend e o nome do servico frontend na rede do Docker Compose (ver
# docker/docker-compose.yml). Para apontar para outro endereco:
# docker run -e AUTOMATION_FRONTEND_URL=http://outro <imagem>
ENV AUTOMATION_FRONTEND_URL=http://frontend
CMD ["npm", "test"]
