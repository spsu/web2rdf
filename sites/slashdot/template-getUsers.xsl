<?xml version="1.0" encoding="utf-8"?>
<!-- Copyright 2009 Brandon Thomas Suit
	 web: http://possibilistic.org
	 email: echelon@gmail.com
	 Licensed under the BSD and CC-BY-SA 3.0. 
	 * http://creativecommons.org/licenses/by-sa/3.0/

	========== Template: Get Users [slashdot-getUsers] =========

	This template selects distinct users that appear on story or comment pages.
	It fetches the following:

		* website userpage address (the value of rdf:about)
		* username
		* userid
		* homepage (optional)

	Also, it fetches a single instance of "Anonymous Coward", if it exists.
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:str="http://exslt.org/strings"
	xmlns:set="http://exslt.org/sets"
	xmlns:exsl="http://exslt.org/common"
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
	extension-element-prefixes="str set exsl w2rdf">

<xsl:import href="../../exslt/str.xsl" />
<xsl:import href="../../exslt/set.xsl" />
<xsl:import href="../../w2rdf-functions/all.xsl" />

<xsl:strip-space elements="*"/>
<xsl:output 
	method="xml" 
	version="1.0" 
	encoding="utf-8"
	indent="yes"
/>

<xsl:template name="slashdot-getUsers" match="/">

	<!-- =================== USERS =================== -->

	<xsl:variable name="root" select="/" />

	<!-- Use EXSLT's set:distinct() to get one copy of each user. -->
	<xsl:variable name="distinctUsers">
		<xsl:call-template name="set:distinct">
			<xsl:with-param name="nodes" select="//span[@class='by']" />
		</xsl:call-template>
	</xsl:variable>

	<!-- Now use EXSLT's exsl:node-set() to convert them back to nodes. -->
	<xsl:for-each select="exsl:node-set($distinctUsers)/node()">

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

		<!-- This one is pretty complex since it's not in the 'by' span... -->
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
				<!-- Each user -->
				<xsl:when test="$username">

					<xsl:attribute 
						name="rdf:about">http:<xsl:value-of 
						select="$userPage" /></xsl:attribute>

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
				<!-- One copy of "Anonymous Coward" -->
				<xsl:otherwise>
					<xsl:attribute 
						name="rdf:nodeID">anonymous</xsl:attribute>

					<sylph:isAnonymousUser>True</sylph:isAnonymousUser>

					<sylph:websiteUsername>
						<xsl:text>Anonymous Coward</xsl:text>
					</sylph:websiteUsername>

				</xsl:otherwise>
			</xsl:choose>
		</sioc:User>
	</xsl:for-each>

</xsl:template>
</xsl:stylesheet>
