<?xml version="1.0"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD and CC-BY-SA. -->

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:func="http://exslt.org/functions"
	xmlns:w2rdf="http://possibilistic.org/projects/web2rdf"
	extension-element-prefixes="str func w2rdf">

<!-- Get a substring, removing the part that matches.
	 Usage: w2rdf:removeSubstring('abcdefg', 'cde') returns 'abfg' -->

<func:function name="w2rdf:removeSubstring">
	<xsl:param name="inputString" select="''" />
	<xsl:param name="match" select="''" />

	<xsl:variable name="p1" select="substring-before($inputString, $match)" />
	<xsl:variable name="p2" select="substring-after($inputString, $match)" />

	<func:result select="concat($p1, $p2)" />
</func:function>

</xsl:stylesheet>

