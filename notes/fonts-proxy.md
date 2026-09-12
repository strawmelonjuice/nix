This image wasn't built for ARM :c

```bash
git clone https://tangled.org/strawmelonjuice.nl/fonts
doas podman pull docker pull docker.io/erlang:28-alpine
doas podman build ./fonts --tag "docker.io/strawmelonjuice/fonts-proxy:1.1.2"
```

But now it is, locally!
