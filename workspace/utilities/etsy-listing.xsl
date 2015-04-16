<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="exsl"
>
<!-- running etsy listing on category etc also -->

<!-- changing to one arg only here -->

<xsl:template name="category" mode="etsy">
  <xsl:param name="node" />
   <div id="container" class="js-masonry row" />
     <xsl:variable name="trans" select="translate($type, '+', ' ')" />
     
      <xsl:variable name="buffer">
	 <xsl:apply-templates select="$node/data/results/item/section/title[text() = translate($trans, '|', '%')]/../.." mode="etsy-listing" /> 
      </xsl:variable> 
      <xsl:call-template name="print-etsy-listing">  
	<xsl:with-param name="buffer" select="$buffer" />
      </xsl:call-template>
</xsl:template>

<!-- here  two args needed -->


<xsl:template name="category-path" mode="etsy">
  <xsl:param name="node" />
   <div id="container" class="js-masonry row" />
      <xsl:variable name="buffer">
	 <xsl:apply-templates select="$node/data/results/item/category-path/item[text() = translate($id, '+', ' ')]/../.." mode="etsy-listing" /> 
      </xsl:variable> 
      <xsl:call-template name="print-etsy-listing">  
	<xsl:with-param name="buffer" select="$buffer" />
      </xsl:call-template>
</xsl:template>

<xsl:template name="tags" mode="etsy">
  <xsl:param name="node" />
   <div id="container" class="js-masonry row" />
      <xsl:variable name="buffer">
	  <xsl:apply-templates select="$node/data/results/item/tags/item[text() = translate($id, '+', ' ')]/../.." mode="etsy-listing" />  
      </xsl:variable> 
      <xsl:call-template name="print-etsy-listing">  
	<xsl:with-param name="buffer" select="$buffer" />
      </xsl:call-template>
</xsl:template>

<xsl:template name="style" mode="etsy">
  <xsl:param name="node" />
   <div id="container" class="js-masonry row" />
      <xsl:variable name="buffer">
	   <xsl:apply-templates select="$node/data/results/item/style/item[text() =  translate($id, '+', ' ')]/../.." mode="etsy-listing" />   
      </xsl:variable> 
      <xsl:call-template name="print-etsy-listing">  
	<xsl:with-param name="buffer" select="$buffer" />
      </xsl:call-template>
</xsl:template>

<xsl:template name="materials" mode="etsy">
  <xsl:param name="node" />
   <div id="container" class="js-masonry row" />
      <xsl:variable name="buffer">
	    <xsl:apply-templates select="$node/data/results/item/materials/item[text() =  translate($id, '+', ' ')]/../.." mode="etsy-listing" />   
      </xsl:variable> 
      <xsl:call-template name="print-etsy-listing">  
	<xsl:with-param name="buffer" select="$buffer" />
      </xsl:call-template>
</xsl:template>


<!-- the listing itself -->

<xsl:template match="item" mode="etsy-listing" >

 <noscript>
  <div class="large-3 medium-4 small-6 columns">
     <a>
      <xsl:attribute name="href">
	<xsl:value-of select="concat($root, '/', $root-page, '/', $current-page, '/product/', listing-id)" />
    </xsl:attribute>
      <img src="{images/item[1]/url-170x135/text()}" />
     </a> 
    </div>
  </noscript>


<script>
  <xsl:call-template name="pictureWrapperModel">
    <xsl:with-param name="text" >
      <xsl:text>{called: '</xsl:text><xsl:value-of  select="title/text()" /><xsl:text>',
	price: '</xsl:text><xsl:value-of  select="concat(price/text(), ' ', currency-code/text())" /><xsl:text>'}</xsl:text>
    </xsl:with-param>
      <xsl:with-param name="link" select="concat($root, '/', $root-page, '/', $current-page, '/product/', listing-id)" />
       
       
       <xsl:with-param name="resp">
    	  <xsl:text>{
		    75: '</xsl:text><xsl:value-of select="images/item[1]/url-75x75/text()" /><xsl:text>',
		    170: '</xsl:text><xsl:value-of select="images/item[1]/url-170x135/text()" /><xsl:text>',
		    570: '</xsl:text><xsl:value-of select="images/item[1]/url-570xn/text()" /><xsl:text>'}</xsl:text>
    </xsl:with-param>
   </xsl:call-template>
 </script>

</xsl:template>

<xsl:template name="print-etsy-listing">
  <xsl:param name="buffer" />
	<noscript>
	  <xsl:copy-of select="exsl:node-set($buffer)/noscript/*" />  
	</noscript>
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
	&lt;img alt="{{ text.price }}" src="{{ src }}" /&gt;\
	&lt;/a&gt;\
	&lt;p class="elips"&gt; {{ text.called }} &lt;/p&gt;\
	&lt;p class="text-right price"&gt; {{ text.price }} &lt;/p&gt;\
	&lt;/div&gt;',
	class: 'small-6 medium-4 large-3 columns msy',
	fit: true
	}
      });
   
  });
      </xsl:text></script>
</xsl:template>      

</xsl:stylesheet>
