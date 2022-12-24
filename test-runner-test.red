Red [
	description: {Tests for the test runner}
	author: loziniak
]

metatests: [
	[	;-- Test report structure and proper output interception
		"hello-world"
		%test/input/
		%test/output/
		#(
			version: 3
			status: "fail"
			message: #[none]
			tests: [#(
				name: "Say Hi!"
				status: "fail"
				message: {FAILED. Expected: "Hello, World!", but got "Hello, Universe!"}
				output: {"debug"^/debugging^/}
				test_code: {[expect "Hello, World!" [hello]]}
			) #(
				name: "Say Hi!"
				status: "pass"
				message: #[none]
				output: {"debug"^/debugging^/}
				test_code: {[expect "Hello, Universe!" [hello]]}
			)]
		)
	]
	[	;-- Test output leakage and task IDs
		"hello-world2"
		%test/input/
		%test/output/
		#(
			version: 3
			status: "fail"
			message: #[none]
			tests: [#(
				name: "Say Hi!"
				status: "pass"
				message: #[none]
				output: {"debug"^/debugging^/"INTERNAL_OUTPUT"^/}
				test_code: {[expect "Hello, Universe!" [hello]]}
				task_id: 1
			) #(
				name: "Say Hi!"
				status: "fail"
				message: {FAILED. Expected: "Hello, World!", but got "Hello, Universe!"}
				output: {"debug"^/debugging^/"INTERNAL_OUTPUT"^/}
				test_code: {[expect "Hello, World!" [hello]]}
				task_id: 2
			)]
		)
	]
	[	;-- Test solution errors interception and reporting
		"hello-world3"
		%test/input/
		%test/output/
		#(
			version: 3
			status: "fail"
			message: #[none]
			tests: [#(
				name: "Say Hi!"
				status: "error"
				message: {*** Math Error: attempt to divide by zero^/*** Where: do^/*** Near : print 1 / 0 "Hello, Universe!"^/*** Stack: do-file exercism-results-from last expect hello }
				output: #[none]
				test_code: {[expect "Hello, World!" [hello]]}
			)]
		)
	]
	[	;-- Test missing test files and, test framework errors reporting in general
		"hello-world4"
		%test/input/
		%test/output/
		#(
			version: 3
			status: "error"
			message: {*** Access Error: cannot open: %hello-world4-test.red^/*** Where: read^/*** Near : code: load test-file remove find/last/only ^/*** Stack: do-file exercism-results-from }
			tests: []
		)
	]
	[	;-- Test output leakage and error reporting
		"hello-world5"
		%test/input/
		%test/output/
		#(
			version: 3
			status: "fail"
			message: #[none]
			tests: [#(
				name: "Say Hi!"
				status: "error"
				message: {*** Script Error: output has no value^/*** Where: append^/*** Near : reduce [form :value #"^^/"] return ()^/*** Stack: do-file exercism-results-from last expect hello }
				output: "debugging^/"
				test_code: {[expect "Hello, World!" [hello]]}
			) #(
				name: "Say Hi!"
				status: "error"
				message: {*** Script Error: output has no value^/*** Where: append^/*** Near : reduce [form :value #"^^/"] return ()^/*** Stack: do-file exercism-results-from last expect hello }
				output: "debugging^/"
				test_code: {[expect "Hello, Universe!" [hello]]}
			)]
		)
	]
	[	;-- Test if test runner accepts paths without trailing slashes as well
		"hello-world6"
		%test/input 	;-- trailing slashes omitted intentionally, as this is what's being tested
		%test/output	;-- trailing slashes omitted intentionally, as this is what's being tested
		#(
			version: 3
			status: "fail"
			message: #[none]
			tests: [#(
				name: "Say Hi!"
				status: "fail"
				message: {FAILED. Expected: "Hello, World!", but got "Hello, Universe!"}
				output: {"debug"^/debugging^/}
				test_code: {[expect "Hello, World!" [hello]]}
			) #(
				name: "Say Hi!"
				status: "pass"
				message: #[none]
				output: {"debug"^/debugging^/}
				test_code: {[expect "Hello, Universe!" [hello]]}
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
]

either pass? [
	print "^/ALL TESTS OK."
] [
	quit/return 1		; TODO: https://github.com/red/red/issues/4095
]
