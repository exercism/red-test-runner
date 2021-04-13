Red [
	description: {Red language track test runner for Exercism}
	author: loziniak
]

args: load system/script/args

slug: args/1

input-dir: to-red-file args/2
answer-file: input-dir/(rejoin [slug ".red"])
test-file: input-dir/(rejoin [slug "-test.red"])

results-dir: to-red-file args/3


results-template: make map! [
	version: 2
	status: pass		; pass / fail / error
	message: #[none]	; only when there is error
	tests: []			; tests results, see 'test-template
]

test-template: make map! [
	name: ""
	status: pass		; pass / fail / error
	message: #[none]
	output: ""			; console output from user's script's
	test_code: ""		; what was tested
]

results: copy/deep results-template


output: copy ""

override-console: function [output [string!]] [
	old-functions: reduce [:prin :print :probe]

	system/words/prin: function [value [any-type!]] [
		append system/words/output form :value
		return ()
	]
	system/words/print: function [value [any-type!]] [
		append system/words/output reduce [form :value #"^/"]
		return ()
	]
	system/words/probe: function [value [any-type!]] [
		append system/words/output reduce [mold :value #"^/"]
		return :value
	]
	return old-functions
]

restore-console: function [old-functions [block!]] [
	system/words/prin: :old-functions/1
	system/words/print: :old-functions/2
	system/words/probe: :old-functions/3
]


if error? runner-err: try [

	test-file: load test-file
	canonical-cases: test-file/canonical-cases

	foreach testcase canonical-cases [

		clear output

		old-functions: override-console output

		solution: none
		testcase-err: try [

			solution: do
				to file! answer-file

			if function? :solution [
				solution: solution			; execute function
			]

		]

		restore-console old-functions

		test: copy/deep test-template
		test/name: testcase/description
		test/test_code: rejoin ["solution = " mold testcase/expected]
		test/output: output

		case [
			error? testcase-err [
				results/status: test/status: 'error
				results/message: test/message: form testcase-err
			]
			solution <> testcase/expected [		; test_code
				results/status: test/status: 'fail
				test/message:
					rejoin [{FAILED. Expected: "} testcase/expected {", but got "} solution {"}]
			]
			'else [
				test/message: "✓"
			]
		]

		append results/tests test

		if results/status <> 'pass [
			break
		]
	]

	'no-error
] [
	results/status: 'error
	results/message: form runner-err
]


save/as rejoin [
	results-dir
	%results.json
] results 'json
