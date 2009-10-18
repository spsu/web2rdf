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
	xmlns:set="http://exslt.org/sets"
	xmlns:exsl="http://exslt.org/common"
	xmlns:w2rdf="http://possibilistic.org/projects/web2rdf"
	xmlns:sioc="http://rdfs.org/sioc/ns#"
	extension-element-prefixes="str set exsl w2rdf">

<xsl:import href="../../exslt/str.xsl" />
<xsl:import href="../../exslt/set.xsl" />
<!-- <xsl:import href="../../exslt/exsl.xsl" /> -->
<xsl:import href="../../w2rdf-functions/all.xsl" />

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

<xsl:template name="getUsers">
	<!--<xsl:variable name="test">
			<xsl:call-template name="set:distinct">
				<xsl:with-param name="nodes" select="//span[@class='by']" />
			</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="test2" select="exsl:node-set($test)" />

	<xsl:for-each select="$test2/node()">

		<sioc:User>

			<xsl:attribute 
				name="rdf:about">http:<xsl:value-of 
				select=".//a/@href" /></xsl:attribute>
		
		</sioc:User>

	</xsl:for-each>-->

</xsl:template>

<xsl:variable name="test">
	<xsl:call-template name="getUsers"/>
</xsl:variable>

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
	<!-- Note: Won't select anonymous cowards -->
	<xsl:for-each select="set:distinct(//span[@class='by']/a)">
		<sioc:User>USER!</sioc:User>
	</xsl:for-each>


	<xsl:variable name="test">
			<xsl:call-template name="set:distinct">
				<xsl:with-param name="nodes" select="//span[@class='by']" />
			</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="test2" select="exsl:node-set($test)" />

	<xsl:variable name="root" select="/" />

	<xsl:for-each select="$test2/node()">

		<!-- =================== USER VARIABLES =================== -->

		<xsl:variable
			name="username"
			select="substring-before(./a/text(), ' (')" />

		<xsl:variable
			name="userPage"
			select="./a/@href" />

		<xsl:variable
			name="userId"
			select="w2rdf:substring-between(./a/text(), '(', ')' )" />

		<xsl:variable
			name="userHomepage"
			select="$root//span[@class='by']/a[@href=$userPage]/../..//a[@class='user_homepage_display']/@href" />

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

						<sylph:isAnonymousUser>True</sylph:isAnonymousUser>

						<sylph:websiteUsername>
							<xsl:text>Anonymous Coward</xsl:text>
						</sylph:websiteUsername>

					</xsl:otherwise>
				</xsl:choose>
		
		</sioc:User>

	</xsl:for-each>
	

</rdf:RDF>

</xsl:template>
</xsl:stylesheet>
