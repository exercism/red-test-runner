Red [
	description: {Tests for "Hello World" Exercism exercise}
	author: "loziniak"
]

#include %testlib.red

test-init/limit %hello-world3.red 1

canonical-cases: [#[
    description: "Say Hi!"
    input: #[]
    expected: "Hello, World!"
    function: "hello"
    uuid: "af9ffe10-dc13-42d8-a742-e7bdafac449d"
]]


foreach c-case canonical-cases [
	case-code: reduce [
		'expect c-case/expected compose [
			(to word! c-case/function) (values-of c-case/input)
		] 
	]

	test c-case/description case-code
]

test-results/print
