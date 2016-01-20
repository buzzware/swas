## Table of content

- [Introduction](#swas-static-web-application-server)
- [Setup OpenResty, Nginx, nginx-jwt In WebFaction](setup-openresty-nginx-webfaction.md)
- [Nginx start, stop and restart scripts](setup-nginx.md)
- [References](#references)

## swas (Static Web Application Server)

This is a project to provid a server tailored for "static" websites and/or
Single Page Apps (SPAs) eg. built using javascript frameworks like Ember.js,
Angular.js and/or just plain HTML/CSS/JS files.

It aims to add a few extra features over normal static hosting to create apps
more like typical server-based webapps, without requiring custom backend
development.

1. supports JSON Web Tokens for authentication ([http://jwt.io](http://jwt.io),
[watch this screencast](https://www.youtube.com/watch?v=oXxbB5kv9OA))
2. ability to require roles in the JWT payload for particular pages and/or files
3. ability to inject the decoded JWT payload into the app

It uses OpenResty, which is merely a packaging of extensions to Nginx, mainly
based on the lua extension. OpenResty provides performance far above typical
web development frameworks eg 2 X faster than Go, 4 X faster than NodeJs
(http://www.techempower.com/benchmarks/#section=data-r11&hw=peak&test=json)

## References

- [http://jwt.io](http://jwt.io)
- [JWT screencast](https://www.youtube.com/watch?v=oXxbB5kv9OA)
- [Benchmark](http://www.techempower.com/benchmarks/#section=data-r11&hw=peak&test=json)
