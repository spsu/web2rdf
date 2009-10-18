<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD and CC-BY-SA 3.0. 
	 * http://creativecommons.org/licenses/by-sa/3.0/

	========== Template: Get Comments [slashdot-getComments] =========

	This template fetches comments made on a story or comment page.
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
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

<xsl:template name="slashdot-getComments" match="/">

	<!-- =================== POSTS =================== -->
	<xsl:for-each select="//span[@class='by']/../../..">

		<!-- =================== POST VARIABLES =================== -->

		<xsl:variable
			name="postUri"
			select=".//div[@class='title']/h4/a/@href" />

		<xsl:variable
			name="postId"
			select="w2rdf:substring-between(
				.//div[@class='commentSub']//span[1]//a/@onclick, '(', ')' )" />

		<xsl:variable
			name="parentId"
			select="w2rdf:substring-between(
				.//div[@class='commentSub']//span[2]//a/@onclick, '(', ')' )" />

		<!-- TODO: Verify this works -->
		<xsl:variable
			name="storyId"
			select="w2rdf:substring-between($postUri, 'sid=', '&amp;')" />

		<!-- XXX Note: Only use parentUri if parentId is set! -->
		<xsl:variable
			name="parentUri"
			select="concat(
				w2rdf:removeSubstring($postUri, $postId), $parentId)" />

		<xsl:variable 
			name="title" 
			select=".//div[@class='title']/h4/a" />

		<xsl:variable 
			name="score" 
			select="substring-after(.//div[@class='title']/h4/span/a, ':')" />

		<xsl:variable 
			name="rating" 
			select="w2rdf:substring-between(
				.//div[@class='title']/h4/span, ', ', ')' )" />

		<xsl:variable
			name="username"
			select="substring-before(.//span[@class='by']/a/text(), ' (')" />

		<xsl:variable
			name="userPage"
			select=".//span[@class='by']/a/@href" />

		<xsl:variable
			name="date"
			select="w2rdf:substring-between(
				.//span[@class='otherdetails'], 'on ', ' (' )" />

		<xsl:variable
			name="contentNode"
			select=".//div[@class='commentBody']/div/node()" />

		<xsl:variable
			name="isPartialComment"
			select=".//span[@class='substr']" />

		<!-- =================== POST OUTPUT =================== -->

		<!-- Comment -->
		<xsl:comment> Post #<xsl:value-of 
				select="position()" /> of <xsl:value-of 
				select="last()" />. </xsl:comment>

		<sioc:Post>

			<xsl:attribute 
				name="rdf:about">http:<xsl:value-of 
				select="$postUri" /></xsl:attribute>

			<!-- If viewing only a specific comment, the parents of relative 
			posts are loaded by Javascript/Ajax and won't show up. -->
			<xsl:if test="$parentId">
				<sioc:reply_of>http:<xsl:value-of 
						select="$parentUri" /></sioc:reply_of>
			</xsl:if>

			<xsl:if test="$isPartialComment or $date = ''">
				<sylph:isPartialContent>True</sylph:isPartialContent>
			</xsl:if>

			<!-- If viewing only a specific comment, the dates of relative posts
			are missing! Stupid slashdot loads them with Javascript/Ajax. -->
			<xsl:if test="$date">
				<dcterms:date>
					<xsl:value-of select="$date" />
				</dcterms:date>
			</xsl:if>

			<dcterms:title>
				<xsl:value-of select="$title" />
			</dcterms:title>

			<sylph:score>
				<xsl:value-of select="$score" />
			</sylph:score>

			<sylph:rating>
				<xsl:value-of select="$rating" />
			</sylph:rating>

			<sioc:has_creator>
				<sioc:User>
					<xsl:choose>
						<xsl:when test="$username">
							
							<xsl:attribute 
								name="rdf:about">http:<xsl:value-of 
								select="$userPage" /></xsl:attribute>

						</xsl:when>
						<xsl:otherwise>
							<!-- Anonymous Coward -->
							<xsl:attribute 
								name="rdf:nodeID">anonymous</xsl:attribute>

						</xsl:otherwise>
					</xsl:choose>

				</sioc:User>
			</sioc:has_creator>

			<!-- Main content plaintext -->
			<sioc:content>
				<xsl:for-each select="$contentNode">
					<xsl:choose>
						<xsl:when test="normalize-space(.) = ''">
							<!-- Skip -->
						</xsl:when>
						<xsl:otherwise>
							<!-- Paragraph, quote, or whatever -->
							<xsl:if test="name(.)='div'">
								<xsl:text>Quote: </xsl:text>
							</xsl:if>
							<xsl:value-of select="." />
							<xsl:if test="position() != last()">
								<!-- Followed by *two* newlines -->
								<xsl:text>&#10;&#10;</xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</sioc:content>

			<!-- Main content w/ markup -->
			<sioc:content rdf:parseType="Literal">
				<xsl:copy-of select="$contentNode" />
			</sioc:content>

		</sioc:Post>

	</xsl:for-each>

</xsl:template>
</xsl:stylesheet>
