Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3C59687B
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 07:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiHQFNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 01:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiHQFNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 01:13:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99204D264;
        Tue, 16 Aug 2022 22:13:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFEf2PYORAMCxPuTD2EHluoVVU/BQkHBl4LjFjv9s1al+qmyqDmwnbyq2w9yKPBdymlb20T0HGSo+hu6CVVYAkOWTJ5q9ez558b0WfTaqJUedpMJceufugAXTslechvinMKmDIW97/00MsrUiKwmlShk0bWS3z2icorgJv9DgXCFtXGKOpRQtaJvV3dCh0i3MkH6NggU001Nm2JkQi1Y4bVB24u4DCcKP8mSsyKBH9V5jUvZ0gp8xQnggA0webCpcfKx9Ms9dVQtG86J14ydceYWUbMs5tp4NgkkYNOFwbkMmldLinHjkpWRUw0sG4p8SMIhfG8Ij4+qNaZocz1HqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTmANG1L7NOW7uPQE252yydgK6aBBriyQ8aKqX8Jvq0=;
 b=jmqBQzuAJHKdfBDGQ80nle4k2w9tRT24Pr49ChzCEyXVl5/GDYfU4dZ6DrGZNH+SicWIToWLoZfx4+gLG+QLKmdaBRUuZuyxkn/PXvf2AzZ16SCDRg1AfB1XYibovWDhIlnom/Xj0vDFv9J2BFPyZT5su6lw3tgvjPIjbQRlLRru+PI4B3iPj3GhXBwcbShnun7RR5GNLBS5RStvWZ89Rj23Y4esaBMRHkddtzWUl6qy9rCyg8lC7jmKTom8mb0uli4b6h/H0Ddg5aufdYPhmFtKYxhbJ0znhfkoP285CKrkQ+jzyXj7GBeqZriZe13Uhq0JR9KWqV0MWNAxHJW6Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTmANG1L7NOW7uPQE252yydgK6aBBriyQ8aKqX8Jvq0=;
 b=tgU3IFkEA15MjgRvcinGl9ioO7i/AZzKoLMO51Dnv5w1SGlrNKERpAsg8ow5TbtdJY0KLb7iGvdOMp9t/63RCVOg+Uw2j7Tu0JzMwAP9RbAg2Y0Chwyy1mItyCrASRppMEOEfzoIrAGShrnXkuDEovYOqUIZ57Xi1xGsI0eEbVWu4Ct+uU1vRVf1gJRSCVWuhhcdPEZ7GeFrBoeRCDmmimUp7etj7yexqaNnV+G1j5p4i73R0p7KlIcHa700GBAoZEe+BBWvt0+lJsKr1KBNnp50oTDQeEcmiva+jn4sL8CDL/vkuRj28JIaD/X1LkMwyJWfFSttFxskPN+bJ2Rhcg==
Received: from MW4PR03CA0027.namprd03.prod.outlook.com (2603:10b6:303:8f::32)
 by DM5PR1201MB2521.namprd12.prod.outlook.com (2603:10b6:3:ea::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 05:13:45 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::1d) by MW4PR03CA0027.outlook.office365.com
 (2603:10b6:303:8f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 05:13:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 05:13:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 05:13:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 22:13:43 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 16 Aug 2022 22:13:39 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v6 2/5] vfio: Increment the runtime PM usage count during IOCTL call
Date:   Wed, 17 Aug 2022 10:43:20 +0530
Message-ID: <20220817051323.20091-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817051323.20091-1-abhsahu@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f39fc7d-3ae0-432b-7921-08da800f423d
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2521:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPn6xTAIjtCn+IvJTLf0HvYVFwhne+EFCY0JyRpgg4raN19SHIG84VMC7qLqs+quudYApcDCQl0b2ijMnEIpQJHN41orCc6hMpZJfl3Qx+XCB4ExF0rfCfIE7ZMliLjauoRFh3X2BUFDr9NPyhHWuB90Iaeu1QR39N/mAb4ONgyYPSZN2PGBvsHTdQ0PJh2msEl6+MSuVssvFy0D6rNBOw2A6sVpia4X9roKutjceJjdJ9boGLss3xVpVD0MmUku6I8+lOX08dcH9FThpFzFbAK3fAAfe9bdoAWFjDFsJzwiaz94FqVFgzXH3bZ3uu6i2/lbPCH3tJC00clCF8fLqREUd2HhdtZCiY27zcBL/ZuyWzjWq8mW6mSQHZEEOI9LtoWTUnYOTq1tlz70BV9LVBDeeVyECdxkSbQHtkQdubK4vU6qGoJKbPLYf+jYtCHBSfxuDJqb54MJHDPU2oquG8H8h13eVE+plMKCIvba2qoKIS0Zza0tPHR+rk36L42xIqYmv//h4LUVcSSA0MN1129n+Nj7j7Th7xJxj9W5fXjWN/a+AXG1UKlR6ES8Mv/iT0e9NG6FB1Nsio637d9pKo6cyy29k+ctrMHnDK/tQ/YXHnlk0KMC50dUHVWQLg4bDGdiM6GvWJ8GkgE9tKjWolWWkNCrtFmT9uiUw5nvY0YY8kwT3Quq2+CuYDL761HfeBx31xbOFH3G4T0jIR0Cq2WOyu0JFPsY4PwOr7CZuAz2lpXM+h/Rs7KvB2gLl4FiiHRTR2QbQazPkn7xtAuP7Jw85VkJJvSVzKUfhNh7gX5sFv5uuvW7RaG9wBtfK61QVr0cG5FkSiQGeRjlvf+e/A==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(46966006)(40470700004)(336012)(47076005)(54906003)(2616005)(1076003)(40480700001)(6666004)(186003)(86362001)(7696005)(36860700001)(36756003)(26005)(83380400001)(110136005)(40460700003)(107886003)(82310400005)(316002)(4326008)(426003)(41300700001)(70206006)(2906002)(70586007)(478600001)(5660300002)(81166007)(356005)(82740400003)(8676002)(7416002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:13:44.9442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f39fc7d-3ae0-432b-7921-08da800f423d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2521
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio-pci based drivers will have runtime power management
support where the user can put the device into the low power state
and then PCI devices can go into the D3cold state. If the device is
in the low power state and the user issues any IOCTL, then the
device should be moved out of the low power state first. Once
the IOCTL is serviced, then it can go into the low power state again.
The runtime PM framework manages this with help of usage count.

One option was to add the runtime PM related API's inside vfio-pci
driver but some IOCTL (like VFIO_DEVICE_FEATURE) can follow a
different path and more IOCTL can be added in the future. Also, the
runtime PM will be added for vfio-pci based drivers variant currently,
but the other VFIO based drivers can use the same in the
future. So, this patch adds the runtime calls runtime-related API in
the top-level IOCTL function itself.

For the VFIO drivers which do not have runtime power management
support currently, the runtime PM API's won't be invoked. Only for
vfio-pci based drivers currently, the runtime PM API's will be invoked
to increment and decrement the usage count. In the vfio-pci drivers also,
the variant drivers can opt-out by incrementing the usage count during
device-open. The pm_runtime_resume_and_get() checks the device
current status and will return early if the device is already in the
ACTIVE state.

Taking this usage count incremented while servicing IOCTL will make
sure that the user won't put the device into the low power state when any
other IOCTL is being serviced in parallel. Let's consider the
following scenario:

 1. Some other IOCTL is called.
 2. The user has opened another device instance and called the IOCTL for
    low power entry.
 3. The low power entry IOCTL moves the device into the low power state.
 4. The other IOCTL finishes.

If we don't keep the usage count incremented then the device
access will happen between step 3 and 4 while the device has already
gone into the low power state.

The pm_runtime_resume_and_get() will be the first call so its error
should not be propagated to user space directly. For example, if
pm_runtime_resume_and_get() can return -EINVAL for the cases where the
user has passed the correct argument. So the
pm_runtime_resume_and_get() errors have been masked behind -EIO.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97..535e5ef0640d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/pm_runtime.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1354,6 +1355,39 @@ static const struct file_operations vfio_group_fops = {
 	.release	= vfio_group_fops_release,
 };
 
+/*
+ * Wrapper around pm_runtime_resume_and_get().
+ * Return error code on failure or 0 on success.
+ */
+static inline int vfio_device_pm_runtime_get(struct vfio_device *device)
+{
+	struct device *dev = device->dev;
+
+	if (dev->driver && dev->driver->pm) {
+		int ret;
+
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret) {
+			dev_info_ratelimited(dev,
+				"vfio: runtime resume failed %d\n", ret);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Wrapper around pm_runtime_put().
+ */
+static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
+{
+	struct device *dev = device->dev;
+
+	if (dev->driver && dev->driver->pm)
+		pm_runtime_put(dev);
+}
+
 /*
  * VFIO Device fd
  */
@@ -1674,15 +1708,27 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
 	struct vfio_device *device = filep->private_data;
+	int ret;
+
+	ret = vfio_device_pm_runtime_get(device);
+	if (ret)
+		return ret;
 
 	switch (cmd) {
 	case VFIO_DEVICE_FEATURE:
-		return vfio_ioctl_device_feature(device, (void __user *)arg);
+		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
+		break;
+
 	default:
 		if (unlikely(!device->ops->ioctl))
-			return -EINVAL;
-		return device->ops->ioctl(device, cmd, arg);
+			ret = -EINVAL;
+		else
+			ret = device->ops->ioctl(device, cmd, arg);
+		break;
 	}
+
+	vfio_device_pm_runtime_put(device);
+	return ret;
 }
 
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
-- 
2.17.1

