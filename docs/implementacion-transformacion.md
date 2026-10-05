# Implementación de Transformaciones Avanzadas con XSLT 3.0

## 1. Diseño de la Transformación

### 1.1. Objetivos
La transformación XSLT (`transformacion-avanzada.xslt`) tiene como objetivos:
- Convertir datos bancarios desde el esquema de origen (`datos-origen.xsd`) al esquema de destino (`datos-destino.xsd`).
- Realizar agrupaciones y ordenaciones avanzadas de transacciones.
- Integrar extensiones personalizadas para cálculos financieros.
- Manejar restricciones y ambigüedades documentadas en `restricciones-y-ambiguedades.md`.

### 1.2. Principios de Diseño

#### a) Modularidad
- **Modos XSLT**: Se usan modos para separar lógica de transformación:
  - `modo="copiar"`: Copia elementos sin cambios.
  - `modo="agrupar"`: Agrupa transacciones por cliente.
  - `modo="calcular"`: Aplica funciones personalizadas.

  ```xslt
  <xsl:mode name="agrupar" on-no-match="shallow-copy"/>
  <xsl:mode name="calcular" on-no-match="shallow-copy"/>
  ```

#### b) Reutilización
- **Plantillas con parámetros**: Para evitar duplicación de lógica:
  ```xslt
  <xsl:template match="transaccion" mode="formatear-monto">
    <xsl:param name="moneda" select="'USD'"/>
    <monto>
      <xsl:value-of select="concat($moneda, ' ', format-number(monto, '#,##0.00'))"/>
    </monto>
  </xsl:template>
  ```

#### c) Extensiones Personalizadas
- **Funciones XPath 3.1**: Para cálculos complejos:
  ```xslt
  <xsl:function name="banco:calcular-interes" as="xs:decimal">
    <xsl:param name="capital" as="xs:decimal"/>
    <xsl:param name="tasa" as="xs:decimal"/>
    <xsl:param name="dias" as="xs:integer"/>
    <xsl:sequence select="($capital * $tasa * $dias) div 360"/>
  </xsl:function>
  ```

---

## 2. Estructura de la Transformación

### 2.1. Declaraciones Iniciales

```xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:banco="http://banco.com/xslt"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs banco math">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <!-- Importar esquemas para validación -->
  <xsl:import-schema schema-location="../schemas/datos-origen.xsd" namespace="http://banco.com/origen"/>
  <xsl:import-schema schema-location="../schemas/datos-destino.xsd" namespace="http://banco.com/destino"/>

  <!-- Modos -->
  <xsl:mode name="copiar" on-no-match="shallow-copy"/>
  <xsl:mode name="agrupar" on-no-match="shallow-copy"/>
  <xsl:mode name="calcular" on-no-match="shallow-copy"/>

  <!-- Variables globales -->
  <xsl:variable name="monedaPorDefecto" select="'USD'"/>

</xsl:stylesheet>
```

### 2.2. Plantillas Principales

#### a) Plantilla Raíz

```xslt
<xsl:template match="/">
  <xsl:variable name="datosValidados" as="element()">
    <xsl:apply-templates select="banco:validar-datos(.)" mode="copiar"/>
  </xsl:variable>
  <resultado>
    <xsl:apply-templates select="$datosValidados" mode="agrupar"/>
  </resultado>
</xsl:template>
```

#### b) Validación de Datos

```xslt
<xsl:function name="banco:validar-datos" as="element()">
  <xsl:param name="entrada" as="element()"/>
  <xsl:try>
    <xsl:copy-of select="$entrada"/>
    <xsl:catch>
      <error>
        <codigo>VALIDACION</codigo>
        <mensaje>Error al validar datos: <xsl:value-of select="$err:description"/></mensaje>
      </error>
    </xsl:catch>
  </xsl:try>
</xsl:function>
```

#### c) Agrupación por Cliente

```xslt
<xsl:template match="clientes" mode="agrupar">
  <clientes>
    <xsl:for-each-group select="cliente" group-by="id">
      <cliente>
        <xsl:apply-templates select="current-group()[1]" mode="copiar"/>
        <transacciones>
          <xsl:apply-templates select="current-group()/transacciones/transaccion" mode="agrupar">
            <xsl:sort select="fechaOperacion" order="descending"/>
          </xsl:apply-templates>
        </transacciones>
      </cliente>
    </xsl:for-each-group>
  </clientes>
</xsl:template>
```

---

## 3. Decisiones de Implementación

### 3.1. Uso de Modos XSLT
- **Motivación**: Separar responsabilidades (copiar vs. transformar vs. calcular).
- **Ejemplo**:
  ```xslt
  <xsl:template match="monto" mode="calcular">
    <monto>
      <xsl:value-of select="banco:formatear-monto(., $monedaPorDefecto)"/>
    </monto>
  </xsl:template>
  ```

### 3.2. Agrupaciones Avanzadas
- **Técnica**: `xsl:for-each-group` con `group-by`:
  ```xslt
  <xsl:for-each-group select="transaccion" group-by="idCliente">
    <xsl:sort select="fechaOperacion" order="descending"/>
    <transaccion>
      <xsl:copy-of select="current-group()[1]/*"/>
    </transaccion>
  </xsl:for-each-group>
  ```

### 3.3. Manejo de Valores Nulos
- **Solución**: Usar `xsl:if` y valores por defecto:
  ```xslt
  <xsl:template match="segundoNombre">
    <xsl:if test=". != ''">
      <segundoNombre><xsl:value-of select="."/></segundoNombre>
    </xsl:if>
  </xsl:template>
  ```

### 3.4. Extensiones Personalizadas
- **Ejemplo**: Cálculo de intereses acumulados:
  ```xslt
  <xsl:function name="banco:intereses-acumulados" as="xs:decimal">
    <xsl:param name="transacciones" as="element(transaccion)*"/>
    <xsl:sequence select="sum(
      $transacciones ! banco:calcular-interes(monto, 0.05, 30)
    )"/>
  </xsl:function>
  ```

---

## 4. Ejemplo de Transformación Paso a Paso

### 4.1. Datos de Entrada (`examples/datos-entrada.xml`)

```xml
<clientes>
  <cliente>
    <id>CLI-123</id>
    <nombre>Juan Pérez</nombre>
    <cuentas>
      <cuenta tipo="1">CA-456</cuenta>
    </cuentas>
    <transacciones>
      <transaccion>
        <id>TX-001</id>
        <fechaOperacion>2023-10-15</fechaOperacion>
        <monto>1000.00</monto>
        <tipo>1</tipo>
      </transaccion>
    </transacciones>
  </cliente>
</clientes>
```

### 4.2. Transformación Aplicada

1. **Validación**: El XML se valida contra `datos-origen.xsd`.
2. **Agrupación**: Las transacciones se agrupan por cliente y ordenan por fecha descendente.
3. **Mapeo de Tipos**: El campo `<tipo>` se mapea de `1` a `"TRANSFER"`.
4. **Formateo**: El monto se formatea como `"USD 1,000.00"`.
5. **Cálculos**: Se aplican funciones personalizadas (ej. intereses).

### 4.3. Datos de Salida (`examples/datos-salida-esperada.xml`)

```xml
<clientes>
  <cliente>
    <id>CLI-123</id>
    <nombre>Juan Pérez</nombre>
    <cuentaPrincipal>CA-456</cuentaPrincipal>
    <transacciones>
      <transaccion>
        <id>TX-001</id>
        <fechaOperacion>2023-10-15</fechaOperacion>
        <monto>USD 1,000.00</monto>
        <tipo>TRANSFER</tipo>
        <interesAcumulado>4.17</interesAcumulado>
      </transaccion>
    </transacciones>
  </cliente>
</clientes>
```

---

## 5. Validación y Pruebas

### 5.1. Validación del Esquema
- **Herramienta**: Saxon-HE 12.4 con validación de esquemas.
- **Comando**:
  ```bash
  java -jar saxon-he-12.4.jar -xsl:src/xslt/transformacion-avanzada.xslt -s:examples/datos-entrada.xml -o:output.xml -val
  ```

### 5.2. Pruebas Unitarias
- **Casos de prueba**: Cubren agrupaciones, cálculos y manejo de valores nulos.
- **Ejemplo**:
  ```xml
  <!-- Test de agrupación -->
  <test-case>
    <input>
      <cliente>
        <id>CLI-123</id>
        <transacciones>
          <transaccion><fechaOperacion>2023-10-10</fechaOperacion></transaccion>
          <transaccion><fechaOperacion>2023-10-15</fechaOperacion></transaccion>
        </transacciones>
      </cliente>
    </input>
    <expected>
      <transacciones>
        <transaccion><fechaOperacion>2023-10-15</fechaOperacion></transaccion>
        <transaccion><fechaOperacion>2023-10-10</fechaOperacion></transaccion>
      </transacciones>
    </expected>
  </test-case>
  ```

### 5.3. Pruebas de Rendimiento
- **Métrica**: Tiempo de transformación para 10,000 registros.
- **Herramienta**: `xsltproc` con medición de tiempo:
  ```bash
  time xsltproc src/xslt/transformacion-avanzada.xslt examples/datos-entrada-grande.xml > /dev/null
  ```

---

## 6. Mantenimiento y Evolución

### 6.1. Documentación Adicional
- **`mapeo-de-datos.csv`**: Detalla cada campo origen → destino con reglas de transformación.
- **`proceso.bpmn.md`**: Muestra el flujo de negocio y puntos de decisión.

### 6.2. Recomendaciones para Futuras Versiones
1. **Migrar a XSLT 4.0**: Para aprovechar nuevas funciones como `xsl:iterate`.
2. **Integración con servicios**: Delegar cálculos complejos a microservicios.
3. **Generación automática**: Usar herramientas como Oxygen XML para generar plantillas base.

---

*Última actualización: [Fecha automática de generación]*