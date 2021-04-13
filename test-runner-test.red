Red [
	description: {Tests for the test runner}
	author: loziniak
]

metatests: [
	[
		"hello-world"
		#(
			version: 2
			status: "fail"
			message: none
			tests: [#(
				name: "Say Hi!"
				status: "fail"
				message: {FAILED. Expected: "Hello, World!", but got "Hello, Universe!"}
				output: {"debug"^/debugging^/}
				test_code: {solution = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world2"
		#(
			version: 2
			status: "fail"
			message: none
			tests: [#(
				name: "Say Hi!"
				status: "pass"
				message: "✓"
				output: {"debug"^/debugging^/}
				test_code: {solution = "Hello, Universe!"}
			) #(
				name: "Say Hi!"
				status: "fail"
				message: {FAILED. Expected: "Hello, World!", but got "Hello, Universe!"}
				output: {"debug"^/debugging^/}
				test_code: {solution = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world3"
		#(
			version: 2
			status: "error"
			message: {*** Math Error: attempt to divide by zero^/*** Where: /^/*** Stack: do-file error? first }
			tests: [#(
				name: "Say Hi!"
				status: "error"
				message: {*** Math Error: attempt to divide by zero^/*** Where: /^/*** Stack: do-file error? first }
				output: ""
				test_code: {solution = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world4"
		#(
			version: 2
			status: "error"
			message: {*** Access Error: cannot open: %test/input/hello-world4-test.red^/*** Where: read^/*** Stack: do-file load }
			tests: []
		)
	]
]


pass?: true

foreach metatest metatests [

	print ["^/" metatest/1 " ..."]

	trial: try [

		do/args %test-runner.red rejoin [
			{"} metatest/1 {" "test/input/" "test/output/"}
		]		;; TODO: use 'call'?

		results: load-json read %test/output/results.json
		delete %test/output/results.json

		either results = metatest/2 [
			print "OK"
			true
		] [
			print ["FAIL. Expected:^/" mold metatest/2 "^/but got:^/" mold results]
			false
		]
	]

	if error? trial [
		print trial
	]

	pass?: all [
		pass?
		trial
		not error? trial
	]

	unless pass? [break]
]

either pass? [
	print "^/ALL TESTS OK."
] [
	quit/return 1		; TODO: https://github.com/red/red/issues/4095
]
