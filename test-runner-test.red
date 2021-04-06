Red [
	description: {Tests for the test runner}
	author: loziniak
]

tests: [
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
				test_code: {result = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world2"
		#(
			version: 2
			status: "pass"
			message: none
			tests: [#(
				name: "Say Hi!"
				status: "pass"
				message: "✓"
				output: ""
				test_code: {result = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world3"
		#(
			version: 2
			status: "error"
			message: {*** Math Error: attempt to divide by zero^/*** Where: /^/*** Stack: do-file first }
			tests: [#(
				name: "Say Hi!"
				status: "error"
				message: {*** Math Error: attempt to divide by zero^/*** Where: /^/*** Stack: do-file first }
				output: ""
				test_code: {result = "Hello, World!"}
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

foreach test tests [

	print ["^/" test/1 " ..."]

	trial: try [

		do/args %test-runner.red rejoin [
			{"} test/1 {" "test/input/" "test/output/"}
		]		;; TODO: use 'call'?

		results: load-json read %test/output/results.json
		delete %test/output/results.json

		either results = test/2 [
			print "OK"
			true
		] [
			print ["FAIL. Expected:^/" mold test/2 "^/but got:^/" mold results]
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

if pass? [print "^/ALL TESTS OK."]
