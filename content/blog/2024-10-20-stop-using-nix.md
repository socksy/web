+++
title = "Stop using nix"
+++
# (for your project dependencies)
At the [Heart of Clojure](https://2024.heartofclojure.eu) conference this year someone gave [a lightning talk](https://www.youtube.com/watch?v=Z_8VSnezM8g) praising the virtues of using the [nix](https://nixos.org/) package manager for declaratively and reproducibly declaring your dependencies per project.

Supposedly there were some talks that reminded the speaker of the pains he hadn't had in 6 years, since he started using nix for package management. Something that hits close to my heart, since I've been using nix and NixOS for about the same length of time.
<!-- more -->


Specifically, I've implemented shell.nix files for reproducible build environments in a professional context, and had the scripts enabled to just `direnv` my way into them. It was truly a blessing over what we had before.

### Going on
However, in the modern day, I believe there's no good reason to use nix (at least, directly) for this purpose. Amongst other reasons, it provides far too much overhead and accidental complexity to a project.

OTOH, I've seen the usage of tools like [asdf](https://asdf-vm.com/) take off for a similar purpose, but with half the smarts. In essence, it defines a bunch of shims for accessing particular tool versions, and lets you define a `.tool-versions` file that has the specific version you need for each tool - basically generalizing the concept of nvm.

IMO that's going too far in the opposite direction, making things as easy as possible whilst sacrificing reproducibility, and with half of the functionality (not to mention, a nightmare to get working on NixOS).

### Solution
For me, it's clear that [devenv](https://devenv.sh/) fits the bill in the best possible way. It's nix, but made easy, and with batteries included for almost everything you would want for a project management tool. As an example, here's my current `devenv.nix` setup[^first line] for this blog:

```nix, linenos
{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git
               pkgs.zola ];

  processes = {
    zola.exec = "zola serve";
  };
}
```

[^first line]: It was initially generated with `devenv init`, so I didn't have to write the stuff on line 1.

It does two things:
1. add the packages `git` and `zola` into my dev environment on lines 4 & 5 
2. defines a process called `zola`, that when run will call `zola serve` (the watch command for zola).

Now, when I go into a directory, I can type `devenv shell`, and immediately go into an environment where I have the exact same version of `git` and `zola` as anyone else that will run this project.

After that, I can type `devenv up`, and it will bring all processes I've defined in a nice easy to use environment.

If I want to use a programming language like Clojure, I can simply do:

```
languages.clojure.enable = true;
```

If I wanted to make sure  everyone was using the same JDK for Clojure, I could do
```
languages.java.jdk.package = pkgs.jdk22;
```

### Services
Additionally, a common thing to want is to have a developer database running in the background for your app to connect to. Traditionally when setting this up in companies, I've used a docker-compose file. It would probably look something like this:
[^security]

```yaml
services:
  postgres:
    image: postgres:17-alpine
    ports:
      - 5432:5432
    volumes:
      - /tmp/my-app/postgres:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_USER=postgres
      - POSTGRES_DB=my-app-db
```

[^security]: btw, if you run this on Linux you should be careful - docker registers its own iptables stuffs and so doing this can be enough to open up your postgres firewall free to the world... ask me how I know

Firstly, you have to run an entire distribution just to run the DB. If you're on macOS, you have to run an entire *Linux Virtual Machine* just to run the DB! 

Then, if you have decided that for reproducibility your app will also be in a docker container, now you have to link them up in a network. And obviously, punch a hole through for your REPL connections (have fun with those websockets if you're doing CLJS).

Most likely, you'll have to have two stages for someone using the project for the first time. They have to install all the dependencies, however you've decided to do that.[^brew] Then you need to have a way to start the docker containers, and if you script it together, make sure you wait until all the dependency services are running until you connect your dev project.

[^brew]: more often than not I've just seen a list of things to `brew install`...

So how do we solve this in devenv land? Here:

```nix
services.postgres = {
  enable = true;
  initialDatabases = [
    {
      name = "my-app-db";
      pass = "p4ssw0rd";
    }
  ];
  listen_addresses = "127.0.0.1";
};
```

This will run the next time you use `devenv up`, and it will automatically install `psql` locally for you to be able to connect. With a quick

```
> psql my-app-db
```

you're in.

### Devenv
Obviously, if you had to do `devenv shell` every time you wanted to use tools for the build environment that'd be annoying. Not least, because it would start a new shell which might differ from your favourite shell. Luckily, `devenv init` automatically generates an `.envrc` file for you. If you have `direnv` installed, it's simply a matter of doing `direnv allow .`, and then every time you `cd` into this repository, you'll have the correct tools to hand. No extra config to setup, nothing extra to install. Neat!

### Conclusion
This is all powered by nix, and nix flakes, under the hood - but you are protected from all that. Even if you personally know nix well, your teammate doesn't have to to be able to contribute to this file. And you're guaranteed that everyone will be on exactly the same page - something that is much harder to achieve with say, docker.

There's a lot more that it can do that I haven't covered, including pre-commit hooks, common scripts, dependencies between processes using tasks, and even building the dev environment as a docker container that you can publish to ghcr.io. But even the basics bring a lot of value to the table, imo.

### P.S.
If you're in the Clojure world, you might be aware of a cool new Clojure development environment tool `launchpad`, and you might be wondering how this would fit in with that. I think the two tools go together swell, in a way that I wish I had in previous work environments.

Here's a common `devenv.nix` I've been adding to my Clojure projects:

```nix
{ pkgs, ... }: {
  packages = [ pkgs.figlet
               pkgs.lolcat
               pkgs.babashka
               pkgs.cljfmt
               pkgs.clojure-lsp];
  languages.clojure.enable = true;

  enterShell = ''
    figlet -f small -k "Clojure Devenv" | lolcat -F 0.5 -ad 1 -s 30
    export PATH=$PWD/bin:$PATH
  '';
  processes = {
    launchpad.exec = "bin/launchpad";
    kaocha.exec = "bin/kaocha --watch";
  };
}
```

This set up pretty much everything I need (outside of external services and deploying etc). We've added babashka as it's needed for launchpad (and because it's awesome to script in), cljfmt as a useful formatter, and clojure-lsp for the useful emacs tooling. 

And obviously it's very important for every project to have `lolcat` installed to make it obvious when you're in the devenv or not.

We have two processes that will start with `devenv up` - one that is running launchpad, and one that is running the projects' kaocha tests. This way you are able to have both TDD style auto-testing feedback, and also connect to the Clojure REPL for development with no extra setup.

One, potentially less obvious benefit of this setup is allowing a way for every dev to benefit from dev tooling setup, while still giving them the option to override where necessary. 

### P.S. P.S.
One problem I had at my previous role was dealing with nREPL middleware. With a lot of Clojure devs in one shop, you get a lot of people using different editors, and different versions of the same editor. A lot of these can depend on various nREPL middlewares to be able to connect to the dev project.

One thing that's not so easy, is setting this up in a way that is foolproof for someone getting onboarded, without clobbering everyone else's setup. 

One particular recurring issue we would have is that at some point, someone would realize that the reason why their editor env wasn't autocompleting or what-not was because they were missing a certain cider-nrepl package. They would notice the warning telling them to add XYZ package, so they'd add XYZ to the project `:dev` profile with version 0.10.0. Now, half the devs were using an editor that can only support version 0.9.0, and they had added it via their `~/.clojure/deps.edn`. Even when using `:default-deps`, this would be a problem - the merging rules for `:default-deps` by default always takes the highest version number.

In the end, I wrote a hacky script that wrote some state in a `.gitignore`d file in order to ascertain whether a user already had a this middleware added via their `~/.clojure/deps.edn`. Which was crappy and I hated it[^codereviewers].

[^codereviewers]: Also the code reviewers hated it. But they couldn't come up with a better solution at the time.

The new, better solution is to create a `deps.local.edn` which can be `.gitignore`d and different per developer, and put something like the following in it:

```clojure
{
  :launchpad/main-opts ["--emacs"]
}
```

OK for emacs that's cheating since it's all so built in. But it's so nice! It includes the `cider-nrepl` middleware (whichever one your emacs needs!), the `refactor-nrepl` middleware, and then for good measure it will automatically connect your emacs to the nREPL using cider. 

So when I run `devenv up`, not only do I get tests and a developer environment running, but my emacs immediately connects to everything and I'm ready to go. Smooth. Thanks Arne!
