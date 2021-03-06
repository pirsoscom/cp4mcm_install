# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Install Script for Open LDAP
#
# V1.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

source ./99_config-global.sh

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

headerModuleFileBegin "Install Open LDAP " $0

# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# INSTALL CHECKS
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
header3Begin "Install Checks"


        getInstallPath

        BASE_DN="dc="$(echo $LDAP_DOMAIN | ${SED} -e "s/\./,dc=/")
        BIND_DN="cn=admin,"$BASE_DN


        checkAlreadyInstalled app=openldap default
        if [[ $ALREADY_INSTALLED == 1 ]];
        then
            __output "    ${RED}${cross}LDAP already installed! Skipping...${NC}"
            exit 0
        fi

header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PREREQUISITES
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Running Prerequisites" "rocket"

        export SCRIPT_PATH=$(pwd)

        oc adm policy add-scc-to-user anyuid -z default -n root
header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Install Klusterlet
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Install OpenLDAP" "rocket"


      __output "Install OpenLDAP Helm Chart"

      $HELM_BIN install openldap ./tools/ldap/openldap -n default \
          --set OpenLdap.Domain="ibm.com" \
          --set OpenLdap.AdminPassword=P4ssw0rd! \
          --set OpenLdap.SeedUsers.usergroup=mcm \
          --set OpenLdap.SeedUsers.userlist=mcm \
          --set OpenLdap.SeedUsers.passw0rd=P4ssw0rd! \
          --set OpenLdap.Route=$CLUSTER_NAME || true

header3End


headerModuleFileEnd "Install Open LDAP " $0