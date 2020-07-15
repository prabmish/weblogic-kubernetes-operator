// Copyright (c) 2020, Oracle Corporation and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

package oracle.weblogic.kubernetes.actions;

import oracle.weblogic.kubernetes.TestConstants;

public interface ActionConstants {

  // Work directory for the integration test suite
  public static final String WORK_DIR
      = System.getProperty("java.io.tmpdir") + "/it-results";
  // Integration tests directory
  public static final String ITTESTS_DIR = System.getProperty("user.dir");
  // Directory for resources
  public static final String RESOURCE_DIR
      = System.getProperty("user.dir") + "/src/test/resources";
  // Directory for all applications
  public static final String APP_DIR = RESOURCE_DIR + "/apps";
  // Directory for all WDT models
  public static final String MODEL_DIR = RESOURCE_DIR + "/wdt-models";
  // Directory for download items
  public static final String DOWNLOAD_DIR = WORK_DIR + "/download";
  // Directory for staging purposes
  public static final String STAGE_DIR = WORK_DIR + "/stage";
  //Directory for archiving purposes
  public static final String ARCHIVE_DIR = STAGE_DIR + "/archive";
  // Directory for WIT build
  public static final String WIT_BUILD_DIR = WORK_DIR + "/wit-build";

  // ------------ WebLogicImageTool action constants -------------
  public static final String WLS = "WLS";
  public static final String JRF = "JRF";
  public static final String RJRF = "RestrictedJRF";
  public static final String WLS_BASE_IMAGE_NAME
      = TestConstants.OCR_REGISTRY + "/middleware/weblogic";
  public static final String WLS_BASE_IMAGE_TAG = "12.2.1.4";

  public static final String DEFAULT_MODEL_IMAGE_NAME = "test-mii-image";
  public static final String DEFAULT_MODEL_IMAGE_TAG  = "v1";

  // ------------ WebLogic Image Tool constants----------------------------
  public static final String WIT = "WIT";
  public static final String WDT = "WDT";

  public static final String WIT_DOWNLOAD_URL
      = "https://github.com/oracle/weblogic-image-tool";
  public static final String WIT_VERSION    = System.getProperty("wit.version", "latest");
  public static final String WIT_FILE_NAME  = "imagetool.zip";

  public static final String WDT_DOWNLOAD_URL
      = "https://github.com/oracle/weblogic-deploy-tooling";
  public static final String WDT_VERSION    = System.getProperty("wdt.version", "latest");
  public static final String WDT_FILE_NAME  = "weblogic-deploy.zip";

  public static final String IMAGE_TOOL = WORK_DIR + "/imagetool/bin/imagetool.sh";
  public static final String WDT_ZIP_PATH = DOWNLOAD_DIR + "/" + WDT_FILE_NAME;

  // ------------ WLDF RBAC constants ------------------------------------------
  public static final String WLDF_CLUSTER_ROLE_NAME = "wldf-weblogic-domain-cluster-role";
  public static final String WLDF_CLUSTER_ROLE_BINDING_NAME = "domain-cluster-rolebinding";
  public static final String WLDF_ROLE_BINDING_NAME = "weblogic-domain-operator-rolebinding";
  public static final String RBAC_CLUSTER_ROLE = "ClusterRole";
  public static final String RBAC_CLUSTER_ROLE_BINDING = "ClusterRoleBinding";
  public static final String RBAC_ROLE_BINDING = "RoleBinding";
  public static final String RBAC_API_VERSION = "rbac.authorization.k8s.io/v1";
  public static final String RBAC_API_GROUP = "rbac.authorization.k8s.io";

  public static final String MONITORING_EXPORTER_DOWNLOAD_URL 
      = "https://github.com/oracle/weblogic-monitoring-exporter.git";

  // ------------ Ingress constants----------------------------
  public static final String INGRESS_API_VERSION = "networking.k8s.io/v1beta1";
  public static final String INGRESS_KIND = "Ingress";
}
