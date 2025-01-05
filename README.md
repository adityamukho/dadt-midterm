To build and run the app, execute:

```bash
$ ./scripts/start.sh
```

This checks for a suitable node version in $PATH, and downloads one if required.

It then builds the app, which works fine when you have write access to the project folder, but will fail in a read-only environment (such as the shared lab instance). This is ok, however, since the shared lab instance already has a production build bundled.

Finally, it launches the server on the production build.

In case the lab doesn't work, a live version of the app is deployed at https://dadt.adityamukho.com/
