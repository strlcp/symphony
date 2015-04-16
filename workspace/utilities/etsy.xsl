<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="exsl"
>
<xsl:import href="etsy-listing.xsl"/>
<xsl:import href="etsy-product.xsl"/>


<xsl:key name="etsy-category" match="section" use="title/text()" />

<!-- the main sample -->
<xsl:template name="etsy">
  <xsl:param name="debug" />
  <xsl:param name="listing" />
  <xsl:param name="product" />
    <xsl:variable name="node" select="//data/*[name() = $listing]" />

    <xsl:variable name="product_section" select="//data/*[name() = $product]" />

    <xsl:if test="$debug">
      <div id="debug">
	<h4> debug </h4>
	  <xsl:value-of select="$listing" />
	  <xsl:text> sync </xsl:text> 
	  <xsl:value-of select="$node/@cache-age" /> 
	  <xsl:text> status </xsl:text> 
	  <xsl:value-of select="$node/@status" />
	  <xsl:text> count </xsl:text>
	  <xsl:value-of select="$node/data/count/text()" />		
	  <xsl:value-of select="$node/@cache-age" />

	  <br />
	  <xsl:value-of select="$product" />
	  <xsl:text> sync </xsl:text> 
	  <xsl:value-of select="$product_section/@cache-age" /> 
	  <xsl:text> status </xsl:text> 
	  <xsl:value-of select="$product_section/@status" />

	  <xsl:value-of select="$product_section/@valid" />

	  <xsl:copy-of select="$product_section" />
	  <br />
      </div>
    </xsl:if >
<!-- check where to go -->
  
  
  <div class="row"> 
  <div class="large-4 small-6 columns"> 
<!-- filter by category -->
  <button href="#" data-options="is_hover:true; hover_timeout:5000" data-dropdown="drop" aria-controls="drop" aria-expanded="true" class="etsy-dropdown-button">filter by category</button>
  <ul id="drop" class="f-dropdown" data-dropdown-content="">
   <li> 
    <a href="{$root}/{$root-page}/{$current-page}/" >
      <xsl:text> all categories </xsl:text>
    </a>
   </li> 
  <xsl:for-each select="$node/data/results/item/section[generate-id(.) = generate-id(key('etsy-category', title/text()))]">
   <li>
      <a href="{$root}/{$root-page}/{$current-page}/{translate(translate(title/text(), '&#x20;&#x9;&#xD;&#xA;', '+'),'&#x25;', '|')}" >
	  <xsl:value-of select="title/text()" /> 
      </a>
    </li>  
  </xsl:for-each>
  
  </ul>
  </div>
  
 <div class="large-6 small-6 columns end pkg">
  <h4>  <xsl:if test="$type and not($id)" ><xsl:value-of select="translate(translate($type, '|', '%'), '+', ' ')" /> </xsl:if> </h4>
 </div> 

</div> 
      <xsl:choose>
	<!-- using id only at product -->
	<xsl:when test="$id">
	
	<xsl:variable name="prod" select="$node/data/results/item/listing-id[text() = $id]/.." />
	
<!-- 	<xsl:value-of select="$product_section/@cache-age" /> -->
<!-- 	<xsl:apply-templates select="$node/data/results/item/listing-id[text() = $id]/.." mode="single"/> -->

<!-- 	must check if ds is loaded  -->

	 <xsl:apply-templates select="$product_section/data/results/item" mode="single_etsy_product"/>


	</xsl:when>
	
      </xsl:choose>



<xsl:choose>
<!--  checks wheter datasource is listing -->
<xsl:when test="$node/data/type/text() = 'Listing'">
<!--  test for first arg -->
 <xsl:choose >
 <xsl:when test="$type">
 <xsl:choose>

   
    <xsl:when test="$type and not($id)" >
      <xsl:call-template name="category" mode="etsy-listing">		
	<xsl:with-param name="node" select="$node" />
      </xsl:call-template>
    </xsl:when>
 
 
 
<!-- may use if you want -->
<!--

  <xsl:when test="$type = 'tags'">
         <xsl:call-template name="tags" mode="etsy-listing">		
	  <xsl:with-param name="node" select="$node" />
	</xsl:call-template>
    </xsl:when>
 <xsl:when test="$type = 'style'">
         <xsl:call-template name="style" mode="etsy-listing">		
	  <xsl:with-param name="node" select="$node" />
	</xsl:call-template>
    </xsl:when>
    <xsl:when test="$type = 'materials'">
         <xsl:call-template name="materials" mode="etsy-listing">		
	  <xsl:with-param name="node" select="$node" />
	</xsl:call-template>
    </xsl:when>
 -->
 
 
 
<!-- no first arg $type is given --> 

    </xsl:choose>


<!-- end listing -->
      </xsl:when>

<!-- default no args given -->
      <xsl:otherwise>
	 <div id="container" class="js-masonry row" />
	 <xsl:variable name="buffer">
	  <xsl:apply-templates select="$node/data/results/item" mode="etsy-listing" />
	  </xsl:variable> 
	  <xsl:call-template name="print-etsy-listing">  
	    <xsl:with-param name="buffer" select="$buffer" />
	  </xsl:call-template>
	</xsl:otherwise>
    </xsl:choose>

  </xsl:when>
</xsl:choose>
<!-- end etsy testcase -->
</xsl:template>


<!-- a sample products call -->







<xsl:template match="item" mode="etsy-product" >


<xsl:value-of select="." />

<div class="row">

 <div class="large-2 small=4 columns">
 
 
 
 
 </div>
<div class="large-8 small=8 columns">
 

 </div> 
  
 <div class="large-2 columns hide-on-small"> 
  
  <xsl:value-of select="variations/item/formatted-name/text()" /> 
  
</div> 
 
 
</div> 


    <div id="picture" >
      <img src="{images/item[1]/url-fullxfull/text()}" />
    </div>


<xsl:if test="/data/params/device-categorizr !=  'mobile'">


<xsl:for-each select="images/item">

<img src="{url-75x75/text()}" big="{url-fullxfull/text()}" no="{position() - 1}" />

</xsl:for-each>


</xsl:if>
<!-- -->
<!-- styles and tags an section -->
<xsl:if test="/data/params/device-categorizr !=  'mobile'">
  <h3> tags </h3>
    <xsl:apply-templates select="$prod/tags/item" mode="etsy-links" />

  <h3> section </h3>

  <h3> category </h3>
    <xsl:apply-templates select="$prod/category-path/item" mode="etsy-links" />
  <h3> style </h3>
    <xsl:apply-templates select="$prod/style/item" mode="etsy-links" />
  <h3> materials </h3>
    <xsl:apply-templates select="$prod/materials/item" mode="etsy-links" />
</xsl:if>

<!-- end card -->


<xsl:value-of select="when_made" />

<h2>
<xsl:value-of select="title/text()" />
<br />
</h2>

<xsl:call-template name="replace" mode="reg">
<xsl:with-param name="string">
<xsl:value-of select="description" />
</xsl:with-param>
</xsl:call-template> 



<script type="text/javascript">


  require( ['lib/collection/simpleImage', 'lib/view/simpleImageList', 'lib/view/simpleImage', 'lib/router'], function( collection, list, view, router) {
	 <xsl:text> var rootDir = '</xsl:text>
 	 <xsl:value-of select="concat($root, '/', $root-page, '/')" />
 		     <xsl:text>';
 		     var sample = new collection();
 		     
 		     </xsl:text> 
 		     
 		     
 		     	<xsl:text disable-output-escaping="yes">  
        var list = new list({collection: sample, el: '#container', layout: {
	
	masonry: {
	  "gutter": 20,
	  "columnWidth": 300,
	  "itemSelector": ".msy"
	  }
	
	 },
	childopts:{
	tpl:'&lt;div&gt;\
	&lt;a href={{ link }}&gt;\
	&lt;img alt="{{ called }}" src="{{ src }}" /&gt;\
	&lt;/a&gt;\
	&lt;p&gt; {{ called }} &lt;/p&gt;\
	&lt;/div&gt;',
	class: 'small-6 medium-4 large-3 columns msy',
	fit: true
	}
      });
    		
  
  	
}); </xsl:text> 
</script>

</xsl:template>
 
<!-- print links etsy helper --> 
<xsl:template match="item" mode="etsy-links" > 
  <xsl:variable name="type" select="name(..)" />
  <xsl:variable name="text" select="translate(., '&#x20;&#x9;&#xD;&#xA;', '+')" />
    <a href="{$root}/{$root-page}/{$current-page}/{$type}/{$text}" >
      <p>
	<xsl:value-of select="concat(' ', text())" />
      </p>
    </a>
</xsl:template>

</xsl:stylesheet>
