<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!-- archive navigation -->

<!-- checking 
<all>              pages
  <exponate>       group filled in 
  <expo>           datasource
   <date arg="iso" precision="month" />    child with definitions
  </expo> 
  </exponate>
  <austellungen> 
  <exhi>
    <begin arg="iso" precision="month" />
    <end arg="iso" precision="month" />
  </exhi>
  <exhi>
    <vernissage arg="iso" precision="day" />
    <finnissage arg="iso" prcision="day" /> 
  </exhi>
  </austellungen>
</all>



-->
<xsl:template name="archiveNavigation"> 

<!-- checking all may pages will be made later -->
  <xsl:for-each select="//data/archive-navigation/all/*">
  
  <li>
    <xsl:value-of select="name()" />
   <ul>
 
  <xsl:for-each select="./*" >   
    <xsl:choose>
      <xsl:when test="not(./*[2])">
        <li>	

        </li>  
	  <xsl:call-template name="aNavLoop">
	    <xsl:with-param name="node" select="name()" /> 
	    <xsl:with-param name="nde" select="." /> 
	    <xsl:with-param name="no" select="2" />
	  </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<li>
	  <xsl:value-of select="name(./*[2])" />
        </li>
      </xsl:otherwise>
         
    </xsl:choose>
  </xsl:for-each>

  
  </ul>
 </li> 
  
  </xsl:for-each>

</xsl:template>




<!-- the real thing -->

<xsl:template name="aNavLoop">
  <xsl:param name="no" />
  <xsl:param name="node" />

  
  <xsl:param name="nde" />
   <xsl:apply-templates select="//data/*[name() =$node]" mode="aNavLoop">
   <xsl:with-param name="no" select="$no" />
   <xsl:with-param name="vgl" select="''" /> 
   <xsl:with-param name="nde" select="$nde" /> 
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="*" mode="aNavLoop" >
  <xsl:param  name="no" />
  <xsl:param name="vgl" />
   
  <xsl:param name="nde" />

   <xsl:apply-templates select="./entry/../*[$no]" mode="archives">
    <xsl:with-param name="vgl" select="$vgl" />
    <xsl:with-param name="no" select="$no" /> 
    <xsl:with-param name="nde" select="$nde" /> 
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="entry" mode="archives">
 <xsl:param  name="vgl" />
 <xsl:param  name="no" />

 <xsl:param name="nde" />

 <!-- if @arg is not iso or not deffined in static xml -->
  <xsl:variable name="arg">
   <xsl:choose>
    <xsl:when test="$nde/*[1]/@arg">
      <xsl:value-of select="$nde/*[1]/@arg" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'iso'" />
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
<!-- setting format given in precision -->
  <xsl:variable name="format">
      <xsl:choose>
	  <xsl:when test="$nde/*[1]/@precision = 'year'" > 
	   <xsl:value-of select="'Y/'" />
          </xsl:when>
	  <xsl:when test="$nde/*[1]/@precision = 'month'" > 
	       <xsl:value-of select="'Y/n/'" />
          </xsl:when>
	  <xsl:otherwise>
	      <xsl:value-of  select="'Y/n/d/'" />
	  </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>    
 <!-- getting hit with the date-time xsl -->
  <xsl:variable name="list">
     <xsl:call-template name="format-date">
	<xsl:with-param name="date" select="./*[name() = name($nde/*[1])]/@*[name() = $arg]" />
	<xsl:with-param name="format" select="$format" />
     </xsl:call-template>
  </xsl:variable>

  <!-- testing if changed-->
  <xsl:if test="$list != $vgl">
  
 <!-- testing for each part the diff -->
    <xsl:call-template name="aNavLoopDiff">
      <xsl:with-param name="list" select="normalize-space($list)" />
      <xsl:with-param name="string" select="normalize-space($list)" />
      <xsl:with-param name="compare" select="normalize-space($vgl)"/>
      <xsl:with-param name="delimiter" select="'/'" />
    </xsl:call-template>
 
  </xsl:if>
<!-- calling next entry -->
   <xsl:apply-templates select=".." mode="aNavLoop" >
    <xsl:with-param name="no" select="$no + 1" /> 
    <xsl:with-param name="vgl" select="$list" />
     
    <xsl:with-param name="nde" select="$nde" /> 
  </xsl:apply-templates>
 </xsl:template>

<!-- diffing  --> 
 
 <xsl:template name="aNavLoopDiff">
  <xsl:param name="list" />
  <xsl:param name="compare" />
  <xsl:param name="delimiter" />
  <xsl:param name="string" />

 
  <xsl:if test="contains($list, $delimiter)"> 
   
    <xsl:variable name="vgl">
	<xsl:value-of select="substring-before($list, $delimiter)" />
     </xsl:variable>
     <xsl:variable name="rest">
	<xsl:value-of select="substring-after($list, $delimiter)" />
     </xsl:variable>
     <xsl:variable name="vglComp">
	<xsl:value-of select="substring-before($compare, $delimiter)" />
     </xsl:variable>
     <xsl:variable name="restComp">
	<xsl:value-of select="substring-after($compare, $delimiter)" />
     </xsl:variable>

   
    <xsl:choose> 
      <xsl:when test="$vglComp = $vgl">

      <xsl:call-template name="aNavLoopDiff">
	<xsl:with-param name="list"  select="$rest" />
	<xsl:with-param name="string" select="$string" />
	<xsl:with-param name="compare" > <xsl:value-of select="$restComp" /> </xsl:with-param>
	<xsl:with-param name="delimiter" select="$delimiter" />
      </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
  
	<xsl:call-template name="aNavLoopPrint" >
	  <xsl:with-param name="list"  select="$rest" />
	  <xsl:with-param name="string" select="$string" />
	  <xsl:with-param name="delimiter" select="$delimiter" />
	</xsl:call-template>
	<!--<xsl:value-of select="$list" /> -->
  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  
 </xsl:template>

 <!-- and print -->
 
 <xsl:template name="aNavLoopPrint" >
  <xsl:param name="list" />
  <xsl:param name="string" />
  <xsl:param name="delimiter" />
 <!-- may loop -->
     <xsl:variable name="part"> 
	<xsl:choose>
	  <xsl:when test="contains($list, $delimiter )">
	    <xsl:value-of select="substring-before($string, $list)" />
	  </xsl:when>
	  <xsl:otherwise>
	    
	  </xsl:otherwise>
	 </xsl:choose> 
     </xsl:variable> 
    
    <xsl:if test="not($part)" >
      <xsl:variable name="part" select="$list" />
    </xsl:if>
    <xsl:value-of select="$list" />  
    
     <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="concat($root, '/archive/', $part)" /> 
	</xsl:attribute>
	<xsl:value-of select="$part" />
     </a>
  
      <xsl:if test="contains($list, $delimiter)">
      
 	<xsl:call-template name="aNavLoopPrint" >
	  <xsl:with-param name="list"  select="substring-after($list, $delimiter)" />
	  <xsl:with-param name="string" select="$string" />
	  <xsl:with-param name="delimiter" select="$delimiter" />
	</xsl:call-template>
 
 
      </xsl:if>
   
  </xsl:template>
 
  
</xsl:stylesheet>
