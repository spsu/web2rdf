<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD and CC-BY-SA. -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:str="http://exslt.org/strings"
	xmlns:sioc="http://rdfs.org/sioc/ns#"
	extension-element-prefixes="str">

<xsl:import href="../../exslt/str.xsl" />

<xsl:strip-space elements="*"/>
<xsl:output 
	method="xml" 
	version="1.0" 
	encoding="utf-8"
	indent="yes"
/><!--
	cdata-section-elements="sioc:content"-->

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
		>
	<xsl:for-each select="//div[substring(@id,1,9) = 'firehose-' 
								and substring(@id,1,10) != 'firehose-d'
								and substring(@id,1,10) != 'firehose-m']">

	<xsl:comment>
		Post <xsl:value-of select="position()" /> of <xsl:value-of select="last()" />.
  </xsl:comment>

		<!-- Variables -->
		<xsl:variable 
			name="title" 
			select=".//a[@class='datitle']/text()" />
		<xsl:variable 
			name="commentUri" 
			select=".//span[text()='Comments:']/../a/@href" />
		<xsl:variable 
			name="commentUri2" 
			select=".//span[@class='commentcnt']/a/@href" /> <!-- TODO: 0 comments -->
		<xsl:variable 
			name="commentCount" 
			select=".//span[@class='commentcnt']/a/text()" />
		<xsl:variable
			name="contentNode"
			select=".//div[substring(@id,1,5)='text-']" />


		<!-- RDF for each post -->
		<sioc:Post>
			<xsl:attribute 
				name="rdf:about">http:<xsl:value-of 
				select=".//a[@class='datitle']/@href" />
			</xsl:attribute>

			<!-- comment uri -->
			<rdfs:seeAlso>
				<xsl:attribute 
					name="rdf:resource">http:<xsl:value-of 
					select="$commentUri2" />
				</xsl:attribute>
			</rdfs:seeAlso>

			<dcterms:title>
				<xsl:value-of select="$title" />
			</dcterms:title>

			<!-- Main content plaintext-->
			<sioc:content>
				<xsl:value-of select="normalize-space($contentNode)" />
			</sioc:content>

			<!-- Main content w/ markup -->
			<sioc:content rdf:parseType="Literal">
				<xsl:for-each select=".//div[substring(@id,1,5)='text-']/node()">
					<xsl:variable name="cur" select="."/>
					<xsl:choose>
						<xsl:when test="position()=1">
							<xsl:copy-of select="normalize-space(.)" />
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$cur" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</sioc:content>

			<dcterms:date>
				<xsl:value-of select="substring(.//span[@class='date']/text(),4)" />
			</dcterms:date>

			<sioc:num_replies>
				<xsl:value-of select="$commentCount" />
			</sioc:num_replies>

			<!-- tag cloud -->
			<xsl:for-each select=".//a[@class='popular tag']">
				<sioct:tag>
					<xsl:attribute 
						name="rdf:resource">http://slashdot.org/tag/<xsl:value-of select="." />
					</xsl:attribute>
					<xsl:attribute 
						name="rdfs:label"><xsl:value-of select="." />
					</xsl:attribute>
				</sioct:tag>
			</xsl:for-each>

		</sioc:Post>
	</xsl:for-each>

</rdf:RDF>
</xsl:template>
</xsl:stylesheet>
