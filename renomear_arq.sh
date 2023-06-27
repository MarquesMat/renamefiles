#!/bin/bash

# Definição do caminho base
# caminho_base="/var/cache/zoneminder/events/"
caminho_base="/home/monitora/Documentos/projeto_monitora/events/"

# Encontrar todas as pastas dentro do caminho base
pastas=$(find "$caminho_base" -mindepth 1 -maxdepth 1 -type d)

for pasta in $pastas; do
    # Encontrar todas as subpastas dentro da pasta atual
    subpastas=$(find "$pasta" -mindepth 1 -maxdepth 1 -type d)

    for sub in $subpastas; do
	subpasta="${sub}/"

	# Encontrar todos os arquivos dentro da subpasta atual
	arquivos=$(find "$subpasta" -maxdepth 1 -type f)

	# Loop pelos arquivos encontrados
	for arquivo in $arquivos; do
		# Obter o nome do arquivo
		nome_arquivo=$(basename "$arquivo")

		# Obter o horário de criação do arquivo
		time=$(stat -c %Y "$arquivo")

		# Converter o horário de criação em formato legível
		time_formatado=$(date -d @"$time" "+%Y%m%d_%H%M%S")

		# Construir o novo nome do arquivo
		novo_nome="${pasta}/$(basename "$pasta")_${time_formatado}"

		# Renomear o arquivo
		mv "$arquivo" "$novo_nome"

		# Exibir informações sobre a renomeação
		echo "Arquivo renomeado: $nome_arquivo -> $(basename "$novo_nome")"
		echo "Horário de criação: $time_formatado"
    	done
    done
done
