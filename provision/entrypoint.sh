#!/bin/bash

# Define uma função para mensagens de log com cores para melhor visualização
log() {
    echo -e "\e[1;34m$1\e[0m"
}

log "📂 A mudar para o diretório /app"
cd /app || { echo "❌ Falha ao mudar para /app"; exit 1; }

log "🚀 A fazer upgrade do Filament"
php artisan filament:upgrade || { echo "❌ Falha no upgrade do Filament"; exit 1; }

log "📊 A publicar o Log Viewer"
php artisan log-viewer:publish || { echo "❌ Falha ao publicar o Log Viewer"; exit 1; }

log "📦 A descobrir pacotes"
php artisan package:discover --ansi || { echo "❌ Falha na descoberta de pacotes"; exit 1; }

# Define o caminho de origem e destino
origem="/app/storage/app/public"
destino="/app/public/storage"

# Verifica se o diretório de destino já existe e o remove, se necessário
if [ -L "$destino" ] || [ -d "$destino" ]; then
    echo "🔗 O link simbólico ou diretório $destino já existe. A remover..."
    rm -rf "$destino"
fi

# Cria o link simbólico
echo "🔗 A criar link simbólico de $origem para $destino"
ln -s "$origem" "$destino" || { echo "❌ Falha ao criar o link simbólico"; exit 1; }

echo "✅ Link simbólico criado com sucesso!"

log "🔐 A definir permissões para os ficheiros (644)"
find /app -type f -print0 | xargs -0 chmod 644 || { echo "❌ Falha ao definir permissões dos ficheiros"; exit 1; }

log "📁 A definir permissões para os diretórios (755)"
find /app -type d -print0 | xargs -0 chmod 755 || { echo "❌ Falha ao definir permissões dos diretórios"; exit 1; }

log "⚙️ A definir permissão de execução para wkhtmltopdf-amd64"
chmod a+x /app/vendor/h4cc/wkhtmltopdf-amd64/bin/wkhtmltopdf-amd64 || { echo "❌ Falha ao definir permissão de execução"; exit 1; }

log "🔄 A executar migrações com força"
php artisan migrate --force || { echo "❌ Falha ao executar migrações"; exit 1; }

log "🧹 A limpar a cache de otimização"
php artisan optimize:clear || { echo "❌ Falha ao limpar a cache de otimização"; exit 1; }

log "🚀 A otimizar a aplicação"
php artisan optimize || { echo "❌ Falha ao otimizar a aplicação"; exit 1; }

log "🎨 A criar cache de ícones"
php artisan icons:cache || { echo "❌ Falha ao criar cache de ícones"; exit 1; }

log "⚙️ A limpar cache de configuração"
php artisan config:clear || { echo "❌ Falha ao limpar cache de configuração"; exit 1; }

log "✅ Todas as operações concluídas com sucesso!"