#!/usr/bin/env python2.6

import warnings
warnings.simplefilter("ignore",DeprecationWarning)

# Just testing now

import rdflib
from rdflib.Graph import ConjunctiveGraph as Graph
from rdflib import Namespace
from rdflib import Literal
from rdflib import URIRef

from rdflib import plugin
from rdflib.store import Store, NO_STORE, VALID_STORE
from rdflib.store import SQLite

from rdfstore.RdfStore import RdfStore
from web2rdf.Web2Rdf import Web2Rdf

import sys

# Return string IO
def rdfString(string):
	from cStringIO import StringIO
	return StringIO(string)

# Main function
def main():
	"""Main Function
	Simple command-line procedure for web2rdf."""

	if len(sys.argv) != 2:
		print "Must call with a URI parameter."
		print "Usage: %s uriSrc" % sys.argv[0]
		return

	uri = sys.argv[1]

	# Get the RDF
	wrdf = Web2Rdf(uri)
	rdf = wrdf.getRdf()

	if not rdf:
		print "No RDF returned!"
		return False

	print "Got RDF..."
	rdf = rdfString(rdf)

	# Open Storage
	print "Opening store..."
	db = "./testdb.sqlite"
	rstore = RdfStore('sqlite', db)
	rstore.open()

	print "Storing..."
	graph = Graph(rstore.get(), identifier = URIRef("http://slashdot/Test2"))
	#graph.parse("example.rdf")
	graph.parse(rdf, publicID=uri)

	graph.commit()

if __name__ == '__main__': main()



