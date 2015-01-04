<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="exsl"

>


<!-- prtpic needs node and max relation is opt. --> 
<xsl:template name="picture" >
<!-- args -->
  <xsl:param name="node" />
  <xsl:param name="size" />

 <!-- <xsl:value-of select="name($node)" />-->
  
  <xsl:variable name="file">
    <xsl:value-of select="$node/image/filename" />
  </xsl:variable>
  
  <xsl:variable name="path">
    <xsl:value-of select="$node/image/@path" />
  </xsl:variable>
  
  <img>
    <xsl:attribute name="src">
      <xsl:value-of select="concat($root, '/image/1/')" /> 
      	<xsl:choose>
	  <xsl:when test="$size">
	     <xsl:value-of select="$size"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="'150'"/>
	  </xsl:otherwise>
	</xsl:choose>
      <xsl:value-of select="concat('/0', $node/image/@path, '/',  $node/image/filename)" />
    </xsl:attribute>
  </img>
 
</xsl:template>





<!-- must call js and nojs seperate to get clean code  :-( -->
<!--	      
 <noscript>
  <div class="ansicht w-50 nojs">
     <a>
      <xsl:attribute name="href">
	<xsl:value-of select="concat($root, '/exponate/', workpiece/item/@handle)" />
    </xsl:attribute>
      <xsl:call-template name="picture" >
        <xsl:with-param name="node" select ="current()" />
        <xsl:with-param name="size" select="'50'" />
      </xsl:call-template>
     </a> 
    </div>
  </noscript>
 
-->  

<!-- calling -->
<!--
       <noscript>
      <xsl:copy-of select="exsl:node-set($bufferChronologie)/noscript/*" /> 
      </noscript>
      
 -->
 
 <!--     use path/urlBase/jit or resp {} or plain -->
 
 
  <!--  only picture model is needed  --> 
 <xsl:template name="pictureWrapperModel">

  <xsl:param name="link" />
  <xsl:param name="called" />
<!--    <xsl:copy-of select="link" /> -->
   <xsl:param name="resp" /> 
<!--   <xsl:copy-of select="$node/*[*]/*[1]" /> -->

<!--   <xsl:copy-of select="$node" /> -->
  
<xsl:text>({resp: </xsl:text><xsl:value-of select="$resp" /><xsl:text>,
	  </xsl:text>
	  <xsl:if test="$link">
	  <xsl:text>link: '</xsl:text><xsl:value-of disable-output-escaping="yes" select="$link" /><xsl:text>',
     </xsl:text>
    </xsl:if>
    <xsl:text>called: '</xsl:text><xsl:value-of disable-output-escaping="yes" select="$called" /><xsl:text>',</xsl:text>        
    <xsl:text>alt: 'loading'</xsl:text>
    <xsl:text>});</xsl:text> 
</xsl:template> 
  
<!--  
 <script>
  <xsl:call-template name="pictureWrapperModel">
    <xsl:with-param name="called" select="current/name/text()" />
    <xsl:with-param name="link" select="concat($root, '/exponate/', workpiece/item/@handle)" />
       
       
       <xsl:with-param name="resp">
    	  <xsl:text>{
	      path: '</xsl:text>   
	      <xsl:value-of select="concat($node/*[name() = $hive]/@path, '/', $node/*[name() = $hive]/filename)" />
	      <xsl:text>', 
	      urlBase: '</xsl:text>
	      <xsl:value-of select="$root" />  
	      <xsl:text>',
	      jit: '/image/1/80/0'	
	     }</xsl:text>
    </xsl:with-param>
    
    or use like etsy wants:
    
    
    <xsl:with-param name="resp">
    	  <xsl:text>{
		    75: '</xsl:text><xsl:value-of select="images/item[1]/url-75x75/text()" /><xsl:text>',
		    170: '</xsl:text><xsl:value-of select="images/item[1]/url-170x135/text()" /><xsl:text>',
		    570: '</xsl:text><xsl:value-of select="images/item[1]/url-570xn/text()" /><xsl:text>'}</xsl:text>
    </xsl:with-param>
    
    
   </xsl:call-template>
 </script>


-->

<!-- resp could be object(using the jit engine / or not jit )/  string (is not resp) -->

<!--
call the list something like
-->
<!--
    <script type="text/javascript"><xsl:text>
    require( ['lib/collection/simpleImage', 'lib/view/simpleImageList'], function( collection, list) {
	var sample = new collection();
     </xsl:text>
           <xsl:for-each select="exsl:node-set($buffer)/script" >
	 <xsl:text>sample.add</xsl:text>	
	      <xsl:value-of select="." />
	 <xsl:text>
	 </xsl:text>    
         </xsl:for-each>
	
	<xsl:text disable-output-escaping="yes">  
        var Collview = new list({collection: sample, el: '#container', layout: {
	
	masonry: {
	  "gutter": 20,
	  "columnWidth": 300, 
	  "itemSelector": ".msy"
	  }
	
	 },
	childopts:{
	tpl:'&lt;div&gt;\
	&lt;a href={{ link }}&gt;\
	&lt;img alt={{ alt }}  src={{ urlBase }}{{ jit }}{{ path }}  /&gt;\
	&lt;/a&gt;\
	&lt;p&gt; {{ called }} &lt;/p&gt;\
	&lt;/div&gt;',
	class: 'small-6 medium-4 large-3 columns msy',
	fit: true
	}
      });
  
  });
  
  
      </xsl:text></script> 
      
-->


<!--  depricated -->


<xsl:template name="pictureWrapper">
  <xsl:param name="node" />
  <xsl:param name="size" />
  <xsl:param name="element" />
  <xsl:param name="parent" />
  <xsl:param name="class" />
  <xsl:param name="link" /> 
  <xsl:param name="tpl" /> 
   <script type="text/javascript">
     <xsl:text>
    require( ['lib/pic'],  function( pic) {
        try{ 
	    var picstick = new pic.Model ({path: '</xsl:text>   
    <xsl:value-of select="concat($node/image/@path, '/', $node/image/filename)" />
    <xsl:text>', 
	  urlBase: '</xsl:text>
    <xsl:value-of select="$root" />  
    <xsl:text>',</xsl:text>
     <xsl:if test="$link">
       <xsl:text>link: '</xsl:text><xsl:value-of disable-output-escaping="yes" select="$link" /><xsl:text>',
     </xsl:text>
    </xsl:if><xsl:text>
	  alt: 'loading',
	 jit: '/image/1/50/0</xsl:text>	
    <xsl:text>'});
      var picV = new pic.View({
      </xsl:text>
      <xsl:if test="$tpl">
	<xsl:text>tplStr: '</xsl:text><xsl:value-of disable-output-escaping="yes" select="$tpl" /><xsl:text>',
	</xsl:text>
      </xsl:if>
      <xsl:text>
	 model: picstick, 
	  fit: true,
	  class: '</xsl:text>
       <xsl:value-of select="$class" />  
      <xsl:text>'
      });
      picV.render();
      }catch(e){console.debug(e);}
      </xsl:text>
      <xsl:if test="$parent">
      <xsl:text>var msry = $('</xsl:text>
	<xsl:value-of select="$parent" />
	<xsl:text>').data('masonry');
	if (msry) {
		msry.appended(picV.el);   
	}
	</xsl:text>
<!--       here testing for parent selector, if parent type of masonry  etc pp -->
      
	<xsl:text>$('</xsl:text>
	<xsl:value-of select="$parent" />
	<xsl:text>').append(picV.el);
	});</xsl:text>
      </xsl:if>
    <xsl:text></xsl:text>
    </script>



</xsl:template>

</xsl:stylesheet>
