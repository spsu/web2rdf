#!/usr/bin/env python2.6

from news.models import Post

posts = Post.objects.all() 
print posts
print ""

for post in posts:
	print post


