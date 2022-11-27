Red [
	description: {Tests for the test runner}
	author: loziniak
]

metatests: [
	[
		"hello-world"
		%test/input/
		%test/output/
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
		%test/input/
		%test/output/
		#(
			version: 2
			status: "fail"
			message: none
			tests: [#(
				name: "Say Hi!"
				status: "pass"
				message: "✓"
				output: {"debug"^/debugging^/"INTERNAL_OUTPUT"^/}
				test_code: {solution = "Hello, Universe!"}
			) #(
				name: "Say Hi!"
				status: "fail"
				message: {FAILED. Expected: "Hello, World!", but got "Hello, Universe!"}
				output: {"debug"^/debugging^/"INTERNAL_OUTPUT"^/}
				test_code: {solution = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world3"
		%test/input/
		%test/output/
		#(
			version: 2
			status: "error"
			message: {*** Math Error: attempt to divide by zero^/*** Where: do^/*** Near : print 1 / 0 "Hello, Universe!"^/*** Stack: do-file exercism-results-from first expect hello }
			tests: [#(
				name: "Say Hi!"
				status: "error"
				message: {*** Math Error: attempt to divide by zero^/*** Where: do^/*** Near : print 1 / 0 "Hello, Universe!"^/*** Stack: do-file exercism-results-from first expect hello }
				output: ""
				test_code: {solution = "Hello, World!"}
			)]
		)
	]
	[
		"hello-world4"
		%test/input/
		%test/output/
		#(
			version: 2
			status: "error"
			message: {*** Access Error: cannot open: %hello-world4-test.red^/*** Where: read^/*** Near : code: load test-file remove find/last/only ^/*** Stack: do-file exercism-results-from }
			tests: []
		)
	]
	[
		"hello-world5"
		%test/input/
		%test/output/
		#(
		    version: 2
		    status: "error"
		    message: {*** Script Error: output has no value^/*** Where: append^/*** Near : reduce [form :value #"^^/"] return ()^/*** Stack: do-file exercism-results-from first expect hello }
		    tests: [#(
		        name: "Say Hi!"
		        status: "error"
		        message: {*** Script Error: output has no value^/*** Where: append^/*** Near : reduce [form :value #"^^/"] return ()^/*** Stack: do-file exercism-results-from first expect hello }
		        output: "debugging^/"
		        test_code: {solution = "Hello, World!"}
		    )]
		)
	]
	[
		"hello-world6"
		;-- trailing slashes omitted intentionally, as this is what's being tested:
		%test/input
		%test/output
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

]


pass?: true

foreach metatest metatests [

	print ["^/" metatest/1 " ..."]

	trial: try [

		do/args %test-runner.red rejoin [
			{"} metatest/1 {" "} metatest/2 {" "} metatest/3 {"}
		]		;; TODO: use 'call'?

		results: load-json read %test/output/results.json
		delete %test/output/results.json

		either results = metatest/4 [
			print "OK"
			true
		] [
			print ["FAIL. Expected:^/" mold metatest/4 "^/but got:^/" mold results]
			false
		]
	]

	if error? trial [
		print trial
		pass?: false
	]

	pass?: all [
		pass?
		trial
	]

	unset 'results

	unless pass? [break]
]

either pass? [
	print "^/ALL TESTS OK."
] [
	quit/return 1		; TODO: https://github.com/red/red/issues/4095
]
