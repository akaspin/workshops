package main


func main() {
	output, err := execCmd("echo", "test").Output()
	if err != nil {
		panic(err)
	}
	Debug(string(output))
}
