@echo off

echo ========================================
echo Executando ETL com PySpark
echo ========================================

docker compose exec spark /opt/spark/bin/spark-submit ^
  --packages org.postgresql:postgresql:42.7.7 ^
  /opt/spark/work-dir/src/etl.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO na execucao do ETL.
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo ETL finalizado com sucesso
echo Arquivo: output\movimento_flat.csv
echo ========================================