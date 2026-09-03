# Errors
## Page sizes
Conduwuity uses a dependency that'll try things and will be mad about the custom page size, so go to the /boot/firmware/config.txt file and set:

```
kernel=kernel8.img
```

## Federation

`server-net` blocks (parts of) federation, so this container has been moved out of it and is contacted over it's own port by Caddy.
