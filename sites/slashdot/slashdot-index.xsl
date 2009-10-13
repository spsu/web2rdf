<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="str">

<xsl:import href="../../exslt/str.xsl" />
<xsl:strip-space elements="*"/>
<xsl:output method="xml" version="1.0" encoding="utf-8" />

<xsl:template match="/">
<!--<xsl:text disable-output-escaping="yes">
	<![CDATA[
		<!DOCTYPE rdf:RDF system
				  "http://www.w3.org/XML/9710rdf-dtd/rdf.dtd">
	]]>
</xsl:text>-->
<rdf:RDF
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		xmlns:bio="http://purl.org/vocab/bio/0.1/"
		xmlns:sioc="http://rdfs.org/sioc/ns#"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:content="http://purl.org/rss/1.0/modules/content/"
		>
	<xsl:for-each select="//div[substring(@id,1,9) = 'firehose-' 
								and substring(@id,1,10) != 'firehose-d'
								and substring(@id,1,10) != 'firehose-m']">	
		<sioc:Post>
			<xsl:attribute 
				name="rdf:about">http:<xsl:value-of 
				select=".//a[@class='datitle']/@href" />
			</xsl:attribute>

			<!-- comment uri -->
			<rdfs:seeAlso>
				<xsl:attribute 
					name="rdf:resource">http:<xsl:value-of 
					select=".//span/span[text()='Comments:']/../a/@href" />
				</xsl:attribute>
			</rdfs:seeAlso>

			<dcterms:title>
				<xsl:value-of select=".//a[@class='datitle']/text()" />
			</dcterms:title>

			<sioc:content>
				<xsl:value-of select=".//div[substring(@id,1,5)='text-']" />
			</sioc:content>

			<dcterms:date>
				<xsl:value-of select="substring(.//span[@class='date']/text(),4)" />
			</dcterms:date>

			<sioc:num_replies>
				<xsl:value-of select=".//span[@class='commentcnt']/a/text()" />
			</sioc:num_replies>

			<!-- tag cloud -->
			<xsl:for-each select=".//a[@class='popular tag']">
				<sioc:topic>
					<xsl:attribute 
						name="rdf:resource">http://slashdot.org/tag/<xsl:value-of select="." />
					</xsl:attribute>
					<xsl:attribute 
						name="rdfs:label"><xsl:value-of select="." />
					</xsl:attribute>
				</sioc:topic>
			</xsl:for-each>

		</sioc:Post>
	</xsl:for-each>

	<!-- Slashdot comments -->
	<xsl:for-each select="//li[@class='comment']">
		<sioc:Post>
			<xsl:attribute 
				name="rdf:about">http:<xsl:value-of 
				select=".//h4/a/@href" />
			</xsl:attribute>
			<sioc:has_creator>
				<sioc:User>
					<xsl:attribute name="rdf:about">
						<xsl:value-of select=".//span[@class='by']/a/@href" />
					</xsl:attribute>
					<xsl:attribute name="rdfs:label">
						<xsl:value-of select=".//span[@class='by']/a/text()" />
					</xsl:attribute>
					<foaf:homepage>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of 
								select=".//a[@class='user_homepage_display']/@href" />
						</xsl:attribute>
					</foaf:homepage>
				</sioc:User>
			</sioc:has_creator>
			<dcterms:title>
				<xsl:value-of select=".//h4/a/text()" />
			</dcterms:title>
			<sioc:content>
				<xsl:value-of select=".//div[@class='commentBody']/div" />
			</sioc:content>
			<dcterms:date>
				<xsl:value-of select=".//span[@class='otherdetails']/text()" />
			</dcterms:date>

		</sioc:Post>
	</xsl:for-each>

</rdf:RDF>
</xsl:template>
</xsl:stylesheet>
