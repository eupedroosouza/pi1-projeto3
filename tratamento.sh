#!/bin/bash




#verificacao de parametro ausente

while getopts ":a:l:g:t:" opt; do
    case "${opt}" in
        a) entrada=${OPTARG};;
        l) linguagem=${OPTARG};;
        g) algoritmo=${OPTARG};;
        t) tamanho=${OPTARG};;
        *)
	
		echo "Erro!!"
		echo "esperado o Uso de: $0 -a <arquivo.csv> -l <linguagem> -g <algoritmo> -t <tamanho>"; exit 1
		;;
    	esac
done






#calcula a media da primeira coluna, caso vazio retorna 0

if [[ -z "$entrada" || -z "$linguagem" || -z "$algoritmo" || -z "$tamanho" ]]; then
    echo "Erro: argumentos obrigatorios não forneicidos ou incompletos"
    echo "esperado o Uso de: $0 -a <arquivo.csv> -l <linguagem> -g <algoritmo> -t <tamanho>"
    exit 1
fi







#
media=$(awk '{s+=$1} END {if (NR > 0) printf "%.8f\n", s/NR; else print 0}' "$entrada")





#definicao do caminho aonde a saida sera salva
saidas="saidas/${linguagem}_${algoritmo}.csv"



#verifica se ja existe uma saida( gerada de uma interacao anterior)
if [[ ! -f "$saidas" ]]; then
    echo "linguagem;algoritmo;tamanho;media" > "$saidas"
fi




#adiciona uma linha de saida com os dados da media processada nessa interacao

echo "$linguagem;$algoritmo;10^$tamanho;$media" >> "$saidas"

echo "Finalizado! resultados atualizados em: $saidas"


