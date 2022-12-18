Red [
	description: {Red language track test runner for Exercism}
	author: loziniak
]


test-runner: context [

	args: load replace/all system/script/args #"'" #"^""

	slug: args/1

	input-dir: dirize to-red-file args/2
	test-file: to file! rejoin [slug "-test.red"]

	results-dir: dirize to-red-file args/3


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

	exercism-results: copy/deep results-template


	run-test: does [
		old-dir: to file! get-current-dir
		system/words/test-results: try [
			change-dir input-dir
			code: load test-file
			remove find/last/only code 'test-results/print
			if find code compose [(to issue! 'include) %testlib.red] [
				do %testlib.red
			]
			replace code [test-init/limit] [test-init]
			bind code system/words
			do code
			system/words/test-results
		]
		change-dir old-dir
	]

	exercism-results-from: function [
		results [block! error!]
	] [
		either error? results [
			exercism-results/status: 'error
			exercism-results/message: form results
		] [
			foreach result results [
				if 'ignored = result/status [
					continue
				]

				test: copy/deep test-template

				either find result/summary "   task_id:" [
					set [summary task-id] split result/summary "   task_id:"
					test/name: summary
					test/task_id: load task-id
				] [
					test/name: result/summary
				]
				
				test/output: result/output
				test/test_code: either find result 'test-code [
					mold result/test-code
				] [
					rejoin ["solution = " mold result/expected]
				]
			
				test/message: switch/default result/status [
					error [
						exercism-results/message: form result/actual
					]
					fail [
						rejoin [
							{FAILED.}
							either find result 'expected [rejoin [
								{ Expected: } mold result/expected
								either find result 'actual [rejoin [
									{, but got } mold result/actual
								]] []
							]] []
						]
					]
				] [
					"✓" ;'pass
				]

				exercism-results/status: switch/default result/status [
					pass [exercism-results/status]					; change nothing
					fail ['fail]
					error ['fail]
				] [
					do make error! rejoin ["Unexpected status: " result/status]
				]

				test/status: result/status
				
				append exercism-results/tests test
			]
		]
	]

	save-exercism-results: does [
		save/as rejoin [
			results-dir
			%results.json
		] exercism-results 'json
	]
]

test-runner/run-test
test-runner/exercism-results-from test-results
test-runner/save-exercism-results
