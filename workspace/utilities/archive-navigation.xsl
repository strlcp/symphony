<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="exsl" >


<!-- archive navigation -->

<!-- date time utility:
  http://www.getsymphony.com/download/xslt-utilities/view/20506/
  wich is part of default wortkspace is needed
  -->

<!-- 


checking  a sample static xml named  archive-navigation

<all>              pages
  <exponate>       group filled in 
  <expo>           datasource
   <date arg="iso" precision="day" />    child with definitions
  </expo> 
  </exponate>
  <austellungen> 
  <exhi>
    <begin arg="iso" precision="month" />
  </exhi>
  </austellungen>
</all>



-->
<xsl:template name="archiveNavigation"> 
<ul>
<!-- checking all may pages will be made later -->
  <xsl:for-each select="//data/archive-navigation/all/*">
  
<!-- @title if set -->
 <li> 
    <xsl:value-of select="name()" /> 
 </li>
  <ul>
 <xsl:variable name="out"> 
  <records>
    <!-- else may create ul -->
  <xsl:for-each select="./*" >   
    <xsl:choose>
      <xsl:when test="not(./*[2])">
	
	  <xsl:call-template name="aNavLoop">
	    <xsl:with-param name="node" select="name()" /> 
	    <xsl:with-param name="nde" select="." /> 
	    <xsl:with-param name="no" select="2" />
	  </xsl:call-template>
	 
      </xsl:when>
      <xsl:otherwise>
      
	<!-- the span thing -->
	  <xsl:value-of select="name(./*[2])" /> 
        
      </xsl:otherwise>
         
    </xsl:choose>
  </xsl:for-each>
  </records>
 </xsl:variable> 
 
   <xsl:call-template name="aNavLoopPrintTags">
	<xsl:with-param name="out" select="$out" />
  </xsl:call-template>

  </ul>
  
  </xsl:for-each>
</ul>
</xsl:template>



<!-- template prints its all -->
 
  <xsl:template name="aNavLoopPrintTags">
    <xsl:param name="out" />
  
   	<!-- 
	  must be more flexible $root/archive can't reflect: 
	      events/this_is_the_motto/lineup_artist_timeline
	will do print above only need pos posAc $part and thats ist -> item !!!
	
	-->  
    <xsl:apply-templates select="exsl:node-set($out)/records" mode="aNavPrintYear" />
  
    
  
</xsl:template>




<!-- the real thing -->

<xsl:template name="aNavLoop">
  <xsl:param name="no" />
  <xsl:param name="node" />
  <xsl:param name="prt" />
  
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
 <xsl:param name="prt" />
 <xsl:param name="nde" />

 <!-- if @arg is not iso or not deffined in static xml - may not here -->
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
          <xsl:when test="$nde/*[1]/@precision = 'day'" > 
	       <xsl:value-of  select="'Y/n/d/'" />
          </xsl:when>
          <!-- need hour and minute -->
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
  <xsl:variable name="out">
 <!-- testing for each part the diff -->
    <timestamp>
    <xsl:call-template name="aNavLoopDiff">
       <xsl:with-param name="pos"  select="0" />
      <xsl:with-param name="list" select="normalize-space($list)" />
      <xsl:with-param name="string" select="normalize-space($list)" />
      <xsl:with-param name="compare" select="normalize-space($vgl)"/>
      <xsl:with-param name="delimiter" select="'/'" />
    </xsl:call-template>
   </timestamp> 
  </xsl:variable>
  
  <xsl:apply-templates select="exsl:node-set($out)/timestamp"  mode="aNavItem" />

  </xsl:if>
  

<!-- calling next entry -->
   <xsl:apply-templates select=".." mode="aNavLoop" >
    <xsl:with-param name="no" select="$no + 1" /> 
    <xsl:with-param name="vgl" select="$list" />
     <xsl:with-param name="nde" select="$nde" /> 
   </xsl:apply-templates>
 
 </xsl:template>

 
 <xsl:template match="timestamp" mode="aNavItem" > 
  <item>
   <xsl:if test="year"> 
    <xsl:attribute name="year">
     <xsl:value-of select="year" />
    </xsl:attribute>
   </xsl:if> 
      <xsl:if test="month"> 
    <xsl:attribute name="month">
     <xsl:value-of select="month" />
    </xsl:attribute>
   </xsl:if>
    <xsl:if test="day"> 
    <xsl:attribute name="day">
     <xsl:value-of select="day" />
    </xsl:attribute>
   </xsl:if> 
   </item>  
 </xsl:template>
  
 
<!-- diffing  --> 

 <xsl:template name="aNavLoopDiff">
  <xsl:param name="list" />
  <xsl:param name="compare" />
  <xsl:param name="delimiter" />
  <xsl:param name="string" />
  <xsl:param name="pos" />
  <xsl:param name="depth" />
 
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
      <xsl:when test="$pos = 0">
	<year><xsl:value-of select="$vgl" /></year>  
      </xsl:when>
      <xsl:when test="$pos = 1">
	<month><xsl:value-of select="$vgl" /></month>  
      </xsl:when>
       <xsl:when test="$pos = 2">
	<day><xsl:value-of select="$vgl" /></day>  
      </xsl:when>
     </xsl:choose>
     
      <xsl:call-template name="aNavLoopDiff">
	<xsl:with-param name="depth"  select="$depth" />
	<xsl:with-param name="pos"  select="$pos +1" />
	<xsl:with-param name="list"  select="$rest" />
	<xsl:with-param name="string" select="$string" />
	<xsl:with-param name="compare" > <xsl:value-of select="$restComp" /> </xsl:with-param>
	<xsl:with-param name="delimiter" select="$delimiter" />
      </xsl:call-template>
 

  </xsl:if>
  
 </xsl:template>


<!-- all print a´out -->
 
     <xsl:key name="timestamp-year" match="item" use="@year" />
     <xsl:key name="timestamp-month" match="item" use="concat(@year, ',', @month)" /> 
     <xsl:key name="timestamp-day" match="item" use="concat(@year, ',', @month, ',', @day)" />   

 
     <xsl:template match="records" mode="aNavPrintDay">
      <xsl:param name="year" />
      <xsl:param name="month" /> 
      
    	 <xsl:for-each select="item[count(. | key('timestamp-day', concat(@year, ',', @month, ',', @day))[1]) = 1 and @year = $year and @month = $month]"> 
	    <li>
	      <a>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat($root, '/archive/', @year, '/', @month, '/', @day)" />
	      </xsl:attribute>
		<xsl:value-of select="@day" />
	      </a>
	    </li>
	 </xsl:for-each>
      </xsl:template>
     
      <xsl:template match="records" mode="aNavPrintMonth">
      <xsl:param name="year" />
       	 <xsl:for-each select="item[count(. | key('timestamp-month', concat(@year, ',', @month))[1]) = 1 and @year = $year]"> 
	    <li>
	      <a>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat($root, '/archive/', @year, '/', @month)" />
	      </xsl:attribute>
	     <xsl:value-of select="@month" />
	    </a>
	    </li>
	 <xsl:if test="@day">   
	    <li>
	    <ul>
	      <xsl:apply-templates select="../../records"  mode="aNavPrintDay" >
		<xsl:with-param name="year" select="$year" />
		<xsl:with-param name="month" select="@month" />
	      </xsl:apply-templates>
	     </ul>
	     </li>
	 </xsl:if>    
	 </xsl:for-each>
      </xsl:template>
   
     <xsl:template match="records" mode="aNavPrintYear">
           <xsl:for-each select="item[count(. | key('timestamp-year', @year)[1]) = 1]"> 
	    <li>
	    <a>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat($root, '/archive/', @year)" />
	      </xsl:attribute>
	     <xsl:value-of select="@year" />
	    </a>
            </li>
	<li>
	<ul> 
	<xsl:apply-templates select="../../records"  mode="aNavPrintMonth" >
	  <xsl:with-param name="year" select="@year" />
	</xsl:apply-templates>
       </ul>
	</li>
  </xsl:for-each>
</xsl:template>
 
    

</xsl:stylesheet>
