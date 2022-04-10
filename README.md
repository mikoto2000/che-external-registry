# che-external-registry

[https://che-external-registry.herokuapp.com/index.html](https://che-external-registry.herokuapp.com/index.html)


## Development:

```sh
docker run -it --rm --name cer -v "$(pwd):/work" --workdir /work -v "$HOME/.m2:/root/.m2" -v "/var/run/docker.sock:/var/run/docker.sock" -p "8080:8080" mikoto2000/che-external-registry-buildkit:latest
```

License:
--------

Copyright (C) 2022 mikoto2000

This software is released under the MIT License, see LICENSE

このソフトウェアは MIT ライセンスの下で公開されています。 LICENSE を参照してください。


Author:
-------

mikoto2000 <mikoto2000@gmail.com>


