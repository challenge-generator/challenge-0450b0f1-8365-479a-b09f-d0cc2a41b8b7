# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Transformación avanzada de datos con XSLT en SOA**.

| | |
|---|---|
| Tema | conocimiento en transformacion |
| Nivel | advanced-l2 |
| Chapter | Integración — Analista |
| Especialidad | SOA |
| Stack | XSLT 3.0 / SOA con XML Schema |
| Patron arquitectonico | transformación de datos con patrones XSLT avanzados (modos, plantillas con parámetros, funciones personalizadas) |
| Tiempo estimado | 8 horas |

## Receta del stack

Esqueleto obligatorio:

- `openapi.yaml`
- `proceso.bpmn.md`
- `mapeo-de-datos.csv`

Dependencias:

- Saxon-HE 12.4
- XML Schema Definition (XSD) 1.1 n/a
- XPath 3.1 n/a
- Markdown (para documentación) n/a

## Tu tarea

Dejar este conjunto de artefactos en estado **verificable**: que el comando de verificacion corra sin errores. Escribi los archivos en disco, en este repositorio. No generes ZIPs ni archivos adjuntos.

En orden:

1. Corre `npx --yes @redocly/cli lint openapi.yaml` y mira que falla.
2. Completa lo que falte de la lista de abajo: manifiesto de dependencias, punto de entrada, capa de interfaz y las capas del patron declarado.
3. Arregla SOLO los errores que impiden compilar o arrancar.
4. Volve a correr `npx --yes @redocly/cli lint openapi.yaml` hasta que pase.
5. Pará ahí.

## Regla dura: las fases son trabajo del humano

**PROHIBIDO implementar los entregables de las fases.** El valor del reto esta en que la persona los resuelva. Tu trabajo es que tenga un proyecto que arranca; el hueco pedagogico se queda como esta.

No resuelvas nada de esto:

- **Fase 1 — Exploración del sistema y restricciones**: Documento que detalla las restricciones y ambigüedades identificadas en el proceso de transformación de datos.
- **Fase 2 — Implementación de transformaciones avanzadas**: Transformación XSLT que incluye agrupaciones y ordenaciones avanzadas de datos, junto con la documentación del proceso de implementación.
- **Fase 3 — Evaluación y comunicación de resultados**: Documento que detalla la evaluación del impacto de las transformaciones en el sistema y la comunicación de resultados a diferentes audiencias.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Lo que falta y tenes que completar

No se detectaron huecos: estan los archivos declarados, el boilerplate del stack y ninguna referencia quedo colgando. Igual corre el comando de verificacion — que los archivos existan no garantiza que compilen.

### Presentes (12)

- `src/schemas/datos-origen.xsd`
- `src/schemas/datos-destino.xsd`
- `openapi.yaml`
- `proceso.bpmn.md`
- `mapeo-de-datos.csv`
- `README.md`
- `src/xslt/transformacion-avanzada.xslt`
- `examples/datos-entrada.xml`
- `examples/datos-salida-esperada.xml`
- `docs/restricciones-y-ambiguedades.md`
- `docs/implementacion-transformacion.md`
- `docs/evaluacion-impacto.md`

### Capas del patron declarado

Cada una tiene que existir como directorio real con al menos un archivo. Codigo plano en la raiz no satisface el patron.

- `src`
- `src/xslt`
- `src/schemas`
- `docs`
- `examples`

## Verificacion

```bash
npx --yes @redocly/cli lint openapi.yaml
```

Ese comando pasando es la definicion de "terminado" para vos.

## Convenciones que tenes que respetar

- Un solo ecosistema: no declares librerias de otro lenguaje ni mezcles gestores de paquetes.
- Toda libreria que uses tiene que estar declarada en el manifiesto de dependencias.
- Todo import declarado tiene que usarse; todo tipo usado tiene que existir o venir de una dependencia declarada.
- El patron es **transformación de datos con patrones XSLT avanzados (modos, plantillas con parámetros, funciones personalizadas)**: los contratos (interfaces, puertos) los define la capa interna y los implementa la externa, nunca al revés.
- Los archivos que crees llevan implementacion real, no stubs: sin `TODO`, sin cuerpos vacios, sin `// getters y setters`.

## Contexto del candidato

Sirve para calibrar el nivel del codigo, no para resolver las fases.

- Perfil: Chapter Integración, Especialidad Analista SOA, Advanced
- Brecha que el reto ataca: ¿Cuál es la importancia de los modos y la selección de nodos en XSLT? Detalla cómo se podría realizar la agrupación y ordenación avanzada de datos en una transformación XSLT. ¿Cómo se podrían implementar extensiones personalizadas o mecanismos de scripting en documentos XML? ¿Cuál es el papel de XML en arquitecturas orientadas a servicios (SOA) y aplicaciones empresariales?
- Mision: Candidato con experiencia en análisis SOA e integración empresarial.

---

*Generado por Challenge Generator — Pragma. `README.md` tiene el enunciado completo del reto para la persona. `PROMPT_MEJORA.md` es la variante para pegar en un chat, si se prefiere ese flujo.*
