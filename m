Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC79C579C7A
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbiGSMkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241361AbiGSMja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:39:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D1453D1D;
        Tue, 19 Jul 2022 05:15:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMRkjRJcCcacWGUd4Hhx2jwrsI61PdKQmaaZ3KeNj1tEMo9KF0WZLLrlQq27N8R9aN5Ky28gKbziXNppqdPOU1PLKa7xWAw8c5Xz/4c3Ya0WNvgd8NGN0MTFxYKIm4zZe05kHS3I9sGMQvEF8nPeFP/WxOqpq9/yJjC++UsDoIU6WrrOQMVsn3ZojegLHuFJGBLgSMvRrieCtgwWqlbt7PvvETJeIhm3xN0of14hVB+Ps7QBbYPi4cyKl5z5uE5fe31w9JL5hdb4V7Ct6r+5kLaUV7UzRkoq6hm0ybBl3G13ux9sN61nTyroAk87Y728WxyQ9twUuAmC8xx+grP8Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92la50CMMw1d3QAx8Joo1Ncw73XcJwxbEb5O2iXCZlM=;
 b=VnUBAtxulENQ5cV76XTlHgZgZ0FFT8vctsHtVkFcuVTsB/gsyuISaRj3aZAi2jVlK7WEWEdCttWQtwpfmuOcYpPJU2ILKGMldrJPcm9NR01FJiXysmBpRIkIxZkIUtTU+lH5dbbnio/mtpf52RKURjDedTA/sCcY5cIyKEqrPwtH9+tGyztij7wHQWxoKmp8IF5Pbn/obOdvYtFohzntRQFjHYd0E/RZkfksD0/FWDOzZ7YrI3QiWFeNPQP6eTBvTmOREbCWbK+mbwyZHTHWeLy5LJ7Ci/F6C+9gLX+p6FxwzE+n1XjRMPzXFz/Gpokf6Hw2M8i40y+c9CN15w1IpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92la50CMMw1d3QAx8Joo1Ncw73XcJwxbEb5O2iXCZlM=;
 b=nDgJd/eOmymY/TPwP9C7DstHwA77tZ060ibaABrAEKqLop6BxSbkSmHZC4+lVjA/4RQbk2BDVSQbGvAxVtpPJlPKWJ5g7VhUnsKpMZ0FGQHVcLn6skQoAcanFB0+eR4jzNcfcH0fV1/t8N31+83J0Pq1nbjd8DsEAC6U8QQublnje+c5RE8e/YyBKY51fORKteOaKM6i4EEEoKy10BMwb0Xj/LeU7iXI5L6Nq69bID/49DXwJcT96ybXJVdRShBOb1SLphyr3KrMGVqz1nGrA/RUbSqPUcjGYZ2NrUEZBqFZLcDxTMnyMSKI7aiYNCPf/mYGLgu0gXhzXKCUwZ/48Q==
Received: from DS7PR03CA0117.namprd03.prod.outlook.com (2603:10b6:5:3b7::32)
 by DM6PR12MB3289.namprd12.prod.outlook.com (2603:10b6:5:15d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 12:15:51 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::b8) by DS7PR03CA0117.outlook.office365.com
 (2603:10b6:5:3b7::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25 via Frontend
 Transport; Tue, 19 Jul 2022 12:15:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:15:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 12:15:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 05:15:49 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 05:15:44 -0700
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
Subject: [PATCH v5 2/5] vfio: Increment the runtime PM usage count during IOCTL call
Date:   Tue, 19 Jul 2022 17:45:20 +0530
Message-ID: <20220719121523.21396-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719121523.21396-1-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee120fed-81d0-4451-e5e8-08da69806bbf
X-MS-TrafficTypeDiagnostic: DM6PR12MB3289:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCEMjMdWZdyPZkqCR9EY1x/qoBeL1pSfdr0Q5x3aQVZsgZiHm6CE7MprkdzrrrgcwJmxgkAJcfLi4/EgrcQMc3O1EEA8iITcjJybM+HD4Kd3HAzPiojDsgPVLHVSDOf3arg7qUzlE8xikOFH1jrQcuLblZcx184YxWaLhlbiU3WUVqW4xRfR3nhBj3Xlz2XLLVcieGT0VnpS+WyFzEgmBmBHn7WTM7AGcZDaWfOO94b6ZMLWl3ShlfvUnTX0MX/3cX1zhTxjtMOEKj72EwtFjuyYUcgFClSszUPW/nIMB/JWT8q3sP+Y5kP+MEwvuZhDkuoqcsQFdSHoTLRunZpZWsZxYtUyQru5wDwulWklu4iIEjvf9pSolEWmdZZ0t7d1+3oMt9/sCLl5Jc+qiME9wYkxN8tdFIUCeX34KDuoDTRtfVbP8W7Qh0tqOugdcSj+kID4SHz6dGrWOkXkdHeiKJkYmJOVv8aJZhovYfPIPuZm4r4YUfw5mXJmUKK2C8ZANbSpDSktdzV6m/y0lOI6PrpBWHPn1rpuPEwbHYHEZ4BJuJzFBKHoHQSZY+w5thHhVbDpE0cZax4jMpFnSdABgB4dibS0pEs2V9Ac694w2TtsuQzXX99NzWIlDo/51kVNSiIfLw8thkYv9LnfCCmb8Cs4IkFMybSjFSKeSvlqbv40tqA7IulVFxE5QYnDas1c63qx7OfWewo3190arWCJziOXgghPW5KYn8gNGptM6Sn2KFlIwYyUZQL0jlsOLWcvvBmSnDepR6fxjHmcxNAVvRj9dtQc9uz3vVHbeSQFdQQDFM1w/MWDA7ZW9EXIsH0nV3KmCIIVrslkiEClfcQhmA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(40470700004)(46966006)(36840700001)(83380400001)(186003)(26005)(2906002)(41300700001)(6666004)(86362001)(47076005)(336012)(1076003)(7696005)(5660300002)(7416002)(40460700003)(2616005)(36860700001)(107886003)(8936002)(82310400005)(316002)(356005)(82740400003)(81166007)(4326008)(36756003)(426003)(478600001)(8676002)(70586007)(70206006)(110136005)(54906003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:15:50.9721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee120fed-81d0-4451-e5e8-08da69806bbf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3289
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 drivers/vfio/vfio.c | 52 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index bd84ca7c5e35..1d005a0a9d3d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/pm_runtime.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1335,6 +1336,39 @@ static const struct file_operations vfio_group_fops = {
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
+		if (ret < 0) {
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
@@ -1649,15 +1683,27 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
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

