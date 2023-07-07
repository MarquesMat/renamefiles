#!/bin/bash

# Este arquivo deve ser rodado com autorização de root

# Montar o diretório
mount -t nfs 172.20.0.4:/volume1/Public /mnt/pub

# Definição do caminho base
caminho_base="/var/cache/zoneminder/events/"
caminho_storage="/mnt/pub/testbackup/"
# caminho_base="/home/monitora/Documentos/projeto_monitora/events_copy/"

# Encontrar todas as pastas dentro do caminho base --> monitores
pastas=$(find "$caminho_base" -mindepth 1 -maxdepth 1 -type d)

for pasta in $pastas; do
    # Encontrar todas as subpastas dentro da pasta atual --> dias
    subpastas=$(find "$pasta" -mindepth 1 -maxdepth 1 -type d)

    for sub in $subpastas; do
	# Encontrar todas as subpastas dentro da subpasta atual --> eventos
	subsubpastas=$(find "$sub/" -mindepth 1 -maxdepth 1 -type d)
	
	for subsub in $subsubpastas; do
		
		# Encontrar todos os arquivos dentro da subsubpasta atual --> Vídeos e fotos
		arquivos=$(find "$subsub/" -maxdepth 1 -type f)

		# Loop pelos arquivos encontrados
		for arquivo in $arquivos; do
			# Verificar se o arquivo é um vídeo no formato MP4
                	if file --mime-type "$arquivo" | grep -q "video/mp4"; then
				# Obter o horário de criação do arquivo
				time=$(stat -c %Y "$arquivo")

				# Converter o horário de criação em formato legível
				time_formatado=$(date -d @"$time" "+%Y%m%d_%H%M%S")
				time_formatado="${time_formatado%??}" # Remove os segundos

				# Construir o novo nome do arquivo
				novo_nome="${caminho_storage}$(basename "$pasta")_${time_formatado}"

				# Transfere o arquivo com novo nome, ignorando caso haja um arquivo com o mesmo nome no novo local
				cp -R -u -p "$arquivo" "$novo_nome"

				# Exibir informações sobre a renomeação
				# echo "Arquivo renomeado: $nome_arquivo -> $(basename "$novo_nome")"
				# echo "Horário de criação: $time_formatado"
			fi
	    	done
	done
    done
done

# Desmontar o diretório
umount /mnt/pub
