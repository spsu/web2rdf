<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD.

	========== Page: Story =========

	Returns the story, users, and comments on a "story" page.
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="./template-getStoryDetail.xsl" />
<xsl:import href="./template-getComments.xsl" />
<xsl:import href="./template-getUsers.xsl" />

<xsl:strip-space elements="*"/>
<xsl:output 
	method="xml" 
	version="1.0" 
	encoding="utf-8"
	indent="yes"
/>

<xsl:template match="/">
<rdf:RDF
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:bio="http://purl.org/vocab/bio/0.1/"
	xmlns:sioc="http://rdfs.org/sioc/ns#"
	xmlns:sioct="http://rdfs.org/sioc/types#"
	xmlns:rss="http://purl.org/rss/1.0/"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:sylph="http://possibilistic.org/onto/sylph"
>
	<xsl:comment> Story Section </xsl:comment>
	<xsl:call-template name="slashdot-getStoryDetail" />

	<xsl:comment> Comment Section </xsl:comment>
	<xsl:call-template name="slashdot-getComments" />

	<xsl:comment> User Section </xsl:comment>
	<xsl:call-template name="slashdot-getUsers" />

</rdf:RDF>
</xsl:template>
</xsl:stylesheet>
