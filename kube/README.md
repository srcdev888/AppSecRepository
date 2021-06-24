# Kubenetes Notes
* Author:   Pedric Kng  
* Updated:  17 Jun 2021

This repository documents several open source cloud native security tools.

# Topics
* [Kube-hunter](#Kube-hunter)
* [Trivvy](#Trivvy)
* [Starboard](#Starboard)

***
## Kube-hunter

Example running as a pod to discover vulnerabilities in existing kubernetes cluster

```bash

# Create kube-hunter job
>> kubectl create -f https://raw.githubusercontent.com/aquasecurity/kube-hunter/main/job.yaml

# Check if job completes, find <pod-name>
>> kubectl describe job kube-hunter
>> kubectl get jobs

# View results, refer to https://avd.aquasec.com/
>> kubectl logs <pod name>

# Delete existing kube-hunter job
>> kubectl delete job kube-hunter


```


## Trivy

Trivy supports scanning via filesystem or container image, an example Gitlab pipeline is available [[7]] illustrating both techniques

- Filesystem - limited to application dependencies e.g., jar, and is not able to pick up OS
    ```yml
    filesystem_scanning:
    image:
        name: docker.io/aquasec/trivy:latest
        entrypoint: [""]
    stage: testbuild
    script:
        - trivy --version
        # cache cleanup is needed when scanning images with the same tags, it does not remove the database
        - time trivy filesystem --clear-cache
        # update vulnerabilities db
        - time trivy --download-db-only --no-progress --cache-dir .trivycache/
        # Builds report and puts it in the default workdir $CI_PROJECT_DIR, so `artifacts:` can take it from there
        - time trivy --cache-dir ".trivycache/" filesystem --exit-code 0  --no-progress --format template --template "@/contrib/gitlab.tpl"
            --output "$CI_PROJECT_DIR/gl-container-scanning-report.json" $CI_PROJECT_DIR
        # Prints full report
        - time trivy --cache-dir ".trivycache/" filesystem --exit-code 0 --no-progress $CI_PROJECT_DIR
        # Fail on critical vulnerabilities
        #- time trivy filesystem --exit-code 1 --cache-dir .trivycache/ --severity CRITICAL --no-progress $CI_PROJECT_DIR
    only:
        - master
    cache:
        paths:
        - .trivycache/
    dependencies:
        - build-maven
    # Enables https://docs.gitlab.com/ee/user/application_security/container_scanning/ (Container Scanning report is available on GitLab EE Ultimate or GitLab.com Gold)
    artifacts:
        when:                          always
        reports:
        container_scanning:          gl-container-scanning-report.json
    ```

- Container Image - can pickup both OS and application vulnerabilities
```yml
container_scanning:
  image:
    name: docker.io/aquasec/trivy:latest
    entrypoint: [""]
  stage: testpackage
  variables:
    # No need to clone the repo, we exclusively work on artifacts.  See
    # https://docs.gitlab.com/ee/ci/runners/README.html#git-strategy
    GIT_STRATEGY: none
    TRIVY_USERNAME: "$CI_REGISTRY_USER"
    TRIVY_PASSWORD: "$CI_REGISTRY_PASSWORD"
    TRIVY_AUTH_URL: "$CI_REGISTRY"
    FULL_IMAGE_NAME: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  script:
    - trivy --version
    # cache cleanup is needed when scanning images with the same tags, it does not remove the database
    - time trivy image --clear-cache
    # update vulnerabilities db
    - time trivy --download-db-only --no-progress --cache-dir .trivycache/
    # Builds report and puts it in the default workdir $CI_PROJECT_DIR, so `artifacts:` can take it from there
    - time trivy --exit-code 0 --cache-dir .trivycache/ --no-progress --format template --template "@/contrib/gitlab.tpl"
        --output "$CI_PROJECT_DIR/gl-container-scanning-report.json" "$FULL_IMAGE_NAME"
    # Prints full report
    - time trivy --exit-code 0 --cache-dir .trivycache/ --no-progress "$FULL_IMAGE_NAME"
    # Fail on critical vulnerabilities
    - time trivy --exit-code 1 --cache-dir .trivycache/ --severity CRITICAL --no-progress "$FULL_IMAGE_NAME"
  only:
    - master
  cache:
    paths:
      - .trivycache/
  # Enables https://docs.gitlab.com/ee/user/application_security/container_scanning/ (Container Scanning report is available on GitLab EE Ultimate or GitLab.com Gold)
  artifacts:
    when:                          always
    reports:
      container_scanning:          gl-container-scanning-report.json

```



## Starboard
Starboard aggregates all the cloud native tools, and unifieds the stored reports in kubernetes resources, and supports accessing it via Kubectl.
Additionally, it supports operator mode in Kubernetes whereby on pod load scans will be executed; note that this will apply for Trivvy and Polaris configuration scan only.

### Starboard Initialization
```bash
# initialize starboard
$ starboard init

# check resources created
$ kubectl api-resources --api-group aquasecurity.github.io

# Remove all resources by starboard
$ starboard cleanup

```

### Installing Starboard Operator

```bash

# Custom resource definitsions
>> kubectl apply -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/crd/vulnerabilityreports.crd.yaml \
  -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/crd/configauditreports.crd.yaml \
  -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/crd/ciskubebenchreports.crd.yaml \
  -f https://raw.githubusercontent.com/aquasecurity/starboard/main/deploy/crd/kubehunterreports.crd.yaml

# See the API resources been defined
>> kubectl api-resources --api-group aquasecurity.github.io

# Kubernetes object definitions
>> kubectl apply -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/static/01-starboard-operator.ns.yaml \
  -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/static/02-starboard-operator.sa.yaml \
  -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/static/03-starboard-operator.clusterrole.yaml \
  -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/static/04-starboard-operator.clusterrolebinding.yaml

# Create starboard-operator
>> kubectl apply -f https://raw.githubusercontent.com/aquasecurity/starboard/v0.10.3/deploy/static/06-starboard-operator.deployment.yaml

# Check if starboard-operator is up and running
>> kubectl get deployment -n starboard-operator

# debug of starboard-operator
>> kubectl logs deployment/starboard-operator -n starboard-operator

```

### Example Scenario: Workload scanning
```bash
# Create a new deployment of nginx
>> kubectl create deployment nginx --image nginx:1.16

# View all jobs of starboard-operator
>> kubectl get job -n starboard-operator

# View all scan reports affilated with ngix
>> kubectl tree deploy nginx

# Get summary report
# Trivy
>> kubectl get vulnerabilityreports -o wide
# Polaris
>> kubectl get configauditreports -o wide

# Get detailed report
# Trivy
>> kubectl starboard get vulns replicaset/nginx-6d4cf56db6 -o yaml
# Polaris
>> kubectl starboard get configaudit replicaset/nginx-6d4cf56db6 -o yaml

# Generate HTML Reports

## Deployment
>> starboard get report deployment/nginx > nginx.deploy.html
>> open nginx.deploy.html

## Node (KubeBench: CIS Benchmark)
>> kubectl tree node <nodename> -A
>> kubectl get ciskubebenchreports -o wide
>> kubectl starboard get report node/<nodename> > <nodename>.html

# Executing Kubehunter
>> kubectl starboard scan kubehunterreports
>> kubectl get kubehunter -o wide
>> kubectl get kubehunterreport -o yaml
```

### Rolling update detection
```bash
# Redeploying a new version of nginx
>> kubectl set image deployment nginx nginx=nginx:1.19
# view the additional reports
>> kubectl tree deploy nginx

# List reports
# Trivvy
>> kubectl get vulnerabilityreport replicaset-nginx-6d4cf56db6-nginx -o yaml
# Polaris
>> kubectl get configauditreport replicaset-nginx-db749865c -o yaml
```


# References
Kube-Hunter [[1]]  
Trivy [[2]]  
Starboard [[3]]  
Kube-goat [[4]]  
Kubernetes-goat [[5]]  
OWASP Kubernetes Security Cheat Sheet [[6]]  
Trivy GitLab pipeline example [[7]

[1]:https://aquasecurity.github.io/kube-hunter/ "Kube-Hunter"
[2]:https://aquasecurity.github.io/trivy "Trivy"
[3]:https://aquasecurity.github.io/starboard "Starboard" 
[4]:https://github.com/ksoclabs/kube-goat "Kube-goat"
[5]:https://madhuakula.com/kubernetes-goat/index.html "Kubernetes-goat"
[6]:https://cheatsheetseries.owasp.org/cheatsheets/Kubernetes_Security_Cheat_Sheet.html "OWASP Kubernetes Security Cheat Sheet"
[7]:https://gitlab.com/container-sec/webgoat-legacy/-/blob/master/.gitlab-ci.yml "Trivy GitLab pipeline example"