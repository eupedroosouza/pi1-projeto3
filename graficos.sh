# Arquivo: plot_results.plot
# Uso: gnuplot -c plot_results.plot "input_file=<arquivo_csv>" "language=<linguagem>" "algorithm=<algoritmo>"

# Verifica se os argumentos foram fornecidos
if (!exists("input_file") || !exists("language") || !exists("algorithm")) {
    print "Uso: gnuplot -c plot_results.plot \"input_file=<arquivo_csv>\" \"language=<linguagem>\" \"algorithm=<algoritmo>\""
    exit
}

# Configurações do terminal e saída
set terminal pngcairo enhanced font "Arial,12" size 1000,600
set output sprintf("%s_%s_%s_performance.png", language, algorithm, strftime("%Y%m%d_%H%M%S", time(0)))

# Configurações do título e eixos
set title sprintf("Desempenho do %sSort em %s", \
    toupper(substr(algorithm,1,1)).substr(algorithm,2), \
    language eq "c" ? "C" : "Python")
set xlabel "Número da Execução"
set ylabel "Tempo (segundos)"
set grid

# Adiciona escala logarítmica no eixo y
set logscale y

# Estilo do gráfico
set style data linespoints
set pointintervalbox 3
set pointsize 1.5
set key top left

# Calcula estatísticas
stats input_file using 1 nooutput
mean_time = STATS_mean
min_time = STATS_min
max_time = STATS_max

# Adiciona informações estatísticas
set label 1 sprintf("Média: %.4f s", mean_time) at graph 0.7, 0.9
set label 2 sprintf("Mínimo: %.4f s", min_time) at graph 0.7, 0.85
set label 3 sprintf("Máximo: %.4f s", max_time) at graph 0.7, 0.8

# Plotagem dos dados
plot input_file using 1 with points pt 7 lc rgb "#1E90FF" title "Tempo por execução", \
     mean_time with lines lc rgb "#FF4500" title "Média"

print sprintf("Gráfico salvo como: %s_%s_%s_performance.png", language, algorithm, strftime("%Y%m%d_%H%M%S", time(0)))
