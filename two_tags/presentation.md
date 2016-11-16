theme: Titillium

# [fit] Tags, deps 
# [fit] & two smoking tests

---

# [fit] WTF?!

1. Not all packages in Go are completely crossplatform. 
1. ... even in pure Go.
1. CGO is not crossplatform.
1. Low-level packages is OS-specific.
1. No preprocessor
1. No macro

--- 

# [fit] Simple problem

```go
func main() {
	output, err := exec.Command("echo", "test").Output()
    if err != nil {
    	panic(err)
    }
    fmt.Println(string(output))
}
```

This code will fail under MS Windows because `echo` is command of `cmd.exe`

^ ```example_01_01
$ make dist
$ ./dist/example_01_01
WIN:```  

---

# Simple solution

Make two separate source files. `exec_nix.go`:

```go
// +build !windows
func execCmd(cmd string, args ...string) *exec.Cmd {
	return exec.Command(cmd, args...)
}
```

and `exec_win.go`:

```go
// +build windows
func execCmd(cmd string, args ...string) *exec.Cmd {
    return exec.Command("cmd", append([]string{"/C", cmd}, args...)...)
}
```

---

# ... and one main

```go
func main() {
	output, err := execCmd("echo", "test").Output()
    if err != nil {
    	panic(err)
    }
    fmt.Println(string(output))
}
```

Build as usual. Go will use `execCmd` from corresponding source.

^ ```example_01_02
$ make dist
$ ./dist/example_01_02
WIN:```

---

# [fit] Need more?

Common approach to logging:

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

^ ```example_02_01
$ make dist
$ ./dist/example_02_01
$ DEBUG=yes ./dist/example_02_01```

---

# [fit] Throw the trash from production![^1]

```go
// +build debug
func Debug(msg string) {
	fmt.Fprintln(os.Stderr, msg)
}

// +build !debug
func Debug(msg string) { }
```

Tags also works in tests!

[^1]: Real world example: `go get github.com/akaspin/logx`


^ ```example_02_02
$ make dist
$ ./dist/example_02_02
$ example_02_02-debug
$ make dist_m - without debug tag "Debug" function will be inlined.```

---

# Mix it up

Go using `OR` for separate lines regardless of source file.

```bash
$ GOOS=windows go build -tags debug ...
$ GOOS=windows go test -tags="debug integration" ...
```

Go uses `AND` for build tags in one line

```go
// +build windows integration anyother
```

This source will builded only under Windows with both "integration" and "anyother" tags.

---

# [fit] Dependencies

We need deps! Now!

1. Two approaches: Virtual Environments and Vendoring
1. Go packages is very special.
1. Package management is tricky.

---

# [fit] Virtual environments

1. Based on system paths. 
1. Permits to switch libraries and toolchain.
1. Great flexibility.
1. Great chance to shoot yourself in the leg.
1. VE is not a package manager.

^ examples: python virtualenv, rbenv

---

# [fit] Go already has virtual environments

1. `$GOROOT` for go toolchain and builtins.
1. `$GOBIN` for `go install`.
1. `$GOPATH` for packages.
1. Go toolchain always ignore `_*`, `.*` and `testdata` paths.

You can stack directories in `$GOPATH`.

```bash
GOPATH=/my/own/packages:$GOPATH go build ...
```

^ ```example_03_01
$ make test_fail
$ make test```

---

# [fit] Project-based environments (vendoring)

1. Based on assets inside project.
1. Permits to override libraries.
1. Not flexible.
1. Less chance to shoot yourself in the leg.

^ example: NPM

---

# [fit] Please don't vendor me!

1. All deps must be in "vendor" directory.
1. Go toolchain doesn't ignore "vendor" directory!
1. Vendor sometimes break build and test.

```
$ go test $(go list ./... | grep -v /vendor/)
cannot use &metadata.TrailerMD 
    (type *"google.golang.org/grpc/metadata".MD) 
    as type *"github.com/…/landmark/vendor/google.golang.org/grpc/metadata".MD
```

Bad news: from Go 1.6 go vendoring can't be disabled.

^ ```example_03_02
$ make test_fail - go toolchain doesn't inore vendor!
$ make test```

---

# [fit] Go packages facts

```go
import "github.com/akaspin/dummy"
```

At first sight Go package is git repo.

**But!**

1. Go package may not be subdirectories!
1. "github.com/akaspin/pkg1" and "github.com/akaspin/pkg1/sub" are completely different packages.
1. "go get" always clones "master" to current $GOPATH.

---

# [fit] Package management
  
All package management in go is just put libs to the directory! That's all! Please, please, please: no complex solutions!
  
1. Simple, stupid, tedious: git submodules (ok, pass).
1. One of hundreds: Glide, GoDep, GPM, GB (not exactly), Govendor ...

**What we need?!**

1. Just grab end put declared packages to _any_ specific directory.
1. Do not try to resolve any conflicts!
1. Remove artifacts like ".git".

---

# [fit] Common troubles

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

# [fit] And the winner is ...

---

# [fit] TRASH!

1. Simple as Go.
1. Developed by Rancher
1. Used by Docker
1. Our patches :-)

---

# [fit] Trash is beautiful

Simple `vendor.conf`:

```
github.com/applift/pump19
github.com/akaspin/logx     v6.2.0
```

and simple command:

```bash
$ trash -T _vendor/src
```

^ ```example_03_03
$ make deps
$ make test```

---

# [fit] Questions


