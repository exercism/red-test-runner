Red [
	description: {Tests for "Hello World" Exercism exercise}
	author: "loziniak"
]

#include %testlib.red

test-init/limit %hello-world6.red 2

canonical-cases: [#(
    description: "Say Hi!"
    input: #()
    expected: "Hello, World!"
    function: "hello"
    uuid: "af9ffe10-dc13-42d8-a742-e7bdafac449d"
) #(
    description: "Say Hi!"
    input: #()
    expected: "Hello, Universe!"
    function: "hello"
    uuid: "5bd9ba26-2a3a-4509-80c4-40dd7bda93fa"
)]


foreach c-case canonical-cases [
	case-code: reduce [
		'expect c-case/expected compose [
			(to word! c-case/function) (values-of c-case/input)
		] 
	]

	test c-case/description case-code
]

test-results/print
