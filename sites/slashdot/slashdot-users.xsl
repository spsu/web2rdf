<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD and CC-BY-SA 3.0. 
	 * http://creativecommons.org/licenses/by-sa/3.0/
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:str="http://exslt.org/strings"
	xmlns:w2rdf="http://possibilistic.org/projects/web2rdf"
	xmlns:sioc="http://rdfs.org/sioc/ns#"
	extension-element-prefixes="str w2rdf">

<xsl:import href="../../exslt/str.xsl" />
<xsl:import href="../../exslt/set.xsl" />
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

	<!-- =================== USERS =================== -->
	<xsl:for-each select="//span[@class='by']/../../..">

		<!-- =================== USER VARIABLES =================== -->

		<xsl:variable
			name="username"
			select="substring-before(.//span[@class='by']/a/text(), ' (')" />

		<xsl:variable
			name="anonymousUser"
			select="substring-after(.//span[@class='by'], 'by ')" />

		<xsl:variable
			name="userPage"
			select=".//span[@class='by']/a/@href" />

		<xsl:variable
			name="userId"
			select="w2rdf:substring-between(
				.//span[@class='by']/a/text(), '(', ')' )" />

		<xsl:variable
			name="userHomepage"
			select=".//a[@class='user_homepage_display']/@href" />


		<!-- =================== USER OUTPUT =================== -->

		<!-- Comment -->
		<xsl:comment> User #<xsl:value-of 
				select="position()" /> of <xsl:value-of 
				select="last()" />. </xsl:comment>

		<sioc:User>

			<xsl:choose>
				<xsl:when test="$username">

					<xsl:attribute 
						name="rdf:about">http:<xsl:value-of 
						select="$userPage" /></xsl:attribute>

						<!-- User with account -->
						<sylph:websiteUsername>
							<xsl:value-of select="$username" />
						</sylph:websiteUsername>

						<sylph:websiteUserPage>http:<xsl:value-of 
							select="$userPage" /></sylph:websiteUserPage>

						<sylph:websiteUserId>
							<xsl:value-of select="$userId" />
						</sylph:websiteUserId>

						<xsl:if test="$userHomepage">
							<sylph:homepage>
								<xsl:value-of select="$userHomepage" />
							</sylph:homepage>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<!-- Anonymous Coward -->

						<xsl:attribute 
							name="rdf:ID">anonymous</xsl:attribute>

						<sylph:websiteUsername>
							<xsl:value-of select="$anonymousUser" />
						</sylph:websiteUsername>
					</xsl:otherwise>
				</xsl:choose>
					
		</sioc:User>

	</xsl:for-each>

</rdf:RDF>
</xsl:template>
</xsl:stylesheet>
