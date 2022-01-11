package test

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestHttpFunction(t *testing.T) {
	t.Parallel()

	var moduleName = "http_function"
	// Creates a temp folder for the module to test
	testFolder := test_structure.CopyTerraformFolderToTemp(t, "../", moduleName)

	// Destroy the created resources after running the tests
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, testFolder)
		terraform.Destroy(t, terraformOptions)
	})

	path, err := os.Getwd()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
	}
	fmt.Println(path)

	test_structure.RunTestStage(t, "setup", func() {
		// Add the provider.tf to the test path
		CopyFile(t, "../../provider.tf", filepath.Join(testFolder, "provider.tf"))

		// Copy the function source to the source_path
		source_path := filepath.Join(testFolder, "src")
		MkdirAll(t, source_path)
		CopyFile(t, "./test_source/http_function.js", filepath.Join(source_path, "index.js"))

		terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
			TerraformDir: testFolder,

			// Set a unique prefix
			BackendConfig: map[string]interface{}{
				"prefix": "/terratest/" + moduleName,
			},

			// Set variables needed by the module
			Vars: map[string]interface{}{
				"project":              "serverless-labs-328806",
				"function_name":        "terratest_http_function",
				"function_entry_point": "helloWorld",
				"source_path":          "http_function/src",
			},

			NoColor: true,
		})
		test_structure.SaveTerraformOptions(t, testFolder, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "Should deploy function with trigger url", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, testFolder)

		httpsTriggerUrl := terraform.Output(t, terraformOptions, "https_trigger_url")

		assert.Equal(t, "https://europe-west1-serverless-labs-328806.cloudfunctions.net/terratest_http_function", httpsTriggerUrl, "https_trigger_url")
	})
}

func CopyFile(t *testing.T, source string, destination string) {
	if err := files.CopyFile(source, destination); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	logger.Logf(t, "Copied '%s' to '%s'", source, destination)

}
func MkdirAll(t *testing.T, path string) {
	if err := os.MkdirAll(path, 0700); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	logger.Logf(t, "Created folder '%s'", path)
}
