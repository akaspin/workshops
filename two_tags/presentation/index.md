---
layout: default
title: Default Presentation

---

class: middle, center

# Tags, deps and two smoking builds

---

class: middle, center

# Tags

---

# WTF?!

1. Not all packages in Go are completely crossplatform. 
1. ... even in pure Go.
1. CGO is not crossplatform.
1. Low-level packages is OS-specific.
1. No preprocessor
1. No macro

---

# Simple problem

Let's try to run OS-specific command.

```go
func main() {
*   output, err := exec.Command("echo", "test").Output()
    if err != nil {
    	panic(err)
    }
    fmt.Println(string(output))
}
```

This code will fail under MS Windows because `echo` is command of `cmd.exe`.

???
```
example_01_01
$ make dist
$ ./dist/example_01_01
```

---

# Simple solution

Make two separate source files. `exec_nix.go`:

```go
*// +build !windows
func execCmd(cmd string, args ...string) *exec.Cmd {
	return exec.Command(cmd, args...)
}
```

and `exec_win.go`:

```go
*// +build windows
func execCmd(cmd string, args ...string) *exec.Cmd {
    return exec.Command("cmd", append([]string{"/C", cmd}, args...)...)
}
```

---

# ... and one main.go

```go
func main() {
*	output, err := execCmd("echo", "test").Output()
    if err != nil {
    	panic(err)
    }
    fmt.Println(string(output))
}
```

Build as usual. Go will use `execCmd` from corresponding source.

???
```
example_01_02
$ make dist
$ ./dist/example_01_02
```
You can also use file postfix for builtin tags. But it's not flexible.

---

# Need more?

Let's implement logging:

```go
func Debug(msg string) {
    if needDebug {
        fmt.Fprintln(os.Stderr, msg)
    }
}
```

1. This means a lot of `if` calls on *each* Debug call.
1. Complex logic.
1. Complex app configuration.

???
```
example_02_01
$ make dist
$ ./dist/example_02_01
$ DEBUG=yes ./dist/example_02_01
```

---

# Throw the trash from production!

```go
*// +build debug
func Debug(msg string) {
	fmt.Fprintln(os.Stderr, msg)
}
```

```go
*// +build !debug
func Debug(msg string) { }
```

Tags also works in tests!

???
```example_02_02
$ make dist
$ ./dist/example_02_02
$ example_02_02-debug
$ make dist_m - without debug tag "Debug" function will be inlined.
```

---

# Mix it up

Go using `OR` for separate lines regardless of source file.

```bash
$ GOOS=windows go build -tags debug ...
```

???
```
example_02_03
$ make dist

```

---

class: middle, center

# Dependencies

---

# Two approaches

1. Virtual Environments 
1. Vendoring

Of course. You can use both.

---

# Virtual environments

1. Based on system paths. 
1. Permits to switch libraries and toolchain.
1. Great flexibility.
1. Great chance to shoot yourself in the leg.
1. VE is not a package manager.

???
examples: python virtualenv, rbenv

---

# Project-based environments (vendoring)

1. Based on assets inside project.
1. Permits to override libraries.
1. Not flexible.
1. Less chance to shoot yourself in the leg.
1. Vendoring is not a package manager.

???
example: NPM, vendor

---

# Go packages facts

```go
import (
    "github.com/akaspin/dummy"
    "github.com/akaspin/dummy/sub"
    "github.com/akaspin/dummy/sub/dummy"
)
```

At first sight Go package is git repo.

**But!**

1. Go package may not be subdirectories!
1. `dummy` and `dummy/sub` are not related.
1. `dummy` and `dummy/sub/dummy` are completely different packages.

---

# Go and Virtual environments

1. `$GOROOT` for go toolchain and builtins.
1. `$GOBIN` for `go install`.
1. `$GOPATH` for packages.
1. Go toolchain always ignore `_*`, `.*` and `testdata` paths.

You can stack directories in `$GOPATH`.

```bash
GOPATH=/my/own/packages:$GOPATH go build ...
```

???
```
example_03_01
$ make test_fail
$ make test
```

---

# Vendoring pitfalls

1. All deps must be in "vendor" directory.
1. Go toolchain newer ignore "vendor" directory!
1. Vendor sometimes break build and test.

```bash
$ go test $(go list ./... | grep -v /vendor/)
cannot use &metadata.TrailerMD 
    (type *"google.golang.org/grpc/metadata".MD) 
    as type *"github.com/…/landmark/vendor/google.golang.org/grpc/metadata".MD
```

Bad news: from Go 1.6 go vendoring can't be disabled.

???
```
example_03_02
$ make test_fail - go toolchain doesn't ignore vendor!
$ make test
```

---

# When vendor is good?

```bash
$ go get -v github.com/package/with-a-lot-of-deps
```

1. Go searches for all dependencies and installs all of them! With `vendor` you can avoid this.

???
```
Example: terraform
```

---

# Dependency management tools

1. Simple, stupid, tedious: git submodules (ok, pass it).
1. One of hundreds: Glide, GoDep, GPM, GB (not exactly), Govendor ...
1. Chaos

---

# Common troubles

1. Most tools deploy packages only in "vendor" directory. 
1. Some tools wan't remove artifacts (gvt).
1. Go code analysis requires run from root of package.
1. Because Go packages is "very special" resolve version conflicts isn't good idea.

```
[INFO]  --> Exporting gopkg.in/yaml.v2
[INFO]  Replacing existing vendor dependencies
[ERROR] Failed to generate lock file: Generating lock produced conflicting
    versions of github.com/prometheus/client_model. import (), testImport
    (fa8ad6fec33561be4280a8f0514318c79d7f6cb6)
```

---

# What we need?
  
1. Just grab end put declared packages to _any_ specific directory.
1. Do not try to resolve any conflicts!
1. Remove artifacts like ".git" and "*_test.go".

That's all! Please, please, please: no complex solutions!

---

class: middle, center

# And the winner is ...

---

class: middle, center

# TRASH!

Simple as Go. Developed by Rancher. Used by Docker. 

Our patches :-)

---

# Trash is beautiful

Simple `vendor.conf`:

```ini
github.com/applift/pump19
github.com/akaspin/logx     v6.2.0
```

and simple command:

```bash
$ trash -T _vendor/src
```

???
```
example_03_03
$ make deps
$ make test
You can use vendor
```

---

class: middle, center

# Questions
