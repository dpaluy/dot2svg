<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- 
file: embed-svg-graphics.xsl
author: Martin Loetzsch

Embeds generated SVG graphics generated by generate-svg-graphics.bash into a document.
It can  be applied to a XHTML or another XML file that contains DotML "graph" elements. 
For each dotml:graph element, an 
  <object type="image/svg+xml" data="file-name.svg" class=".svg-size-file-name.css"/>
is generated. All other elements from the source tree are copied unchanged to the output. 

The inclusion of the CSS stylesheets containing the width and height of each SVG graphic is added to the 
<head>...</head> element.

Instead of applying the whole style sheet, it can also be included to another stylesheet with 
<xsl:import href="embed-svg-graphics-xsl"/>

Then inside the "head" element, you will have to call the "include-css-stylesheets" template manually:
<head>
	<title>Title</title>
	<xsl:call-template name="include-css-stylesheets"/>
</head>

The <object></object> element for each dotml:graph can be generated by using
<xsl:apply-imports/> 
in the context with the dotml:graph element or with
<xsl:for-each select="dotml:graph">
  <xsl:call-template name="embed-svg-as-object"/>
</xsl:for-each>
-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dotml="http://www.martin-loetzsch.de/DOTML">
  <xsl:output method="html" indent="no" encoding="ISO-8859-1" omit-xml-declaration="no"/>
  <xsl:template name="include-css-stylesheets">
    <!-- Generates a <link rel="stylesheet" type="text/css" href=""/> element for each dotml:graph.
	             The current context should be inside the <head></head> element.-->
    <xsl:for-each select="//dotml:graph">
      <link rel="stylesheet" type="text/css" href="{@file-name}.size.css">
        <xsl:comment>
          <xsl:text>
</xsl:text>
        </xsl:comment>
      </link>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="embed-svg-as-object">
    <!-- embeds the SVG graphic generated from a dotml:graph element into the HTML file. 
      The context must be a dotml:graph element -->
    <object type="image/svg+xml" data="{@file-name}.svg">
      <xsl:attribute name="class">svg-size-<xsl:call-template name="normalize-file-name">
          <xsl:with-param name="file-name" select="@file-name"/>
        </xsl:call-template></xsl:attribute>
    </object>
  </xsl:template>
  <xsl:template match="*" priority="-1000">
    <xsl:copy>
      <xsl:copy-of select="./@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()" priority="-1000">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>
  <xsl:template match="dotml:graph">
    <xsl:call-template name="embed-svg-as-object"/>
  </xsl:template>
  <xsl:template match="html:head">
    <xsl:copy>
      <xsl:apply-templates/>
      <xsl:call-template name="include-css-stylesheets"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="normalize-file-name">
    <xsl:param name="file-name"/>
    <xsl:choose>
      <xsl:when test="string-length(substring-after($file-name,'/'))&gt;0">
        <xsl:call-template name="normalize-file-name">
          <xsl:with-param name="file-name" select="substring-after($file-name,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$file-name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
