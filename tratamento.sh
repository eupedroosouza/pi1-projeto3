#!/bin/bash


arquivos=(
    "c_bubble.csv"
    "c_merge.csv"
    "python_bubble.csv"
    "python_merge.csv"
)

#

for arquivo in "${arquivos[@]}"; do
    caminho="saidas/$arquivo"
    if [[ ! -f "$caminho" ]]; then
        echo "linguagem;algoritmo;tamanho;media" > "$caminho"
        echo "Arquivo criado: $caminho"
    fi
done

#
while getopts ":a:l:g:t:" opt; do
    case "${opt}" in
        a) entrada=${OPTARG};;
        l) linguagem=${OPTARG};;
        g) algoritmo=${OPTARG};;
        t) tamanho=${OPTARG};;
        *)
            echo "Erro!!"
            echo "Uso esperado: $0 -a <arquivo.csv> -l <linguagem> -g <algoritmo> -t <tamanho>"
            exit 1
            ;;
    esac
done

#
if [[ -z "$entrada" || -z "$linguagem" || -z "$algoritmo" || -z "$tamanho" ]]; then
    echo "Erro: argumentos obrigatórios não fornecidos ou incompletos"
    echo "Uso esperado: $0 -a <arquivo.csv> -l <linguagem> -g <algoritmo> -t <tamanho>"
    exit 1
fi

#
media=$(awk '{s+=$1} END {if (NR > 0) printf "%.8f\n", s/NR; else print 0}' "$entrada")

#
arquivo_entrada="${linguagem}_${algoritmo}.csv"
caminho_saida="saidas/$arquivo_entrada"

#
if [[ ! " ${arquivos[*]} " =~ " ${arquivo_entrada} " ]]; then
    echo "Erro: arquivo de saída inválido. Apenas arquivos fixos permitidos:"
    for f in "${arquivos[@]}"; do echo "- $f"; done
    exit 1
fi

#
if [[ ! -f "$caminho_saida" ]]; then
    echo "linguagem;algoritmo;tamanho;media" > "$caminho_saida"
fi

v_tamanho=$((10 ** tamanho))

#
echo "$linguagem;$algoritmo;$v_tamanho;$media" >> "$caminho_saida"

echo "Finalizado! Resultados atualizados em: $caminho_saida"


cpu_name=$(lscpu | grep "Model name:" | sed 's/Model name:[ \t]*//')
ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram_gb=$((ram_kb / 1024 / 1024))
hardware="${cpu_name} - ${ram_gb} GB RAM"

com_numero=""


gnuplot -e "hardware='${hardware}'; com_numero='${com_numero}'" modelo_grafico.plt

echo "Gráfico gerado em ./graficos/"
