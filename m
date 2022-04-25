Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472DC50DC92
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiDYJbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiDYJac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:30:32 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A741C24BC7;
        Mon, 25 Apr 2022 02:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7EA9TOlWudWx9KazzCBDgS5crG+qLjvADpidtSHA8KZxqsaLZlm6s/AkYU6xiOF8hWjtkwtM+ptHG+xi4+TyqZj8Ai8sMtWt21dQ9PQi1gq67SIoDe38D9gJkEwYpfpkNumjHwGGdk8M55yU4JpVQgj/Ojn4ZylC4AN/43+PjKestS+I0IctUtA6jEZEdzOb9mugnLjpdcWmTx+NY5ouUPJE+e6XdyUpmM2l2t+CNoyecb8n3uJUCp7Or5nXtGdESPwk4whozjN5iyEaFm+wd3+IDi2zLMiMzbL8MkqkBjoZy0czbdE7ZYTuD6XzHkXXUWTWXjQP7uRVCXvV7BMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzcKv0yCImOK30dpSshruBTbhscYD6Bewtj9ijd6x3g=;
 b=Z8HqdM5DNbudmB/dMqX1uzLlb9cFhGmS4Rt2mVyp7MIF1s9G2Rsee1rKNNO4Lk/bsnyu6cPrCIgR2UZM9Id/yG6cigs4g8yoQg33UhX8GkL7/e2r8ho0vknE5IOb1fH9fNFTTgk2QyZYsg9faLgRZf6UmTeqfjKtws4Jacd89smhHjK4M9Vd9zRZtLuqjqLewhsH/u8pLhfBOp3GZU2OjLkVUmVUO12eBEA+joyWojvzoQJvaO4K8YL4adL/rurQn3Jfd4Yf/3Ruqunv+Ebh0YUQ1gMmhiPBwvsej5kDBbb4hxDu21zVm3obZu9vhT/hSNNnCfl3C3TxMZ795QPwHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzcKv0yCImOK30dpSshruBTbhscYD6Bewtj9ijd6x3g=;
 b=exyUS3SRMP8OK87/NDteWqkXat1Z2M+YVmtYUo8SdIwv6BmbgAyPpM7OOM726DYD4EK1Z4ewA9qA0+T5Cu3WFtGZCfHOMbK7oSXFiOM5L9Vn/CwwfvzqaWtHXYPOifCgwlNMYqJ76q1gejgy3yBWOTfVxwl44d/qLQUlfziGNOetgXHAzvozB9FiU3om8/lYIlb/H1BthVemge8DPKMzI5m1ZgNLbr7YCV7NwBhZxMGxIAtgVkkhrh7wLZWXrreeo27XDs/oyQUqcBdatoMl8QhSSw5O+41Jgc0STPsByVv1/BjUktOgXq01X+HC4M4rN/K05rC/0CUKAmK9mnZIaQ==
Received: from MW4PR04CA0363.namprd04.prod.outlook.com (2603:10b6:303:81::8)
 by BL1PR12MB5045.namprd12.prod.outlook.com (2603:10b6:208:310::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 09:27:03 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::42) by MW4PR04CA0363.outlook.office365.com
 (2603:10b6:303:81::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Mon, 25 Apr 2022 09:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:27:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:27:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:27:01 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:56 -0700
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
Subject: [PATCH v3 6/8] vfio: Invoke runtime PM API for IOCTL request
Date:   Mon, 25 Apr 2022 14:56:13 +0530
Message-ID: <20220425092615.10133-7-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a117a7fd-6d36-40fb-5f7b-08da269dc176
X-MS-TrafficTypeDiagnostic: BL1PR12MB5045:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5045C2A624838B5EF3CEAB46CCF89@BL1PR12MB5045.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e907AcHMkYsJNzmZSbIwgnpB6SHmSHO1ih+2Uy/exhU4PtmIf1n1OlXgpO14UvC7nbZhwXl+qkiuHHfqDNJ73ds4IUa71kZJC1wXUpacjwuuPK0yMLrxM8pKoLkl1mH2zLJl0/2JVft13qzIV0tvLdTku2cLLac6urM0fhzvmndmlfk6ONHH26DgSd3fNKuYhYfgk5753Ar2W/oIsKs3RzFZ4NGdT183+sCpcHspCsTzqN4ZYpcvffE2MqSD3fdHaJ393AGaoeyYqvndz8A/DJY3/eMbHGzStDktomOiDeI4GCthMTW68fWvy4l1NUhanbRFAyRtgMXm3UoBEctr+q9wd8eDG+W5ld+YHL1gqnxu1zQym1lM3ZrYw3GXtGOLt19u9cXsdwO/dKXwbE+975aB3Gg7hL6pQ9E+e9lR6WOHG9/HRAjnKlvgN+7MVMQDemwiaqJ4mxsvxncit4UKLKLMSEQM6GXkvvDMu6EPMik2W7Lb/w/kK2nCTNmB93pmtEt6nu14Icv7S+L1VtiEgxDEOFn5qk65bgyeIcd37fJvsJuQ7leB2CI6UK31WQZVEqCPMRgDCVplAcdpmIi6ire4a1c+3VWWhu+SKhioR/yjA5eUrCBK+4eDejaf/qNZy+rcYQQ+qE4V/XQeNC8X+0Pay3ME8p34SmZOpyYWw7kB2n8NlqdePrlmNhdRi3KvHDiPkw2f6dYu6YlNqIiaZg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400005)(8676002)(107886003)(2906002)(83380400001)(86362001)(26005)(6666004)(7696005)(508600001)(54906003)(336012)(1076003)(186003)(110136005)(426003)(2616005)(316002)(4326008)(40460700003)(47076005)(70206006)(70586007)(8936002)(36756003)(81166007)(7416002)(356005)(36860700001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:27:02.2734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a117a7fd-6d36-40fb-5f7b-08da269dc176
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5045
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio/pci driver will have runtime power management support where the
user can put the device low power state and then PCI devices can go into
the D3cold state. If the device is in low power state and user issues any
IOCTL, then the device should be moved out of low power state first. Once
the IOCTL is serviced, then it can go into low power state again. The
runtime PM framework manages this with help of usage count. One option
was to add the runtime PM related API's inside vfio/pci driver but some
IOCTL (like VFIO_DEVICE_FEATURE) can follow a different path and more
IOCTL can be added in the future. Also, the runtime PM will be
added for vfio/pci based drivers variant currently but the other vfio
based drivers can use the same in the future. So, this patch adds the
runtime calls runtime related API in the top level IOCTL function itself.

For the vfio drivers which do not have runtime power management support
currently, the runtime PM API's won't be invoked. Only for vfio/pci
based drivers currently, the runtime PM API's will be invoked to increment
and decrement the usage count. Taking this usage count incremented while
servicing IOCTL will make sure that user won't put the device into low
power state when any other IOCTL is being serviced in parallel.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/vfio.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e..4e65a127744e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/pm_runtime.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1536,6 +1537,30 @@ static const struct file_operations vfio_group_fops = {
 	.release	= vfio_group_fops_release,
 };
 
+/*
+ * Wrapper around pm_runtime_resume_and_get().
+ * Return 0, if driver power management callbacks are not present i.e. the driver is not
+ * using runtime power management.
+ * Return 1 upon success, otherwise -errno
+ */
+static inline int vfio_device_pm_runtime_get(struct device *dev)
+{
+#ifdef CONFIG_PM
+	int ret;
+
+	if (!dev->driver || !dev->driver->pm)
+		return 0;
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 /*
  * VFIO Device fd
  */
@@ -1845,15 +1870,28 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
 	struct vfio_device *device = filep->private_data;
+	int pm_ret, ret = 0;
+
+	pm_ret = vfio_device_pm_runtime_get(device->dev);
+	if (pm_ret < 0)
+		return pm_ret;
 
 	switch (cmd) {
 	case VFIO_DEVICE_FEATURE:
-		return vfio_ioctl_device_feature(device, (void __user *)arg);
+		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
+		break;
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
+	if (pm_ret)
+		pm_runtime_put(device->dev);
+
+	return ret;
 }
 
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
-- 
2.17.1

