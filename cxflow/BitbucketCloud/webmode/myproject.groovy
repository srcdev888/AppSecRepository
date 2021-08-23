import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking 'request' object for details and determine if scan is applicable for this branch (target or current)")

String branch = request.getBranch();
String projectRepo = request.getRepoName();
String targetBranch = request.getMergeTargetBranch();

String projectName = "";
if(targetBranch != null && !targetBranch.isEmpty())
{
	// Pull merge, use a single project
	projectName = "${projectRepo}-PR";
}
else
{
	if(branch.equalsIgnoreCase("master") || branch.equalsIgnoreCase("main")){
		// Push
		projectName = "${projectRepo}";
	}else{
		projectName = "${projectRepo}-${branch}"
	}
};

println("This is the project name: " + projectName);

println("-------- Groovy script execution ended -------------");

return projectName;