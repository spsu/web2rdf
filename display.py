#!/usr/bin/env python2.6

import warnings
warnings.simplefilter("ignore",DeprecationWarning)

import rdflib
from rdflib.Graph import ConjunctiveGraph as Graph
from rdflib import Namespace
from rdflib import Literal
from rdflib import URIRef

from rdflib import plugin
from rdflib.store import Store, NO_STORE, VALID_STORE
from rdflib.store import SQLite
from rdflib.sparql.bison import Parse

from rdfstore.RdfStore import RdfStore

#params = "./testdb.sqlite"								# SQLITE
params = ('localhost', 'tuser', 'tuser', 'rdf')			# MYSQL
rstore = RdfStore(params)
rstore.open()
store = rstore.get()

#print "===== Contexts ====="
#for c in store.contexts():
#	print "* " + str(c)
#	ctx = c
#print ""

graph = Graph(store, identifier = URIRef("http://test"))

def getUsers(graph):
	query = """
			PREFIX sioc: <http://rdfs.org/sioc/ns#>
			PREFIX sylph: <http://possibilistic.org/onto/>
			SELECT ?username ?userid
			WHERE {
				?u sylph:sylphwebsiteUsername ?username.
				?u sylph:sylphwebsiteUserId ?userid.
			}
			ORDER BY ?username
			LIMIT 100
			"""
	query = Parse(query)

	print "===== Users =====" 
	i = 0
	for row in graph.query(query):
		i+=1
		print "%s (%s)" %row
	print "Total users: %d" % i

def getStories(graph):
	query = """
			PREFIX sioc: <http://rdfs.org/sioc/ns#>
			PREFIX dcterms: <http://purl.org/dc/terms/>
			PREFIX sylph: <http://possibilistic.org/onto/>
			SELECT DISTINCT ?post ?title
			WHERE {
				?post a sioc:Post ;
					  dcterms:title ?title.
				OPTIONAL {
					?post sioc:has_creator ?user.
				}
				FILTER( !bound(?user) )
			}
			"""
	query2 = """
			PREFIX sioc: <http://rdfs.org/sioc/ns#>
			PREFIX dcterms: <http://purl.org/dc/terms/>
			PREFIX sylph: <http://possibilistic.org/onto/>
			SELECT ?title ?username
			WHERE {
				?post a sioc:Post ;
					  dcterms:title ?title;
					  sioc:has_creator ?user.
				?user sylph:sylphwebsiteUsername ?username.
			}
			"""
	query = Parse(query)

	print "===== Stories =====" 
	i = 0
	for row in graph.query(query):
		i+= 1
		print "* %s (%s)" % row
	print "Total stories: %d" % i

#getStories(graph)
getUsers(graph)


#print "=================\n\n"
#ns_dcterms = Namespace("http://purl.org/dc/terms/")
#for x in graph.objects(None, ns_dcterms['title']):
#	print x # rdflib.Literal.Literal


#for x in store.triples((None, None, None), URIRef('http://slashdot.org/#context')):
#	print x


