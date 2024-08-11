# Análisis de Precios de Acciones Big Tech

## Resumen

Este repositorio contiene un análisis de datos sobre los precios diarios de acciones de las 14 compañías tecnológicas más importantes de Estados Unidos. El conjunto de datos se ha obtenido de Yahoo Finance a través de Kaggle, propuestos por Evan Gower. El objetivo de este análisis es demostrar habilidades técnicas en R, abordando información relevante sobre las tendencias de precios de las acciones de las principales empresas tecnológicas.

## Datos

-   **Tidy Tuesday dataset:** [Big Tech Stock Prices](https://github.com/rfordatascience/tidytuesday/blob/master/data/2023/2023-02-07/readme.md)
-   **Dataset Original:** [Big Tech Stock Prices](https://www.kaggle.com/datasets/evangower/big-tech-stock-prices)
-   **Información Adicional:** Este conjunto de datos incluye información diaria sobre los precios y volúmenes de acciones de empresas como Apple (AAPL), Amazon (AMZN), Alphabet (GOOGL), Meta Platforms (META), y más.

## Contexto

Las acciones de las grandes tecnológicas muestran una tendencia aparente de caída significativa durante el período de los datos. La elección de este conjunto de datos está relacionada a empresas que operan en servicios financieros, y se espera que este análisis brinde información relevante sobre las tendencias del mercado tecnológico.

## Objetivos del Análisis

1.  **Obtener información relevante**
    -   Identificar patrones o eventos que podrían haber contribuido a las caídas significativas de precios.
    -   Analizar la correlación entre las acciones de diferentes empresas tecnológicas.
2.  **Elección del dataset:**
    -   Relevancia de las acciones tecnológicas para empresas objetivo.
    -   La variabilidad o volatilidad en los precios puede ofrecer perspectivas de inversión y riesgo.

## Herramientas

-   Se utilizará R para realizar el análisis, aprovechando las capacidades de RMarkdown y Quarto para la creación de una presentación.
-   Se emplearán consultas SQL a través de la biblioteca DBI para simular operaciones en una base de datos.

## Estructura del repositorio

-   **ppt:** 
-   **doc:** El análisis se presenta en formato de documento técnico utilizando Quarto con Reveal.js. Se incluye una versión en formato PDF que puede encontrarse [aquí](doc/technical_es.pdf).
-   **data:** Directorio donde se almacenan los datos originales y las tablas generadas.
-   **core:** Directorio donde se ocupa el código utilizado para el análisis.
-   **img:** Se reserva un directorio para imágenes en caso de necesitar.

## Requisitos

Asegúrese de tener R y las bibliotecas necesarias instaladas. Consulte el archivo `renv.lock` para mayor detalle.

## Pendiente

Los siguientes bloques de códigos ("chunks") están pendientes de mejora: chunk 6 y 7

------------------------------------------------------------------------

**Nota:** Se recomienda clonar este repositorio y ejecutar el código en su propio entorno para replicar los resultados.
