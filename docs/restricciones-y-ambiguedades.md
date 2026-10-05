# Restricciones y Ambiguedades en la Transformación de Datos Bancarios

## Introducción
Este documento identifica y clasifica las restricciones operativas y ambigüedades encontradas durante el proceso de transformación de datos bancarios entre sistemas SOA utilizando XSLT 3.0. Las restricciones se dividen en **triviales** (fáciles de resolver con validaciones básicas) y **críticas** (requieren cambios en el diseño de esquemas o lógica de transformación).

---

## 1. Restricciones del Esquema de Origen (`datos-origen.xsd`)

### 1.1. Restricciones Triviales

#### a) Formato de Fecha (`<fechaOperacion>`)
- **Descripción**: El campo `<fechaOperacion>` debe seguir el formato `YYYY-MM-DD`.
- **Ejemplo válido**: `<fechaOperacion>2023-10-15</fechaOperacion>`
- **Ejemplo inválido**: `<fechaOperacion>15/10/2023</fechaOperacion>`
- **Impacto**: Error de validación al parsear el XML de entrada.
- **Solución**: Validación con expresión regular en el esquema XSD:
  ```xml
  <xs:pattern value="\d{4}-\d{2}-\d{2}"/>
  ```

#### b) Rango de Montos (`<monto>`)
- **Descripción**: Los montos transaccionales deben ser valores positivos con hasta 2 decimales.
- **Ejemplo válido**: `<monto>1500.75</monto>`
- **Ejemplo inválido**: `<monto>-200</monto>` o `<monto>1500.755</monto>`
- **Impacto**: Rechazo de transacciones con valores fuera de rango.
- **Solución**: Restricción en el esquema XSD:
  ```xml
  <xs:minInclusive value="0"/>
  <xs:fractionDigits value="2"/>
  ```

### 1.2. Restricciones Críticas

#### a) Cardinalidad de Cuentas (`<cuentas>`)
- **Descripción**: El esquema permite múltiples cuentas por cliente, pero el sistema destino solo acepta **una cuenta principal** por cliente.
- **Ambiguedad**: ¿Cómo determinar cuál de las cuentas múltiples es la "principal"?
- **Ejemplo**:
  ```xml
  <cliente>
    <id>CLI-123</id>
    <cuentas>
      <cuenta tipo="ahorro">CA-456</cuenta>
      <cuenta tipo="corriente">CC-789</cuenta>
    </cuentas>
  </cliente>
  ```
- **Impacto**: Si no se resuelve, el sistema destino generará errores de duplicidad o rechazará el registro.
- **Soluciones propuestas**:
  1. **Priorizar por tipo de cuenta**: Definir una jerarquía (ej. `corriente > ahorro > inversión`).
  2. **Usar atributo `principal`**: Añadir un atributo `<cuenta principal="true">` en el esquema de origen.
  3. **Implementar lógica en XSLT**: Seleccionar la primera cuenta como principal (riesgo alto).

#### b) Transformación de Tipos de Transacción
- **Descripción**: El esquema de origen usa códigos numéricos para tipos de transacción (ej. `1=Transferencia`, `2=Pago`), mientras que el destino usa nombres descriptivos (`"TRANSFER"`, `"PAYMENT"`).
- **Ambiguedad**: ¿Dónde debe realizarse el mapeo?
  - **Opción 1**: En el esquema de origen (requiere modificación del sistema fuente).
  - **Opción 2**: En la transformación XSLT (lógica adicional).
  - **Opción 3**: En el esquema de destino (validación flexible).
- **Impacto**: Si el mapeo es incorrecto, las transacciones se clasificarán erróneamente.
- **Solución recomendada**: Usar una función XPath personalizada en XSLT para el mapeo:
  ```xslt
  <xsl:function name="banco:mapear-tipo-transaccion" as="xs:string">
    <xsl:param name="codigo" as="xs:integer"/>
    <xsl:sequence select="
      if ($codigo = 1) then 'TRANSFER'
      else if ($codigo = 2) then 'PAYMENT'
      else 'UNKNOWN'
    "/>
  </xsl:function>
  ```

---

## 2. Restricciones del Esquema de Destino (`datos-destino.xsd`)

### 2.1. Restricciones Triviales

#### a) Longitud de Campos (`<idCliente>`)
- **Descripción**: El campo `<idCliente>` debe tener exactamente 10 caracteres alfanuméricos.
- **Ejemplo válido**: `<idCliente>CLI-123456</idCliente>`
- **Ejemplo inválido**: `<idCliente>CLI123</idCliente>`
- **Solución**: Validación en XSD:
  ```xml
  <xs:length value="10"/>
  ```

### 2.2. Restricciones Críticas

#### a) Dependencia entre Campos (`<saldo>` y `<moneda>`)
- **Descripción**: El campo `<saldo>` debe incluir el símbolo de la moneda (`<moneda>`) como prefijo.
- **Ejemplo válido**: `<saldo>USD 1500.75</saldo>` con `<moneda>USD</moneda>`
- **Ejemplo inválido**: `<saldo>USD 1500.75</saldo>` con `<moneda>EUR</moneda>`
- **Impacto**: Inconsistencia en reportes financieros.
- **Solución**: Validación en el esquema de destino con `xs:assert`:
  ```xml
  <xs:assert test="starts-with(saldo, moneda)"/>
  ```

#### b) Agrupación de Transacciones por Cliente
- **Descripción**: El esquema de destino requiere que las transacciones se agrupen bajo un elemento `<transacciones>` por cliente.
- **Ambiguedad**: ¿Cómo manejar clientes sin transacciones?
  - **Opción 1**: Omitir el elemento `<transacciones>` si está vacío.
  - **Opción 2**: Incluir `<transacciones/>` aunque esté vacío (mejor para consistencia).
- **Impacto**: Si se omite, el sistema destino puede interpretar que el cliente no existe.
- **Solución recomendada**: Incluir siempre el elemento `<transacciones>`:
  ```xslt
  <xsl:template match="cliente">
    <cliente>
      <xsl:copy-of select="id, nombre"/>
      <transacciones>
        <xsl:apply-templates select="transacciones/transaccion"/>
      </transacciones>
    </cliente>
  </xsl:template>
  ```

---

## 3. Ambiguedades en la Lógica de Transformación

### 3.1. Manejo de Valores Nulos
- **Descripción**: El esquema de origen permite campos opcionales (ej. `<segundoNombre>`), pero el destino requiere valores por defecto.
- **Ejemplo**:
  ```xml
  <!-- Origen -->
  <cliente>
    <primerNombre>Juan</primerNombre>
    <!-- segundoNombre ausente -->
  </cliente>
  
  <!-- Destino esperado -->
  <cliente>
    <nombres>Juan [SIN SEGUNDO NOMBRE]</nombres>
  </cliente>
  ```
- **Solución**: Usar `xsl:if` o `xsl:choose` en la transformación:
  ```xslt
  <nombres>
    <xsl:value-of select="primerNombre"/>
    <xsl:text> </xsl:text>
    <xsl:if test="not(segundoNombre)">
      <xsl:text>[SIN SEGUNDO NOMBRE]</xsl:text>
    </xsl:if>
  </nombres>
  ```

### 3.2. Ordenamiento de Transacciones
- **Descripción**: El sistema destino requiere que las transacciones se ordenen por fecha descendente.
- **Ambiguedad**: ¿Debe ordenarse antes o después de la agrupación por cliente?
- **Impacto**: Si se ordena antes, la agrupación puede romper el orden.
- **Solución**: Ordenar después de agrupar:
  ```xslt
  <xsl:template match="transacciones">
    <transacciones>
      <xsl:apply-templates select="transaccion">
        <xsl:sort select="fechaOperacion" order="descending"/>
      </xsl:apply-templates>
    </transacciones>
  </xsl:template>
  ```

### 3.3. Extensiones Personalizadas
- **Descripción**: La transformación requiere cálculos complejos (ej. intereses, comisiones) que no pueden expresarse con XPath estándar.
- **Ambiguedad**: ¿Implementar la lógica en XSLT (con funciones XPath) o delegar a un servicio externo?
- **Solución recomendada**: Usar funciones XPath 3.1 para mantener la transformación autocontenida:
  ```xslt
  <xsl:function name="banco:calcular-comision" as="xs:decimal">
    <xsl:param name="monto" as="xs:decimal"/>
    <xsl:sequence select="$monto * 0.01"/>
  </xsl:function>
  ```

---

## 4. Ejemplos de Restricciones en Contextos Reales

### 4.1. Restricción Trivial: Validación de Formato
- **Contexto**: Un archivo XML con fechas en formato `DD/MM/YYYY` falla al validarse contra el esquema.
- **Solución**: Usar un preprocesador para convertir el formato antes de la transformación.

### 4.2. Restricción Crítica: Mapeo de Tipos de Cuenta
- **Contexto**: El sistema origen clasifica cuentas como `1=Ahorro`, `2=Corriente`, pero el destino usa `SAVINGS`, `CHECKING`.
- **Solución**: Añadir un mapeo en la transformación XSLT:
  ```xslt
  <xsl:variable name="tipoCuentaMap" as="map(xs:integer, xs:string)">
    <xsl:map>
      <xsl:entry key="1" value="'SAVINGS'"/>
      <xsl:entry key="2" value="'CHECKING'"/>
    </xsl:map>
  </xsl:variable>
  ```

---

## 5. Conclusiones y Recomendaciones

1. **Priorizar restricciones críticas**: Las ambiguedades en cardinalidad y mapeos deben resolverse antes de implementar la transformación.
2. **Validación temprana**: Usar esquemas XSD para validar datos de entrada y salida, evitando errores en etapas posteriores.
3. **Documentar decisiones**: Cada ambigüedad resuelta debe documentarse en este archivo con su justificación.
4. **Pruebas con ejemplos**: Incluir casos de prueba que cubran todas las restricciones (ver `examples/datos-entrada.xml`).

---

*Última actualización: [Fecha automática de generación]*