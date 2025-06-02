#!/bin/bash




#

while getopts ":a:l:g:" opt; do
    case "${opt}" in
        a) entrada=${OPTARG};;
        l) linguagem=${OPTARG};;
        g) algoritmo=${OPTARG};;
        *)
	
		echo "Erro!!"
		echo "esperado o Uso de: $0 -a <arquivo.csv> -l <linguagem> -g <algoritmo>"; exit 1
		;;
    	esac
done






#

if [[ -z "$arquivoEntrada" || -z "$linguagem" || -z "$algoritmo" ]]; then
    echo "Erro: argumentos obrigatorios não forneicidos ou incompletos"
    echo "esperado o Uso de: $0 -a <arquivo.csv> -l <linguagem> -g <algoritmo>"
    exit 1
fi







#
media=$(awk '{s+=$1} END {if (NR > 0) print s/NR; else print 0}' "$entrada")





#
saidas="saidas.csv"



#
if [[ ! -f "$saidas" ]]; then
    echo "linguagem;algoritmo;media" > "$saidas"
fi




#
echo "$linguagem;$algoritmo;$media" >> "$saidas"

echo "Finalizado! resultados atualizados em: $saidas"


