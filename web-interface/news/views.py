from django.http import HttpResponse
from models import Post

def index(request):
	posts = Post.objects.all()
	pStr = ""
	for post in posts:
		pStr += str(post) + "<br />"
	return HttpResponse(pStr)

