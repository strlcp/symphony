<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!-- is a plugin for the great:

http://www.getsymphony.com/download/xslt-utilities/view/35067/

-->

<!-- install:


So the first step is to made a static XML(param-navigation), where each page is listed you want to navigate through:

<articles>
<ext-nav-categories>
<ext-nav-subcategories>
</ext-nav-subcategories>
</ext-nav-categories>
</articles>

for example.

The second step is to generate the ext-nav-datasources as unchained sources, distributing the name and the link field.

third is to put all ext-nav-sources in a uniondatasource called ext-navi.

and last step is to add xslt.


-->

<!-- add this to navigation: -->
<!-- direct after:

<a href="{$path}/{@handle}/">
<xsl:value-of select="name"/>
</a>
in
http://www.getsymphony.com/download/xslt-utilities/view/35067/


<xsl:apply-templates select="/data/param-navigation">
<xsl:with-param name="page" select="@handle" />
<xsl:with-param name="path" select="$path" />
</xsl:apply-templates>
-->



<!-- and this are the tempaltes: -->

<xsl:template match="/data/param-navigation">
<xsl:param name="page" />
<xsl:param name="path" />
<!-- checking if page is listed in xml -->
<xsl:for-each select="*">
<xsl:if test="name() = $page">
<xsl:variable name="sub" select="." />
<ul>
<!-- applay tempaltze for union datasource -->
<xsl:apply-templates select="/data/ext-navi/entry">
<xsl:with-param name="sub" select="$sub/*[1]" />
<xsl:with-param name="path" select="concat($path, '/', $page)" />
<!-- using 'x' as initional id value -->
<xsl:with-param name="id" select="'x'" />
</xsl:apply-templates>
</ul>
</xsl:if>
</xsl:for-each>
</xsl:template>


<!-- running union datasource -->
<xsl:template match="/data/ext-navi/entry">
<xsl:param name="path" />
<xsl:param name="sub" />
<xsl:param name="id" />

<!-- test if related to static xml nodename ? -->
<xsl:if test="@section-handle = name($sub)" >
<xsl:variable name="page" >
<xsl:value-of select="name/@handle" />
</xsl:variable>

<xsl:if test="*/item/@id = $id or $id = 'x'">

<!-- checink for filtering entry  - needed for aktive -->
<xsl:variable name="queryactive">
	<xsl:value-of select="//data/params/*[name() = $sub/@name]" />
</xsl:variable>

<!-- printing the link -->
<li>
<xsl:if test="$queryactive = $page">
<xsl:attribute name="class">activeparent</xsl:attribute>
</xsl:if> 
   <a href="{$path}/{$page}">
        <xsl:value-of select="$page"/>
      </a>
<!-- testing for next value in xml -->
<xsl:if test="$sub/*[1]">
<ul>
<!-- calling self -->
<xsl:apply-templates select="/data/ext-navi/entry">
<xsl:with-param name="id" select="@id" />
<xsl:with-param name="sub" select="$sub/*[1]"/>
<xsl:with-param name="path" select="concat($path,'/',$page)" />
</xsl:apply-templates>
</ul>
</xsl:if>
</li>
</xsl:if>
</xsl:if>

</xsl:template>
</xsl:stylesheet>


