Red [
	description: {Red language track test runner for Exercism}
	author: loziniak
]

args: load system/script/args

slug: args/1

input-dir: to-red-file args/2
answer-file: input-dir/(rejoin [slug ".red"])
test-file: input-dir/(rejoin [slug "-test.red"])

results-template: make map! compose [
	version: 2
	status: pass		; pass / fail / error
	message: (none)		; only when there is error
	tests: []			; tests results, see 'test-template
]

test-template: make map! compose [
	name: ""
	status: pass		; pass / fail / error
	message: (none)
	output: ""			; console output from user's script's
	test_code: ""		; what was tested
]

results: copy results-template

if error? err: try [
	test-file: load test-file
	cases: test-file/canonical-cases
] [
	results/status: 'error
	results/message: form err
	cases: copy []
]

foreach test-case cases [

	output: copy ""

	old-print: :print
	old-probe: :probe
	old-prin: :prin

	prin: function [value] [
		append output form value
	]

	print: function [value] [
		append output reduce [form value #"^/"]
	]

	probe: function [value] [
		append output reduce [mold value #"^/"]
	]

	result: none
	err: try [

		result: do
			to file! answer-file

		if function? :result [
			result: result			; execute function
		]

	]

	prin: :old-prin
	probe: :old-probe
	print: :old-print


	case-result: copy test-template
	case-result/name: test-case/description
	case-result/test_code: rejoin ["result = " mold test-case/expected]
	case-result/output: output

	case [
		error? err [
			results/status: case-result/status: 'error
			results/message: case-result/message: form err
		]
		result <> test-case/expected [		; test_code
			results/status: case-result/status: 'fail
			case-result/message:
				rejoin [{FAILED. Expected: "} test-case/expected {", but got "} result {"}]
		]
		'else [
			case-result/message: "✓"
		]
	]

	append results/tests case-result
]

save/as rejoin [
	to-red-file args/3
	%results.json
] results 'json
