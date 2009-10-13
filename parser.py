#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit

import tidy
import httplib
import libxml2
import libxslt

def fetch(host, path):
	conn = httplib.HTTPConnection(host)
	conn.request("GET", path)
	r = conn.getresponse()
	data = r.read()

	# Cleanup
	options = dict(output_xhtml=1, add_xml_decl=1, indent=1, tidy_mark=0)
	return tidy.parseString(data, options)

def xslParse(xml, xslFile, saveFile = None):

	xmldoc = libxml2.parseFile(xslFile)
	xslt = libxslt.parseStylesheetDoc(xmldoc)
	doc = libxml2.parseMemory(xml, len(xml))
	result = xslt.applyStylesheet(doc, None)
	if saveFile and type(saveFile) == str:
		xslt.saveResultToFilename(saveFile, result, 0)
	xslt.freeStylesheet()
	doc.freeDoc()
	result.freeDoc()
	xmldoc.freeDoc()


host = "slashdot.org"
path = "/"

data = fetch(host, path)

f = open("./test","w")
f.write(str(data))


xslParse(str(data), "./sites/slashdot/slashdot-index.xsl", "./out.rdf")

