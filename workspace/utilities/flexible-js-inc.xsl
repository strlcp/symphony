<!-- add the exsl namespace to master xml defintion: xmlns:exslt="http://exslt.org/common" -->
<!-- be sure that at least the var definition is found. at master:
 
 <xsl:variable name="javascripts">
		</xsl:variable>

at any other page: -->
<!-- 
<xsl:variable name="javascripts">
	<js>
	<xsl:value-of select="concat($workspace, '/')" />
	<xsl:text>filename</xsl:text> 
	</js> 
<js> next file </js>
</xsl:variable>

-->
<!-- and call the tempalte in head section: -->
<!--
<xsl:call-template name="js" />
-->

<!"-- this is the template -->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exslt="http://exslt.org/common"
>
<!-- this is the template -->

<xsl:template name="js">
<xsl:for-each select="exslt:node-set($javascripts)/js">
<script type="text/javascript" >
<xsl:attribute name="src">
<xsl:value-of select="text()" /></xsl:attribute> 
</script>
</xsl:for-each>
</xsl:template> 


