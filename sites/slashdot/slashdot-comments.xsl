<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD and CC-BY-SA. -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:str="http://exslt.org/strings"
	xmlns:w2rdf="http://possibilistic.org/projects/web2rdf"
	xmlns:sioc="http://rdfs.org/sioc/ns#"
	extension-element-prefixes="str w2rdf">

<xsl:import href="../../exslt/str.xsl" />
<xsl:import href="../../xsl-functions/all.xsl" />

<xsl:strip-space elements="*"/>
<xsl:output 
	method="xml" 
	version="1.0" 
	encoding="utf-8"
	indent="yes"
/>

<!-- 
	TODO/XXX: 
	Make note of the use of the non-existant 'sylph' placeholder ontology!
	It will need development, refinement, and publication. 
	Also, its URI is not final.

	TODO:
	* How to do quotes within plaintext sioc:content??
	* Seperate user section with posts containing URI references.
	* List a post's parents and children.
	* List a post's respond-to address, etc.
	* Plaintext ul/li replacement (markdown on reddit will be even harder!)
-->


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

	<!-- ============= POSTS ============= -->
	<xsl:for-each 
		select="//span[@class='by']/../../..">

		<!-- Variables -->
		<xsl:variable
			name="postUri"
			select=".//div[@class='title']/h4/a/@href" />

		<xsl:variable
			name="postId"
			select="w2rdf:substring-between(
				.//div[@class='commentSub']//span[2]//a/@onclick, '(', ')' )" />

		<xsl:variable
			name="parentId"
			select="w2rdf:substring-between(
				.//div[@class='commentSub']//span[2]//a/@onclick, '(', ')' )" />

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
			name="anonymousUser"
			select="substring-after(.//span[@class='by'], 'by ')" />

		<xsl:variable
			name="userpage"
			select=".//span[@class='by']/a/@href" />

		<xsl:variable
			name="userid"
			select="w2rdf:substring-between(
				.//span[@class='by']/a/text(), '(', ')' )" />

		<xsl:variable
			name="date"
			select="w2rdf:substring-between(
				.//span[@class='otherdetails'], 'on ', ' (' )" />

		<xsl:variable
			name="userHomepage"
			select=".//a[@class='user_homepage_display']/@href" />

		<xsl:variable
			name="contentNode"
			select=".//div[@class='commentBody']/div/node()" />

		<xsl:variable
			name="isPartialComment"
			select=".//span[@class='substr']" />

		<!-- Comment -->
		<xsl:comment> Post #<xsl:value-of 
				select="position()" /> of <xsl:value-of 
				select="last()" />. </xsl:comment>

		<!-- Each post -->
		<sioc:Post>

			<xsl:attribute 
				name="rdf:about">http:<xsl:value-of 
				select="$postUri" /></xsl:attribute>

			<xsl:if test="$parentId">
				<sioc:reply_of>
					<xsl:value-of select="$parentId" />
				</sioc:reply_of>
			</xsl:if>

			<xsl:if test="$isPartialComment">
				<sylph:isPartialContent>True</sylph:isPartialContent>
			</xsl:if>

			<dcterms:title>
				<xsl:value-of select="$title" />
			</dcterms:title>

			<dcterms:date>
				<xsl:value-of select="$date" />
			</dcterms:date>

			<sylph:score>
				<xsl:value-of select="$score" />
			</sylph:score>

			<sylph:rating>
				<xsl:value-of select="$rating" />
			</sylph:rating>

			<!-- User/Author section -->
			<sioc:has_creator>
				<sioc:User>
					<xsl:choose>
						<xsl:when test="$username">
							<!-- User with account -->
							<sylph:websiteUsername>
								<xsl:value-of select="$username" />
							</sylph:websiteUsername>

							<sylph:websiteUserPage>http:<xsl:value-of 
								select="$userpage" /></sylph:websiteUserPage>

							<sylph:websiteUserId>
								<xsl:value-of select="$userid" />
							</sylph:websiteUserId>

							<xsl:if test="$userHomepage">
								<sylph:homepage>
									<xsl:value-of select="$userHomepage" />
								</sylph:homepage>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<!-- Anonymous Coward -->
							<sylph:websiteUsername>
								<xsl:value-of select="$anonymousUser" />
							</sylph:websiteUsername>
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

</rdf:RDF>
</xsl:template>
</xsl:stylesheet>
