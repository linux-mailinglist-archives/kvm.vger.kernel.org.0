Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E2A579C74
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbiGSMkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241343AbiGSMj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:39:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A3D52FEC;
        Tue, 19 Jul 2022 05:15:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwtRlGWLK5MLoc3qOdEKErwxy8Hxh3JE5Nau4cOGEn4m0c7xIUSs5D0+KubG9AnjlhFmhLCvVGLiZbBPRoX7YHIuByAU0odGPv7wYgToFD5kQrjCpPMKMSTZJmFN7nZGDAo8Qb4WshA7zHHsKxwP9UJeeoEZj6igLvqPCm7HSe2fqRVZx/PVPHJtgo+xKcTWnzd+B4clAu1VTpgA42IQFeHwAFI1e4e13l32lLHQSJAXloVxTAV7OdDn/decW3VM20TXk2pdkvEDN9dICxKMxc9r6LCRARSDxZMkMQYsICMCLqN8TdgnC4jenn/CS2JhZiAMSaJ6+Q4ELMoWBcbbLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C32XeuxEeBMBdAS3Esyq/KV+5YWi/SdXHtxJ67gidys=;
 b=IJE0yYvj7KYsZfqNKli7fdYqIV1GNOo6aASCtshBYSvE5rtZcVfyums4dIS8KDygLaaP9m9FT/WrcnWDKjfnhK8wgkLYxNrdMpA666rJaMgT+RYTMH7jQLB9xU5t+IS1WvNFcxUNAiBP0ea8XaCJ+wVWMxPYQKoZ8RK4ujPod5NmitBPfBbIJdNNa74Ck9IXEs22m/fbEKH7YCWxYh2z5qrguRcieYpr8kTNXqNsWmf/LzbY4GID5rq/PT77P/rIBmohZfkQmAD3YDGVCqqtvq0GSZu7rH2IuQb1tDddGlNrvBdSIgXCQuNxY6d5paR3Zs8hIbWcpTxr9fT5cBTwbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C32XeuxEeBMBdAS3Esyq/KV+5YWi/SdXHtxJ67gidys=;
 b=QtWzBLXmkUE6z7dtbeo8i4J5HJ5wL17bVud7JQnT2wffheUIb3592mhou14fMyTxRnbtXaoBSmHWCrcsEoiMT9qSe6tguDr14PAssKPeQY/ZaOo52qh5DdjGIWLR2yUo8G0vTY4DfRoN2BvQHBX2ERbk47MHVMpGGF9tGdJw8YXWZIlazVL4jfQcXEm9ktj4GFNL6BhXpN4iHdA5tOlGPqqsUJ517SL0B1r8owFb3xLKLCGvXM+mV+kNjme58d+T0hWWDNYSlxgjJkGNppyJDKqGkiyaXKF+yTYSe6+bceJLJjXLVaeT2WMXcQt3QupoIUCmQ57WTQUyvhRs+4DgpA==
Received: from DS7PR03CA0019.namprd03.prod.outlook.com (2603:10b6:5:3b8::24)
 by BL0PR12MB2418.namprd12.prod.outlook.com (2603:10b6:207:4d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 12:15:46 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::9f) by DS7PR03CA0019.outlook.office365.com
 (2603:10b6:5:3b8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Tue, 19 Jul 2022 12:15:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:15:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 12:15:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 05:15:43 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 05:15:39 -0700
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
Subject: [PATCH v5 1/5] vfio: Add the device features for the low power entry and exit
Date:   Tue, 19 Jul 2022 17:45:19 +0530
Message-ID: <20220719121523.21396-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719121523.21396-1-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f84dd83-c7c6-40ef-dec3-08da698068e7
X-MS-TrafficTypeDiagnostic: BL0PR12MB2418:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrtKNAjIzehknbgAMoHhvZyCPDRnlTebgIAhjN8USQI54tY17Y+pXFPsJMdk31x+1gWruT7+ttVc+nBHuuQaYch8pRtVqBAfTFTa7AeYdqFOlxV8aMLYHQmbnsgGM4J49DunmYElwzX+rtFIird7uiVpJdjLfW3isfWBv25epno6WGOV7uOpsofa2WuP2kYHW6Rk+3RbEAb2TYDnQ5DCeCmRSVarlXBlew0Jw+xPJuON78MF2RdoDylFyZEKQxKQrU0sGpyL90FAh6UjnogkStGzBP8OMab/JR1/EM4q6e8rfjGik59hgVlbp19PFECgOYgW4KWvQugOKXGt/wuw4LWsFWUZ/TzEDZAgVvYqZCb21+3vpGVzNP+JvuWWTDxt5dxk3cK63b5kho+g/foT9sXwTa/dx+AIEV+IejvZdpGZLYmd05w7KedsLKl3ARBMGQMArz7x5Az02G+GXW7nAJau8lFvHpnGG3a+aWDTblgewZ5iby+Cp0Y4RtuJifwLqpZ4Yh4wD0gC+a6YNuhydE832hqLqF+Z55hHSUIIjMybdoeKYIOhcOcCc5CvjPXmNKqnY+Oa7pfIZf7hOYAO7Kb927TwQr8qNwLpT0M58cpNEeNcDcQysRSZNNk5nnmBVQaqj1V3M9UBDoQfJ2ekLPKyI2KZfdylVUH6dPmTuXUP1ca52LmDiC9q8fM3SYBQ2lUBE4EoCOIfbdyqRj7CypUnufdhlUByMD6pDGrYrIUDnmlCuTo9ukFfiFY8+ByX603jnseuizFtxMf8uhBAs/LactejwLBO7TMe96sxVg9sQ/r/OWEOqhljW4uDktnLlNIPvqqcpIBGXGy3ZTPfeQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(40470700004)(46966006)(4326008)(70206006)(8676002)(8936002)(70586007)(54906003)(316002)(86362001)(110136005)(356005)(36756003)(36860700001)(7416002)(2906002)(82740400003)(81166007)(186003)(26005)(5660300002)(47076005)(336012)(40480700001)(7696005)(41300700001)(6666004)(478600001)(40460700003)(107886003)(82310400005)(2616005)(1076003)(83380400001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:15:45.7478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f84dd83-c7c6-40ef-dec3-08da698068e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2418
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the following new device features for the low
power entry and exit in the header file. The implementation for the
same will be added in the subsequent patches.

- VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
- VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
- VFIO_DEVICE_FEATURE_LOW_POWER_EXIT

With the standard registers, all power states cannot be achieved. The
platform-based power management needs to be involved to go into the
lowest power state. For doing low power entry and exit with
platform-based power management, these device features can be used.

The entry device feature has two variants. These two variants are mainly
to support the different behaviour for the low power entry.
If there is any access for the VFIO device on the host side, then the
device will be moved out of the low power state without the user's
guest driver involvement. Some devices (for example NVIDIA VGA or
3D controller) require the user's guest driver involvement for
each low-power entry. In the first variant, the host can move the
device into low power without any guest driver involvement while
in the second variant, the host will send a notification to the user
through eventfd and then the users guest driver needs to move
the device into low power.

These device features only support VFIO_DEVICE_FEATURE_SET operation.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..08fd3482d22b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,61 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
+ * with the platform-based power management.  This low power state will be
+ * internal to the VFIO driver and the user will not come to know which power
+ * state is chosen.  If any device access happens (either from the host or
+ * the guest) when the device is in the low power state, then the host will
+ * move the device out of the low power state first.  Once the access has been
+ * finished, then the host will move the device into the low power state again.
+ * If the user wants that the device should not go into the low power state
+ * again in this case, then the user should use the
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature for the
+ * low power entry.  The mmap'ed region access is not allowed till the low power
+ * exit happens through VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will
+ * generate the access fault.
+ */
+#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
+ * with the platform-based power management and provide support for the wake-up
+ * notifications through eventfd.  This low power state will be internal to the
+ * VFIO driver and the user will not come to know which power state is chosen.
+ * If any device access happens (either from the host or the guest) when the
+ * device is in the low power state, then the host will move the device out of
+ * the low power state first and a notification will be sent to the guest
+ * through eventfd.  Once the access is finished, the host will not move back
+ * the device into the low power state.  The guest should move the device into
+ * the low power state again upon receiving the wakeup notification.  The
+ * notification will be generated only if the device physically went into the
+ * low power state.  If the low power entry has been disabled from the host
+ * side, then the device will not go into the low power state even after
+ * calling this device feature and then the device access does not require
+ * wake-up.  The mmap'ed region access is not allowed till the low power exit
+ * happens.  The low power exit can happen either through
+ * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
+ * wake-up notification has been generated).
+ */
+struct vfio_device_low_power_entry_with_wakeup {
+	__s32 wakeup_eventfd;
+	__u32 reserved;
+};
+
+#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device out of the low power
+ * state.  This device feature should be called only if the user has previously
+ * put the device into the low power state either with
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature.  If the
+ * device is not in the low power state currently, this device feature will
+ * return early with the success status.
+ */
+#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.17.1

