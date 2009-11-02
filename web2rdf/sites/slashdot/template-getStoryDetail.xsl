<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD.

	========== Template: Get Comments [slashdot-getComments] =========

	This template fetches comments made on a story or comment page.
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:w2rdf="http://possibilistic.org/projects/web2rdf"
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
	extension-element-prefixes="str w2rdf">

<xsl:import href="../../exslt/str.xsl" />
<xsl:import href="../../w2rdf-functions/all.xsl" />

<xsl:strip-space elements="*"/>
<xsl:output 
	method="xml" 
	version="1.0" 
	encoding="utf-8"
	indent="yes"
/>

<xsl:template name="slashdot-getStoryDetail" match="/">

	<!-- =================== STORY VARIABLES =================== -->

	<xsl:variable
		name="story"
		select="//h3[@class='story']" />

	<xsl:variable
		name="title"
		select="$story//a[@class='datitle']/text()" />

	<xsl:variable
		name="date"
		select="substring-after($story//span[@class='date']/text(), 'on ')" />

	<xsl:variable
		name="numComments"
		select="$story//span[@class='vballoon-firehoselist-simple']/a/text()" />

	<xsl:variable
		name="commentsLink"
		select="$story//span[@class='vballoon-firehoselist-simple']/a/@href" />

	<xsl:variable
		name="storyLink"
		select="$story//a[@class='datitle']/@href" />

	<xsl:variable
		name="contents"
		select="//div[substring(@id,1,5)='text-']/node()" />

	<!-- =================== STORY OUTPUT =================== -->

	<sylph:story>
		
		<xsl:attribute 
			name="rdf:about">http:<xsl:value-of 
			select="$storyLink" /></xsl:attribute>

		<dcterms:title>
			<xsl:value-of select="$title" />
		</dcterms:title>
		<dcterms:date>
			<xsl:value-of select="$date" />
		</dcterms:date>

		<sioc:num_replies>
			<xsl:value-of select="$numComments" />
		</sioc:num_replies>

		<sylph:articleUri>http:<xsl:value-of 
			select="$storyLink" /></sylph:articleUri>

		<sylph:commentsUri>http:<xsl:value-of 
			select="$commentsLink" /></sylph:commentsUri>

		<!-- Story plaintext -->
		<!--<sioc:content>
			<xsl:for-each select="$contents">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = ''">
						<! - - Skip - - >
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)" />
						<xsl:if test="position() != last()">
							<! - - Followed by *two* newlines - - >
							<xsl:text>&#10;&#10;</xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</sioc:content>-->

		<!-- Story w/ markup -->
		<sioc:content rdf:parseType="Literal">
			<xsl:copy-of select="$contents" />
		</sioc:content>

	</sylph:story>

</xsl:template>
</xsl:stylesheet>
