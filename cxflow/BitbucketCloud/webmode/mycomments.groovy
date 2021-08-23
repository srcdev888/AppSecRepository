import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

String branch = request.getBranch();
String targetBranch = request.getMergeTargetBranch();

String comment = "";
if(targetBranch != null && !targetBranch.isEmpty())
{
    println("This is a pull merge")
    comment = "Merge: ${branch} -> ${targetBranch}";
}
else
{
    println("This is a push")
    comment = "Push: ${branch}";
};

return comment;