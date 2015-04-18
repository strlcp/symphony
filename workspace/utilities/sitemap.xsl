<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  
  xmlns:date="http://exslt.org/dates-and-times"
  extension-element-prefixes="date"
>

<xsl:key name="remoteLoc" match="url" use="loc"/> 


<!-- using all pages not admin -->

<xsl:template match="page" mode="sitemap">
 <xsl:param name="path" />
 <xsl:variable name="handle"  select="@handle" />
  
  
  
  <xsl:if test="not(types/type = 'hidden') or /data/param-sitemap/*[name() = $handle]" >
  
  <url>
    <loc>
      <xsl:value-of select="concat($path , $handle)" />
    </loc>
    
  </url>

   <xsl:if test="count(*[name() = 'page']) &gt; 0" >
      <xsl:apply-templates select="page[not(types/type = 'admin')]" mode="sitemap">
	  <xsl:with-param name="path" select="concat($path, $handle, '/')" />
      </xsl:apply-templates> 
   </xsl:if>
  
 <xsl:variable name="buffer" > 
      <xsl:for-each select="/data/param-sitemap/*[name() = $handle]/*" >
      <xsl:apply-templates select="." mode="sitemap">
	<xsl:with-param name="handle" select="$handle" /> 
    	<xsl:with-param name="path" select="concat($path, $handle, '/')" />
    	<xsl:with-param name="sub" select="." />
      </xsl:apply-templates>
    </xsl:for-each> 
 </xsl:variable>  
 
 
<!--    <xsl:copy-of select="exslt:node-set($buffer)" />   -->
   <xsl:for-each select="exslt:node-set($buffer)/url[generate-id() = generate-id(key('remoteLoc', loc))]" >
     <xsl:copy-of select="." />  
  </xsl:for-each>
<!--  make it unique   -->
 
 </xsl:if> 
  
</xsl:template>



  

<xsl:template match="*" mode="sitemap">
    
  <xsl:param name="sub" />   
  <xsl:param name="path" />
  <xsl:variable name="hive" select="name()" />


   <xsl:choose>
   <xsl:when test="/data/*[name() = $hive]/entry">
   
  <xsl:apply-templates select="/data/*[name() = $hive]/entry"  mode="sitemapEntry">
    <xsl:with-param name="sub" select="$sub" />
     <xsl:with-param name="path" select="$path"/>
     <xsl:with-param name="hive" select="$hive"/>
  </xsl:apply-templates>
 </xsl:when>

 <xsl:when test="/data/*[name() = $hive]/data/results/item">
 
    <xsl:apply-templates select="/data/*[name() = $hive]/data/results/item"  mode="sitemapEntry">
    <xsl:with-param name="sub" select="$sub" />
     <xsl:with-param name="path" select="$path"/>
  </xsl:apply-templates>
 
 
 </xsl:when>
 </xsl:choose>
 
</xsl:template>


<xsl:template match="*" mode="sitemapEntry" >
 

   <xsl:param name="sub" />
   <xsl:param name="path" />
   
   
    <xsl:variable name="inherit" select="$sub/@*[name() = 'inherit']" /> 
    <xsl:variable name="child"   select="$sub/@*[name() = 'child']" /> 
    
    <xsl:variable name="id" select="@id" />
   
   <!-- all for etsy -->
   <xsl:variable name="handle"  >
    <xsl:if test="$sub/@*[name() = 'add']">
      <xsl:value-of select="concat($sub/@*[name() = 'add'], '/')" />
    </xsl:if>
    <xsl:choose>
     <xsl:when test="$child = 'name'">
          <xsl:value-of select="*[name() = $child]/@handle" />
     </xsl:when>
     <xsl:otherwise>
<!--      using for etsy  -->
     <xsl:choose> 
     <xsl:when test="$sub/@*[name() = 'descendant']" >
	<xsl:variable name="descendant" select="$sub/@*[name() = 'descendant']" />
	<xsl:variable name="buffer" select="*[name() = $child]/*[name() = $descendant]" />
 	<xsl:value-of select="translate(translate($buffer, ' ', '+'), '%', '|')" /> 
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="*[name() = $child]" />
      </xsl:otherwise>
      </xsl:choose>
     </xsl:otherwise>
    </xsl:choose> 
   </xsl:variable>
   
   

  
   <xsl:variable name="date">  
    <xsl:choose>
      <xsl:when test="system-date/modified/text()">
	<xsl:value-of  select="system-date/modified/text()" />
      </xsl:when>
      <xsl:when test="$sub/@*[name() = 'time'] = 'unixstamp'">
	<xsl:variable name="modified" select="$sub/@*[name() = 'modified']" />
	<xsl:variable name="stamp" select="*[name() = $modified]" />
	<xsl:value-of select="substring(date:add('1970-01-01T00:00:00Z', date:duration($stamp)), 0, 11)" />
      </xsl:when>
    </xsl:choose>
   </xsl:variable> 

   <url>
   
    <loc>
      <xsl:value-of select="concat($path, $handle)" />
    </loc>
    <lastmod>
      <xsl:value-of select="$date" />
    </lastmod>
    <changefreq>weekly</changefreq>
    
  </url>
 
   <xsl:choose>

    <xsl:when test="$sub/*[1]"> 
    
     <xsl:variable name="tmp">
	<xsl:value-of select="name($sub/*[1])" />
      </xsl:variable>
    
     <xsl:apply-templates select="/data/*[name() = $tmp]/entry/*/item[@id = $id]/../.." mode="sitemapEntry">
       <xsl:with-param name="sub" select="$sub/*[1]" />
       <xsl:with-param name="path" select="concat($path, $handle, '/')"/>
     </xsl:apply-templates>
    
   </xsl:when>
   
  </xsl:choose>

  
</xsl:template>

</xsl:stylesheet> 
