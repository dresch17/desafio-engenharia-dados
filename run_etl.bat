@echo off

set "DIRETORIO_SAIDA=%~1"

if "%DIRETORIO_SAIDA%"=="" (
    set "DIRETORIO_SAIDA=output"
)

echo ========================================
echo Executando ETL com PySpark
echo Diretorio de saida: %DIRETORIO_SAIDA%
echo ========================================

docker compose exec spark /opt/spark/bin/spark-submit ^
  --packages org.postgresql:postgresql:42.7.7 ^
  /opt/spark/work-dir/src/etl.py ^
  "%DIRETORIO_SAIDA%"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO na execucao do ETL.
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo ETL finalizado com sucesso
echo Arquivo: %DIRETORIO_SAIDA%\movimento_flat.csv
echo ========================================