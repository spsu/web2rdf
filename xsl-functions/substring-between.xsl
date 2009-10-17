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

<!-- Get a substring, chopping off matching bits before and after 
	 Usage: w2rdf:substring-between('abcdefg', 'ab', 'fg') returns 'cd' -->

<func:function name="w2rdf:substring-between">
	<xsl:param name="inputString" select="''" />
	<xsl:param name="after" select="''" />
	<xsl:param name="before" select="''" />
	<func:result
		select="substring-before(
			substring-after($inputString, $after), $before)" />
</func:function>

</xsl:stylesheet>

