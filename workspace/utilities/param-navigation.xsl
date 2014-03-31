<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- 

# install:

### create a static xml like: 

<articles>
<param-navigation-articles child="title" arg="handle" param="entry" />
</articles>
#### to navigate trough articles in the default workspace.


####  not default workspace example:

<gallery>
  <param-types child="name" arg="handle" param="type" >
  <param-sample child=name" arg="handle" param="list" refer="types"  />    
  </param-type>
</gallery>



##### where 


 - the node name is the name of the unchained source

- @child: 
  child node holding the value
  
- @arg: 
  atrribute (of this child)  the value is taken from
  in most cases this is handle..  
  
- @param: 
  the page parameter wich have this value in case of this param is aktive 
  
- @refer [optinal]  
  the child node , a select box link filed is aktiv in case of chained datasources 
  normaly thi is the section name

### unchained datasources output:
  
    </param-navigation-archive>
    <param-navigation-articles>
        <section id="1" handle="articles">Articles</section>
        <entry id="4">
            <title handle="an-example-draft-article">An example draft article</title>
        </entry>
        <entry id="3">
            <title handle="a-primer-to-symphony-2s-default-theme">A primer to Symphony 2's default theme</title>
        </entry>
    </param-navigation-articles 

     in case of one page param to navigate,

     using more param the select box link field must be included
     

# calling:

for normal navigation:
	<xsl:apply-templates select="data/navigation"/>
	
	
for breadcrumbs:
	 <xsl:apply-templates select="/data/breadcrumb" />

-->
<!--  invoker -->

<xsl:template match="navigation">
<nav>
   <ul id="menu">
    <xsl:apply-templates select="page[not(types/type = 'hidden') and not(types/type = 'admin')]" >
      <xsl:with-param name="path" select="$root" />
      <xsl:with-param name="collapse" select="'no'" />
    </xsl:apply-templates>
<!-- logged in hooks | id checked in master -->    
    <xsl:if test="$is-logged-as">
	<li><a href="{$root}/drafts/">Drafts</a></li>
	<li><a href="{$root}/symphony/">Admin</a></li>
	<xsl:if test="/data/logged-in-author/author[@user-type = 'developer']">
		<li><a href="?debug">Debug</a></li>
	</xsl:if>
   </xsl:if>		
  </ul>
</nav>    
</xsl:template>





<!-- page navigation -->

<xsl:template match="page">
  <xsl:param name="path" select="''" />
  <xsl:param name="collapse" select="'no'" />
  <xsl:if test="not(types/type = 'hidden') and not(types/type = 'admin')">
    <li>
      <xsl:if test="@id = $current-page-id">
        <xsl:attribute name="class">active</xsl:attribute>
      </xsl:if>
      <xsl:if test="descendant::node()[@id = $current-page-id]">
        <xsl:attribute name="class">activeparent</xsl:attribute>
      </xsl:if>
  
      <a href="{$path}/{@handle}/">
        <xsl:value-of select="name"/>
      </a>
  
      
      <!-- merge with param-navigation -->
      
      <xsl:apply-templates select="/data/param-navigation">
	  <xsl:with-param name="page" select="@handle" />
	  <xsl:with-param name="path" select="$path" />
      </xsl:apply-templates>
      
      <!-- end merge -->
      
      <!-- there is a problem with subpages and params // like in real ?-->
      <xsl:if test="page != '' and ($collapse = 'no' or descendant-or-self::node()[@id = $current-page-id])">
        <ul>
          <xsl:apply-templates select="page">
            <xsl:with-param name="path" select="concat($path,'/',@handle)" />
            <xsl:with-param name="collapse" select="$collapse" />
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:if>
</xsl:template>

<!-- param navigation invoker -->
<xsl:template match="/data/param-navigation">
  <xsl:param name="page" />
  <xsl:param name="path" />
<!-- checking if page is listed in xml -->

    <xsl:for-each select="*">
      <xsl:if test="name() = $page">
	  <xsl:variable name="sub" select="*[1]" />
	  <ul> 
	   <xsl:call-template name="loop" mode="param-navigation" >
	      <xsl:with-param name="sub" select="$sub" />
	      <xsl:with-param name="page" select="$page" />	
	      <xsl:with-param name="path" select="$path" />
	  </xsl:call-template>
	 </ul> 
	</xsl:if>
   </xsl:for-each>
      
</xsl:template>

<!-- looping over relevant might entries  -->


<xsl:template name="loop" mode="param-navigation">
      <xsl:param name="sub" />
      <xsl:param name="page" />
      <xsl:param name="path" />
      
      <xsl:param name="refer-id" />
      <xsl:param name="refer" />
      
      <xsl:variable name ="node" >
      <xsl:value-of select="name($sub)" />
      </xsl:variable>

      <xsl:apply-templates select="/data/*[name() = $node]/*[name() = 'section']/../entry" mode="param-navigation" >
            <xsl:with-param name="path" select="concat($path, '/' ,$page)" />
            <xsl:with-param name="sub" select="$sub" />
            <xsl:with-param name="refer" select="$refer" />
            <xsl:with-param name="refer-id" select="$refer-id" />
      </xsl:apply-templates>

 
 </xsl:template>

 <!-- working on the entries -->

<xsl:template match="entry" mode="param-navigation">

  <xsl:param name="path" />
  <xsl:param name="sub" />
  <xsl:param name="refer" />
  <xsl:param name= "refer-id" />
    
    
  <!-- page must be more felxible: some kind of parser -->  
    
  <xsl:variable name="page">
      <xsl:value-of select="*[name() = $sub/@child]/@*[name() = $sub/@arg]" />
  </xsl:variable>

  <!-- build some kind of more flexible output -->
  
  <!--  test hier for optiongroup -->
  

  <xsl:if test="not ($refer-id) or *[name() = $refer]/item[@id = $refer-id]" >
      <li>
      <!-- test active aktiv parent -->
	<xsl:if test="$page = /data/params/*[name() = $sub/@param]">
	  <xsl:choose>
	    <xsl:when test="not($sub/*[1]) or not(/data/params/*[name() = $sub/*[1]/@param])"> 
		<xsl:attribute name="class">active</xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:attribute name="class">activeparent</xsl:attribute>  
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:if>  
	
     	<a href= "{$path}/{$page}"> 
	  <xsl:value-of select="$page" />
	</a>

   
   <!--  go deeper -->
    
    <xsl:if test="$sub/*[1]">
      <ul> 
       <xsl:call-template name="loop" mode="param-navigation" >
	<xsl:with-param name="sub" select="$sub/*[1]" />
	<xsl:with-param name="page" select="$page" />	
	<xsl:with-param name="path" select="$path" />
	
	<xsl:with-param name="refer-id" select="@id" />
	<xsl:with-param name="refer" select="../section/@handle" />
      </xsl:call-template>
    
      </ul> 
    </xsl:if> 
    </li>	  
  </xsl:if>
</xsl:template>




<!-- page breadcrumb -->

<!-- breadcrumb -->
<xsl:template match="breadcrumb">       
      <nav>
	<ul id="breadcrumb" >
	  <xsl:apply-templates select="page" mode="para-breadcrumb"/>
	</ul>
      </nav>
</xsl:template>



<xsl:template match="page" mode="para-breadcrumb">
  <xsl:variable name="page" select="@path" />
    <li>
      <a href="{$root}/{$page}">
	<xsl:value-of select="$page" />
      </a>
   </li>
   
    <xsl:call-template name="param-navigation" mode="para-breadcrumb">
      <xsl:with-param name="path" select="@path" />
      <xsl:with-param name="node" select="/data/param-navigation/*[name() = $page]" />
   </xsl:call-template>
</xsl:template>


<!-- param navigatio n for breadcrumb -->
<xsl:template name="param-navigation" mode="para-breadcrumb" >
  <xsl:param name="path" />
  <xsl:param name="node" />

   <xsl:variable name="page">
         <xsl:value-of select="/data/params/*[name() = $node/@param]" />
   </xsl:variable>
   
    <xsl:if test="$page"> 
  
      <li>
      <a href="{$root}/{$path}/{$page}">
	<xsl:value-of select="$page" />
      </a>
    </li>
  
    </xsl:if>
    
    <xsl:if test="$node/*[1]">

        <xsl:call-template name="param-navigation" mode="para-breadcrumb">
	<xsl:with-param name="path" select="concat($path, '/', $page)" />
	<xsl:with-param name="node" select="$node/*[1]" />
      </xsl:call-template>
  
  <!--    -->
    </xsl:if>
  
</xsl:template>


</xsl:stylesheet>
