<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:banco="http://www.banco.com/xslt/extensiones"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs banco math"
    expand-text="yes">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- Parámetros de la transformación -->
    <xsl:param name="fecha-corte" as="xs:date" select="current-date()"/>
    <xsl:param name="tasa-interes" as="xs:decimal" select="0.05"/>
    
    <!-- Modos de transformación -->
    <xsl:mode name="agrupar" on-no-match="shallow-copy"/>
    <xsl:mode name="ordenar" on-no-match="shallow-copy"/>
    <xsl:mode name="procesar" on-no-match="shallow-copy"/>
    
    <!-- Funciones XPath personalizadas -->
    <xsl:function name="banco:calcular-interes" as="xs:decimal">
        <xsl:param name="monto" as="xs:decimal"/>
        <xsl:param name="tasa" as="xs:decimal"/>
        <xsl:param name="dias" as="xs:integer"/>
        <xsl:sequence select="($monto * $tasa * $dias) div 360"/>
    </xsl:function>
    
    <xsl:function name="banco:formatear-fechas" as="xs:string">
        <xsl:param name="fecha" as="xs:date"/>
        <xsl:sequence select="format-date($fecha, '[Y0001]-[M01]-[D01]')"/>
    </xsl:function>
    
    <xsl:function name="banco:determinar-nivel-riesgo" as="xs:string">
        <xsl:param name="score" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="$score &lt; 300">Bajo</xsl:when>
            <xsl:when test="$score &lt; 700">Medio</xsl:when>
            <xsl:otherwise>Alto</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Plantilla principal -->
    <xsl:template match="/">
        <banco:Transacciones>
            <xsl:apply-templates select="Transacciones" mode="agrupar"/>
        </banco:Transacciones>
    </xsl:template>
    
    <!-- Agrupación por cliente -->
    <xsl:template match="Transacciones" mode="agrupar">
        <xsl:for-each-group select="Transaccion" group-by="Cliente/ID">
            <Cliente id="{current-grouping-key()}">
                <Nombre>{current-group()[1]/Cliente/Nombre/text()}</Nombre>
                <xsl:apply-templates select="current-group()" mode="ordenar"/>
                <InformeRiesgo>
                    <xsl:apply-templates select="current-group()" mode="procesar"/>
                </InformeRiesgo>
            </Cliente>
        </xsl:for-each-group>
    </xsl:template>
    
    <!-- Ordenación por fecha -->
    <xsl:template match="Transaccion" mode="ordenar">
        <xsl:apply-templates select=".">
            <xsl:sort select="Fecha" order="ascending"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- Procesamiento de transacciones -->
    <xsl:template match="Transaccion" mode="procesar">
        <xsl:variable name="monto" select="xs:decimal(Monto)"/>
        <xsl:variable name="fecha-transaccion" select="xs:date(Fecha)"/>
        <xsl:variable name="dias" select="days-from-duration($fecha-corte - $fecha-transaccion)"/>
        
        <TransaccionProcesada>
            <ID>{ID/text()}</ID>
            <FechaProcesada>{banco:formatear-fechas($fecha-transaccion)}</FechaProcesada>
            <Monto>{$monto}</Monto>
            <Interes>
                <xsl:value-of select="banco:calcular-interes($monto, $tasa-interes, $dias)"/>
            </Interes>
            <NivelRiesgo>
                <xsl:value-of select="banco:determinar-nivel-riesgo(xs:integer(ScoreRiesgo))"/>
            </NivelRiesgo>
        </TransaccionProcesada>
    </xsl:template>
    
    <!-- Copia de elementos básicos -->
    <xsl:template match="*" mode="ordenar">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="ordenar"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Template para atributos -->
    <xsl:template match="@*" mode="ordenar">
        <xsl:copy/>
    </xsl:template>
    
    <!-- Template para texto -->
    <xsl:template match="text()" mode="ordenar">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <!-- Plantilla para manejar elementos desconocidos -->
    <xsl:template match="*" mode="procesar">
        <xsl:message terminate="no">Advertencia: Elemento '{local-name()}' no procesado en modo 'procesar'.</xsl:message>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="procesar"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>"