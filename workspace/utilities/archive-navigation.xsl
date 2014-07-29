<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="exsl" >

   

<!-- archive navigation -->


<!-- 


checking  a sample static xml named  archive-navigation

<all>  
<exponate limit="3"> 
  <expo> 
   <date arg="iso" precision="month" />
  </expo>
 </exponate>  
  <austellungen limit="4"> 
  <exhi type="date-times">
    <date  arg="iso" precision="month" out="title"/>
   </exhi>
  </austellungen>
</all>

-->

<!--      <xsl:key name="entryId" match="entry" use="@id" /> -->
     <xsl:key name="entryTimeline" match="entry" use="concat(@id, ',', @timeline)" /> 


<xsl:template name="archiveNavigation"> 

<xsl:variable name="debug">
  <xsl:value-of select="'off'" />
</xsl:variable>


<nav>
<ul class="header menu right">
<!-- checking all may pages will be made later -->
  <xsl:for-each select="//data/archive-navigation/all/*">
  
<!-- @title if set -->
 <li>
 
<!--     <p><xsl:value-of select="name()" /> </p> -->

  <ul>
  

 
 <xsl:variable name="out"> 
  <records>
    <!-- else may create ul -->
  <xsl:for-each select="./*" >   
    <xsl:choose>
    
 <!-- more complexy rule with child deffinitions -->
      <xsl:when test="./*[1]/*[1]">
   
<!--     <xsl:copy-of select="(./*[1])" /> -->
   
      </xsl:when>
  <!-- normale timeline --> 
  
 <!--  -->
      <xsl:when test="not(./*[2])">
<!--        <xsl:if test="$type = 'date'" > -->
	  <xsl:call-template name="archiveNavigationLoop">

	  </xsl:call-template>

      </xsl:when>
      <xsl:otherwise>
      
 <!-- more entries -->	  
	  
<!-- 	  <xsl:copy-of select="." /> -->
	  
<!-- 	  <xsl:call-template name="archiveNavigationRangeLoop"></xsl:call-template> -->
	<!-- the span thing -->
<!-- 	  <xsl:value-of select="name(./*[2])" />   -->
        
      </xsl:otherwise>
         
    </xsl:choose>
  </xsl:for-each>
  </records>
 </xsl:variable> 
 
 <xsl:if test="$debug = 'on'">
    <xsl:copy-of select="$out" /> 
 </xsl:if>
 
 <xsl:if test="@out">
  
 
 </xsl:if>
 
 <!-- generating output -->
 
  <xsl:apply-templates select="exsl:node-set($out)/records" mode="aNavPrintYear" > 
    <xsl:with-param name="limit" select="@limit" />
    <xsl:with-param name="out" select="@out" /> 
  </xsl:apply-templates>
 
 
   </ul>
  </li>
  </xsl:for-each>
</ul>
</nav>
</xsl:template>





<!-- the real thing  fetching node with given name-->

<xsl:template name="archiveNavigationLoop">


 <xsl:variable name="type">
   <xsl:choose>
    <xsl:when test="@type">
      <xsl:value-of select="@type" />  
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'date'" />
     </xsl:otherwise>
   </xsl:choose>
 </xsl:variable>

 
 <!-- need title -->

 <xsl:variable name="precision" select="./*[1]/@precision" />
 <xsl:variable name="section" select="name()" />
 <xsl:variable name="name" select="name(./*[1])" />
 <!-- test if no arg is set -->
   <xsl:variable name="arg">
   <xsl:choose>
  <!-- date filed must be used here !! -->
    <xsl:when test="./*[1]/@arg">
      <xsl:value-of select="./*[1]/@arg" />
     </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'iso'" />
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
 

 <xsl:choose>
  <xsl:when test="$type = 'date'">
   <xsl:apply-templates select="//data/*[name() = $section]/entry/*[name() = $name]"  mode="archiveNavigationEntriesWrapper">
      <xsl:with-param name="arg" select="$arg" />
      <xsl:with-param name="precision" select="$precision" />
      <xsl:with-param name="name" select="$name" />
   </xsl:apply-templates>
  </xsl:when>

  <xsl:when test="$type = 'date-times'">  
  <xsl:call-template name="dateTime">
      <xsl:with-param name="arg" select="$arg" />
  </xsl:call-template>
  </xsl:when>
</xsl:choose>  
</xsl:template>



<xsl:template name="dateTime">
      <xsl:param name="arg"  />
   <!-- is always iso at datetime -->
      <xsl:variable name="precision" select="./*[1]/@precision" />
      <xsl:variable name="section" select="name()" />
      <xsl:variable name="name" select="name(./*[1])" />
    
   <xsl:variable name="out">
     <xsl:apply-templates select="//data/*[name() = $section]/entry/*[name() = $name]/date[@type = 'exact']/start"  mode="archiveNavigationEntriesWrapper">
      <xsl:with-param name="arg" select="$arg" />
      <xsl:with-param name="precision" select="$precision" />
      <xsl:with-param name="name" select="$name" />
    </xsl:apply-templates>

    <xsl:apply-templates select="//data/*[name() = $section]/entry/*[name() = $name]/date[@type = 'range']/*[name() = 'start'  or  name() = 'end']"  mode="archiveNavigationEntriesWrapper">
      <xsl:with-param name="arg" select="$arg" />
      <xsl:with-param name="precision" select="$precision" />
      <xsl:with-param name="name" select="$name" />
   </xsl:apply-templates>
  
  </xsl:variable>
  
 <xsl:apply-templates select="exsl:node-set($out)/entry[generate-id(.) = generate-id(key('entryTimeline', concat(@id, ',' ,@timeline)))]" mode="archiveNavigationTimelineWrapper"/> 
  
</xsl:template>



<xsl:template match="entry" mode="archiveNavigationTimelineWrapper">
  <xsl:variable name="id">
    <xsl:value-of select="@id" />
 </xsl:variable>
 
  <xsl:choose>
 <xsl:when test="@timeline">
  <xsl:variable name="timeline" select="@timeline" />
  <list id="{$id}" timline="{@timeline}" >
    <xsl:apply-templates select="../entry[@id = $id  and @timeline = $timeline]"  mode="archiveNavigationTimelineId"/> 
  </list>			
 </xsl:when>
   <xsl:otherwise>
    <entry id="{$id}">
      <xsl:apply-templates select="../entry[@id = $id]"  mode="archiveNavigationTimelineId"/> 
    </entry>
  </xsl:otherwise> 
 </xsl:choose>
 
</xsl:template>

<!-- after sorting copy item hive -->
<xsl:template match="entry" mode="archiveNavigationTimelineId" >
   <xsl:copy-of select="item" />
<!--  <xsl:apply-templates select="../entry[@id = $id  and @timeline = $timeline]"  mode="archiveNavigationTimelineId"/>  -->
  </xsl:template>


<xsl:template match="*"  mode="archiveNavigationEntriesWrapper">
      <xsl:param name="arg"  />
      <xsl:param name="precision"/>
      <xsl:param name="name" />

   <entry> 
   <!-- id sucks -->
   <xsl:attribute name="title">
      <xsl:value-of select="$name" />
   </xsl:attribute>
    <xsl:attribute name="id">
      <xsl:choose>
	<xsl:when test="../@id">
          <xsl:value-of select="../@id" />
        </xsl:when>
        <xsl:otherwise>
           <xsl:value-of select="../../../@id" />
        </xsl:otherwise>
       </xsl:choose> 
     </xsl:attribute>
    <!-- checking timeline -->   
  <xsl:if test=" ../../date[@type = 'range' and @timeline]">
     <xsl:attribute name="timeline">
      <xsl:value-of select="../@timeline" />
    </xsl:attribute>
  </xsl:if>   
  
  
 <xsl:apply-templates select="." mode="archiveNavigationEntries">
       <xsl:with-param name="arg" select="$arg" />
      <xsl:with-param name="precision" select="$precision" />
 </xsl:apply-templates>
     
    </entry> 

</xsl:template>

<!-- template prints its all -->


<xsl:template match="*"  mode="archiveNavigationEntries">
      <xsl:param name="arg"  />
      <xsl:param name="precision"/>
     
     <xsl:variable name="iso"> 
      <xsl:value-of select="@*[name() = $arg] " />
     </xsl:variable>
    <item>
      <xsl:attribute name="year">
	<xsl:value-of select="substring($iso,1,4)" />
      </xsl:attribute>
      <xsl:if test="not($precision = 'year')" >
	<xsl:attribute name="month">
	  <xsl:value-of select="substring($iso,6,2)" />
	</xsl:attribute>
      <!--
      <xsl:attribute name="week">
	<xsl:value-of select="substring($iso,1,4)" />
	</xsl:attribute>
      -->
	<xsl:if test="not($precision = 'month')" >
	  <xsl:attribute name="day">
	    <xsl:value-of select="substring($iso,9,2)" />
	  </xsl:attribute>
	  <xsl:if test="not($precision = 'day')" >
	    <xsl:attribute name="hour">
	      <xsl:value-of select="substring($iso,12,2)" />
	    </xsl:attribute>
	    <xsl:if test="not($precision = 'hour')" >
	      <xsl:attribute name="minute">
		 <xsl:value-of select="substring($iso,15,2)" />
	      </xsl:attribute>
	    </xsl:if>
	   </xsl:if>
	 </xsl:if>    
      </xsl:if>
    </item>
 </xsl:template>


<!-- all print a´out -->
 
     <xsl:key name="timestamp-year" match="item" use="@year" />
     <xsl:key name="timestamp-month" match="item" use="concat(@year, ',', @month)" /> 
     <xsl:key name="timestamp-day" match="item" use="concat(@year, ',', @month, ',', @day)" />   

 
     <xsl:template match="records" mode="aNavPrintDay">
      <xsl:param name="year" />
      <xsl:param name="month" /> 
      
    	 <xsl:for-each select="*[name() = 'entry' or name() = 'list']/item[count(. | key('timestamp-day', concat(@year, ',', @month, ',', @day))[1]) = 1 and @year = $year and @month = $month]"> 
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
       	 <xsl:for-each select="*[name() = 'entry' or name() = 'list']/item[count(. | key('timestamp-month', concat(@year, ',', @month))[1]) = 1 and @year = $year]"> 
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
	      <xsl:apply-templates select="../../../records"  mode="aNavPrintDay" >
		<xsl:with-param name="year" select="$year" />
		<xsl:with-param name="month" select="@month" />
	      </xsl:apply-templates>
	     </ul>
	     </li>
	 </xsl:if>    
	 </xsl:for-each>
      </xsl:template>
   
     <xsl:template match="records" mode="aNavPrintYear">
	 <xsl:param name="limit" />
	 <xsl:param name="out" />
           <xsl:for-each select="*[name() = 'entry' or name() = 'list']/item[count(. | key('timestamp-year', @year)[1]) = 1]">
           <xsl:choose>
           <xsl:when test="not($limit) or $limit &gt; position()-1">
	    <li>
	    <a>
	      <xsl:attribute name="href">
		<xsl:value-of select="concat($root, '/archive/', @year)" />
	      </xsl:attribute>
	     <xsl:value-of select="@year" />
	    </a>
            </li>
	<xsl:if test="@month"> 
	  <li>
	   <ul> 
	     <xsl:apply-templates select="../../../records"  mode="aNavPrintMonth" >
	      <xsl:with-param name="year" select="@year" />
	    </xsl:apply-templates>
	  </ul>
	 </li>
	</xsl:if>
	</xsl:when>
       </xsl:choose>
  </xsl:for-each>
</xsl:template>
 
    

</xsl:stylesheet>
