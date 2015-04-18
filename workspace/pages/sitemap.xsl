<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../utilities/sitemap.xsl" />	
	
	
  <xsl:variable name="webroot" select="$root" /> 	
	
	  
  <!--  times defs -->	

 <xsl:output method="xml" encoding="UTF-8" />
  


<xsl:template match="/data">
  <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
   <url>
    <loc>
      <xsl:value-of select="$webroot" />
      
    </loc>
   </url>

   <xsl:apply-templates select="navigation/page[not(types/type = 'admin')]" mode="sitemap">
    <xsl:with-param name="path" select="$webroot" />

    </xsl:apply-templates>
</urlset>
	
</xsl:template>

</xsl:stylesheet>
