# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Installing Script for all CP4MCM components
#
# V2.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

source ./99_config-global.sh


  

        __output "${RED}***************************************************************************************************************************************************${NC}"
        __output "  "
        __output " ${RED}${eyes}     CP4MCM PWD : $(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d) ${NC}"
        __output " ${RED}${eyes}     CP4MCM USER: $(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_username}' | base64 -d && echo) ${NC}"
        __output "  "
        __output " ${RED}${eyes}     CP4MCM URL : $(oc get route -n ibm-common-services cp-console -o jsonpath=‘{.spec.host}’) ${NC}"
        __output "  "
        __output "${RED}***************************************************************************************************************************************************${NC}"



