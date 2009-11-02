#!/usr/bin/env python2.6

from web2rdf.Web2Rdf import Web2Rdf

wrdf = Web2Rdf("http://slashdot.org")
wrdf.saveRdf()

