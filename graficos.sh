# Arquivo: plot_results.plot
# Uso: gnuplot -c plot_results.plot <arquivo_csv> <linguagem> <algoritmo>

# Verifica se os argumentos foram fornecidos
if (!exists("input_file") || !exists("language") || !exists("algorithm")) {
    print "Uso: gnuplot -c plot_results.plot \"input_file=<arquivo_csv>\" \"language=<linguagem>\" \"algorithm=<algoritmo>\""
    exit
}

# Configurações gerais do gráfico
set terminal pngcairo enhanced font "Arial,12" size 1000,600
set output sprintf("%s_%s_%s_performance.png", language, algorithm, strftime("%Y%m%d_%H%M%S", time(0)))

# Título e labels
set title sprintf("Desempenho do %sSort em %s", toupper(substr(algorithm,1,1)).substr(algorithm,2), \
    language eq "c" ? "C" : "Python"
set xlabel "Execução"
set ylabel "Tempo (segundos)"
set grid

# Estilo do gráfico
set style data linespoints
set pointintervalbox 3
set pointsize 1.5

# Calcula a média dos tempos
stats input_file nooutput
mean_time = STATS_mean
min_time = STATS_min
max_time = STATS_max

# Define a legenda
set label 1 sprintf("Média: %.4f s", mean_time) at graph 0.7, 0.9
set label 2 sprintf("Mínimo: %.4f s", min_time) at graph 0.7, 0.85
set label 3 sprintf("Máximo: %.4f s", max_time) at graph 0.7, 0.8

# Plota os dados
plot input_file using 1 with points pt 7 lc rgb "#1E90FF" title "Tempo por execução", \
     mean_time with lines lc rgb "#FF4500" title "Média"

print sprintf("Gráfico gerado com sucesso: %s_%s_%s_performance.png", language, algorithm, strftime("%Y%m%d_%H%M%S", time(0)))
