# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Install Script for Turbonomics
#
# V1.0 
#
# ©2020 nikh@ch.ibm.com
#
# https://cloud.ibm.com/docs/cloud-pak-multicloud-management?topic=cloud-pak-multicloud-management-cf-getting-started
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

source ./99_config-global.sh

#set -eo pipefail
#trap "echo '${RED} Installation failed in $0${NC}'" ERR

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"



headerModuleFileBegin "Install Turbonomics" $0
          



# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# INSTALL CHECKS
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
header3Begin "Install Checks"
        getClusterFQDN

header3End



# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Define some Stuff
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
header3Begin "Define some Stuff" "rocket"

        getInstallPath



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# CONFIG SUMMARY
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
__output " ${GREEN} Infrastructure Management will be installed into Cluster ${ORANGE}'$CLUSTER_NAME'${NC}"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output " ${PURPLE}Your configuration${NC}"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "    ${GREEN}CLUSTER :${NC}             $CLUSTER_NAME"
__output "    ------------------------------------------------------------------------------------------------------------------------------------------------"
__output "    ${GREEN}MCM Server:${NC}           $MCM_SERVER"
__output "    ${GREEN}MCM Proxy:${NC}            $MCM_PROXY"
__output "    ${GREEN}Client ID:${NC}            $MCM_USER"
__output "    ${GREEN}Client Secret:${NC}        ************"
__output "    ------------------------------------------------------------------------------------------------------------------------------------------------"
__output "    ${GREEN}INSTALL PATH:${NC}         $INSTALL_PATH"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "----------------------------------------------------------------------------------------------------------------------------------------------------"
__output "---------------------------------------------------------------------------------------------------------------------------"
__output "---------------------------------------------------------------------------------------------------------------------------"
__output "  "
__output "  "
__output "  "
__output "  "


header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PREREQUISITES
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Running Prerequisites" "rocket"

        __output "---------------------------------------------------------------------------------------------------------------------------"

        export SCRIPT_PATH=$(pwd)

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output " Login to MCM"
        cloudctl login -a ${MCM_SERVER} --skip-ssl-validation -u ${MCM_USER} -p ${MCM_PWD} -n kube-system

        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output " Create Turbonomic Namespace"
        kubectl create ns turbonomic || true
       
        __output "---------------------------------------------------------------------------------------------------------------------------"
        __output " Granting necessary permissions"
        oc adm policy add-scc-to-group anyuid system:serviceaccounts:turbonomic
        __output "  "

header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Klusterlet
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Install Turbonomics" "rocket"

    __output "---------------------------------------------------------------------------------------------------------------------------"
    __output " Setup Service Account"
    kubectl apply -f ./tools/turbonomic/service_account.yaml -n turbonomic
    __output "  "


    __output "---------------------------------------------------------------------------------------------------------------------------"
    __output " Setup RBAC"
    kubectl apply -f ./tools/turbonomic/role.yaml -n turbonomic
    kubectl apply -f ./tools/turbonomic/role_binding.yaml -n turbonomic
    __output "  "


    __output "---------------------------------------------------------------------------------------------------------------------------"
    __output " Setup CRD"
    kubectl apply -f ./tools/turbonomic/crd/charts_v1alpha1_xl_crd.yaml -n turbonomic
    __output "  "


    __output "---------------------------------------------------------------------------------------------------------------------------"
    __output " Deploy the Operator"
    kubectl apply -f ./tools/turbonomic/operator.yaml -n turbonomic
    __output "  "


    __output "---------------------------------------------------------------------------------------------------------------------------"
    __output " Create the CustomResource"
    kubectl apply -f ./tools/turbonomic/crd/charts_v1alpha1_xl_cr_ibm.min.yaml -n turbonomic
    __output "  "


    __output ""
    __output ""
    __output ""
    __output ""
    __output ""
    __output ""

header3End


headerModuleFileEnd "Install Turbonomics" $0

