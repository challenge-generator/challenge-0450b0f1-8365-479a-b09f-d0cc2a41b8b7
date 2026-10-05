# Transformación avanzada de datos con XSLT en SOA

En el dominio de la banca, la transformación de datos es crucial para la integración de sistemas y el intercambio de información entre diferentes aplicaciones empresariales. En este desafío, te enfrentarás a la tarea de realizar transformaciones avanzadas utilizando XSLT, integrando extensiones personalizadas y mecanismos de scripting para mejorar la funcionalidad y eficiencia de los procesos de transformación. Debes considerar los modos y la selección de nodos en XSLT, así como la importancia de XML en arquitecturas orientadas a servicios (SOA) y aplicaciones empresariales.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | conocimiento en transformacion |
| **Nivel** | advanced-l2 |
| **Tipo** | mixed |
| **Tiempo estimado** | 8 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y generará un ZIP listo para usar.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Un IDE o editor de código.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y generará un archivo ZIP descargable. Descárgalo y extráelo en la carpeta donde quieras trabajar.
- Verifica que el proyecto arranca sin errores.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no genera el ZIP automáticamente al terminar el análisis, escríbele: "genera el ZIP ahora".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Exploración del sistema y restricciones

**Objetivo:** Identificar las restricciones y ambigüedades en el proceso de transformación de datos utilizando XSLT.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Analiza el sistema de transformación de datos en una arquitectura SOA.
- Identifica las restricciones operativas y los posibles puntos de ambigüedad en el proceso de transformación.
- Documenta las restricciones relevantes y proporciona ejemplos que distingan entre restricciones triviales y críticas.

**Entregable:** Documento que detalla las restricciones y ambigüedades identificadas en el proceso de transformación de datos.

<details>
<summary>Pistas de conocimiento</summary>

- Considera los modos y la selección de nodos en XSLT.
- Reflexiona sobre la importancia de XML en SOA y aplicaciones empresariales.

</details>

### Fase 2: Implementación de transformaciones avanzadas

**Objetivo:** Realizar agrupaciones y ordenaciones avanzadas de datos utilizando XSLT.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Diseña y desarrolla una transformación XSLT que incluya agrupaciones y ordenaciones avanzadas de datos.
- Considera la implementación de extensiones personalizadas o mecanismos de scripting para mejorar la funcionalidad de la transformación.
- Documenta el proceso de implementación y los resultados obtenidos.

**Entregable:** Transformación XSLT que incluye agrupaciones y ordenaciones avanzadas de datos, junto con la documentación del proceso de implementación.

<details>
<summary>Pistas de conocimiento</summary>

- Explora las posibilidades de extensiones personalizadas y mecanismos de scripting en XSLT.
- Considera el impacto de las transformaciones en la eficiencia y funcionalidad del sistema.

</details>

### Fase 3: Evaluación y comunicación de resultados

**Objetivo:** Evaluar el impacto de las transformaciones en el sistema y comunicar los resultados a diferentes audiencias.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Evalúa el impacto de las transformaciones avanzadas en el sistema, considerando aspectos como la eficiencia, funcionalidad y mantenimiento.
- Comunica los resultados y hallazgos a diferentes audiencias, incluyendo técnicos y no técnicos, asegurando que cada grupo comprenda la importancia y los beneficios de las transformaciones realizadas.
- Documenta la evaluación y la comunicación de resultados.

**Entregable:** Documento que detalla la evaluación del impacto de las transformaciones en el sistema y la comunicación de resultados a diferentes audiencias.

<details>
<summary>Pistas de conocimiento</summary>

- Considera los diferentes aspectos que pueden verse afectados por las transformaciones, como la eficiencia, funcionalidad y mantenimiento.
- Piensa en cómo presentar los resultados de manera clara y efectiva para diferentes audiencias.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Cuál es la importancia de los modos y la selección de nodos en XSLT?
- **paraQueSirve**: ¿Cómo se podrían realizar agrupaciones y ordenaciones avanzadas de datos en una transformación XSLT?
- **comoSeUsa**: ¿Cómo se podrían implementar extensiones personalizadas o mecanismos de scripting en documentos XML?
- **erroresComunes**: ¿Cuáles son los errores comunes al realizar transformaciones avanzadas con XSLT?
- **queDecisionesImplica**: ¿Qué decisiones implica la implementación de transformaciones avanzadas en una arquitectura SOA?

## Criterios de Evaluacion

- Identificar restricciones y ambigüedades en el proceso de transformación de datos.
- Implementar transformaciones avanzadas con agrupaciones y ordenaciones en XSLT.
- Evaluar el impacto de las transformaciones en el sistema y comunicar los resultados a diferentes audiencias.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT). Devuelve un ZIP con el proyecto. Sirve si no tenes un agente en el IDE.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
npx --yes @redocly/cli lint openapi.yaml
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
