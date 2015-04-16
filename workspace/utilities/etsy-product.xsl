<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="exsl"
>

<xsl:template match="item" mode="single_etsy_product">


<div class="row">


 <div class="large-2 small=4 columns hide-for-small">
    <xsl:for-each select="variations/item" >
      <h4> 
     <xsl:value-of select="formatted-name/text()" />
     </h4>
	<xsl:for-each select="options/item">
	  <p>	
	    <xsl:value-of select="formatted-value/text()" />
	 </p> 
       </xsl:for-each>
    </xsl:for-each>
 
 </div>
  <div class="large-8 small=8 columns">
    <div class="row">
      <div class="large-12 columns">
	<h3>
	  <xsl:value-of select="title/text()" />
	</h3>
      </div>
    </div>
    <div class="row">
     <div class="large-10 small-12 columns">
      <div id="poster"/>
     </div>
     <div class="large-2 columns">
     <div class="row"> 
      <div id="sidebar"/>
     </div> 
    </div>
   </div>
    <xsl:variable name="buffer">
        <xsl:apply-templates select="images/item" mode="etsy_product_images" />
    </xsl:variable>
   <noscript>
    <xsl:for-each select="exsl:node-set($buffer)/noscript/*" >
      <xsl:copy-of select="." />
    </xsl:for-each>
   </noscript>
   

    <script type="text/javascript"><xsl:text>
    require( ['lib/view/simpleImage',  'lib/collection/simpleImage', 'lib/view/simpleImageList'], function(view, collection, list) {
	
	var sample = new collection();
     </xsl:text>
           <xsl:for-each select="exsl:node-set($buffer)/script" >
	 <xsl:text>sample.add</xsl:text>	
	      <xsl:value-of select="." />
	 <xsl:text>
	 </xsl:text>    
        </xsl:for-each>
        
      
	<xsl:text disable-output-escaping="yes">  
        new list({collection: sample, el: '#sidebar', layout: {
	/*
	masonry: {
	  "gutter": 20,
	  "columnWidth": 300, 
	  "itemSelector": ".msy"
	  }
	*/
	 },
	childopts:{
	tpl:'&lt;div&gt;\
	&lt;a href=#{{ hash }} &gt;\
	&lt;img alt={{ alt }}  src={{ src }}  /&gt;\
	&lt;/a&gt;\
	&lt;/div&gt;',
	class: 'large-12 columns',
	fit: true
	}
      });
      
     
    var bigView = new view({model: sample.models[0], el: '#poster', fit: true,
    tplStr: '&lt;img alt="{{ alt }}"  src="{{ src }}" /&gt;',
	class: 'large-12 columns hide-for small'
    }).render();
    
     
    var rootDir = '</xsl:text>
 		     <xsl:value-of select="concat($root, '/',  $root-page, '/etsy/product/', listing-id)" />
 		     <xsl:text>';  
          
    var router = Backbone.Router.extend({
     
      routes: {
          "*id": "nav"
      },
      
      nav: function(id){
	if (_.isNull(id)) return this;
	var m  = this.sample.find(function(model) { 
		  return model.get('hash') == id; 
	  }); 
	this.view.model = m;
	
      	this.view.isRenderd = false; 
      	this.view.render();
      },
      initialize: function(sample, bigView){
	  this.sample = sample;  
	  this.view = bigView;
	  }
      });
      var app = new router(sample, bigView);
      Backbone.history.start();
       
    });</xsl:text>
   </script>
  </div> 
<!-- variations -->  
  <div class="large-2 columns">    
  	      
    
    
    <ul class="pricing-table"> 
      <li class="title">Buy on etsy</li> 
      <li class="price"><xsl:value-of select="concat(price/text(), ' ',currency-code/text())" /></li> 
    <li class="description">inclusive tax</li>
     <li class="description">exclusive shipping</li>
      <li class="bullet-item">    
	<xsl:if test="when-made/text() = 'made_to_order'">
	  <xsl:text> made to order  </xsl:text>
	</xsl:if>
	<xsl:if test="when-made/text() = '2010_2015'" >
	  <xsl:text> on stock </xsl:text>
	</xsl:if>
      </li> 
      <li class="bullet-item">shipping worldwide</li> 
      <li class="bullet-item"></li> 
      <li class="cta-button">
      <a class="button">
	<xsl:attribute name="href">
	  <xsl:value-of select="url/text()" />
	</xsl:attribute>
	Buy Now
      </a>
      </li>
    </ul>
    
    
  </div> 
 </div>
 <div class="row" >
  <div class="large-centered   small-10 columns"> 
  
 <!-- format etsy description --> 
    <xsl:call-template name="replace" mode="reg">
      <xsl:with-param name="string">
	<xsl:value-of select="description/text()" />
      </xsl:with-param>
    </xsl:call-template>
    
     
  </div>
</div>  
</xsl:template>



<xsl:template match="item" mode="etsy_product_images">

    <noscript>
    <img>
      <xsl:attribute name="src"> 
	<xsl:value-of select="url-170x135/text()" />
      </xsl:attribute>
    </img>
    </noscript>
    <script>
    <xsl:call-template name="pictureWrapperModel">
      <xsl:with-param name="text" >
	<xsl:text>{called: '</xsl:text><xsl:value-of  select="../../title/text()" /><xsl:text>',
	  price: '</xsl:text><xsl:value-of  select="concat(../../price/text(), ' ',../../currency-code/text())" /><xsl:text>'}</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="link" select="concat($root, '/', $root-page, '/', $current-page, '/product/', ../../listing-id)" />
      <xsl:with-param name="resp">
    	  <xsl:text>{
		    75: '</xsl:text><xsl:value-of select="url-75x75/text()" /><xsl:text>',
		    170: '</xsl:text><xsl:value-of select="url-170x135/text()" /><xsl:text>',
		    570: '</xsl:text><xsl:value-of select="url-570xn/text()" /><xsl:text>'}</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
    </script>
</xsl:template>
</xsl:stylesheet>
