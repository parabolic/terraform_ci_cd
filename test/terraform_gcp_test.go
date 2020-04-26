package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformGcp(t *testing.T) {
	t.Parallel()

	environment := "ci"
	instanceNumber := 3
	name := "terratest"
	environmentName := fmt.Sprintf("%s-%s", name, environment)
	projectID := gcp.GetGoogleProjectIDFromEnvVar(t)
	randomRegion := gcp.GetRandomRegion(t, projectID, nil, nil)
	randomZone := gcp.GetRandomZoneForRegion(t, projectID, randomRegion)
	// Relative path to the terraform configuration
	terraformDir := "../example/"

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{}{
			"environment":     environment,
			"instance_number": instanceNumber,
			"name":            name,
			"project_id":      projectID,
			"region":          randomRegion,
			"zone":            randomZone,
		},

		EnvVars: map[string]string{
			"GOOGLE_CLOUD_PROJECT": projectID,
		},
	}

	// Destroy all resources in any exit case
	defer terraform.Destroy(t, terraformOptions)

	// Run terraform init and apply
	terraform.InitAndApply(t, terraformOptions)

	// Check if the bucket exists
	gcp.AssertStorageBucketExists(t, environmentName)

	// Get the instance group name from the output
	instanceGroupName := terraform.Output(t, terraformOptions, "instance_group_name")

	// Get the instance group
	instanceGroup := gcp.FetchZonalInstanceGroup(t, projectID, randomZone, instanceGroupName)

	maxRetries := 40
	sleepBetweenRetries := 2 * time.Second

	// Check the instance number
	retry.DoWithRetry(t, "Geting instances from, instance group", maxRetries, sleepBetweenRetries, func() (string, error) {
		instances, err := instanceGroup.GetInstancesE(t, projectID)
		if err != nil {
			return "", fmt.Errorf("Failed to get Instances: %s", err)
		}

		if len(instances) != instanceNumber {
			return "", fmt.Errorf("Expected to find exactly %d Compute Instances in Instance Group but found %d.", instanceNumber, len(instances))
		}
		return "", nil
	})
}
