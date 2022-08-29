Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA25A4B66
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiH2MRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiH2MRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:17:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E934797D51;
        Mon, 29 Aug 2022 05:00:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5F/5vzaSUBJZP3lF7WQ/wJ+EwJjYGzQlgS6BQ+mPFpU3kZUrT7yW2hFz4lzj4ULqc1pV+7fOkTntoldli1P7mRT87IZJFNJ7hxkc9ij1UUm6tXHUjMbu+QnIcPEX2T3hqSVYoD9rkTE8I3Pux0yP8P49RuuO4ALAGAiIs16qjhe3aM3yuXBFOhjgIs5yeiSpYiwUwA1BD4JGzx5F7hrks4mx9Ps1cHVKjVoFegojV4fsl5OVvzx1DGIXx078a2Ti8kDVEvR1Gq5hpWGZ8YRwy03HH0+dxC/P5wNsTpxLG/Cpgu/Q3wkBx/107QCYkra/JI28/+U5eSLVMkYNZ+uzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GS+0AX+1mjY+BsvJVY/oyr/YmF59D85FHAMSBSUwoQA=;
 b=cqoWdP6MrbgiEceQtRdVFM+t/yLmta5Rc+xWGjB/31VMUtU8+petaOV5NacyyhIEmmxFR6ztWYQ2zJLNKAk1cx+kcxmhQQxvkEZZ57sRSneYlE4hiukrBSgfVQAwh4Ukft3GmXlhWiKjnk4WYpWzWsXECnimB6dcvURnj9RNKmAtTBRMb4SndIegAxcB0s53r1yTwHgf+ar6H9vdal8KU8sOTLsDOKA4BTxzJV8hsNxpTqBWnrtTR+uqrh9zc4757wfoOAW+Awo0Amo1WSTAfeBkUNv90mlZc3iI8WhwRsIuJVj3v7/ksTl2jyMQCCi6JYqvFj8xrC1W+ICVyDO2dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS+0AX+1mjY+BsvJVY/oyr/YmF59D85FHAMSBSUwoQA=;
 b=OtWa3k8vy8pc9gfmo9cHVGjnrdVzft8z4uHduvRV0MpbaJbBYMKTx5cHlOVbGezCSi4W6CEgglh3p0YhqXzss0Mq2WJ7yBHflA/OJ0rZ3SA8fFii165J4G/lJyA4vN/44Oc0RTFz2GVyBqzAEcXi6hQc42sYAicwJ9+/KYRhEu0FG9uqxEYty33+k035rwsQk4WgBXsfcK3RGu+uAcwJ5lBHMiinNoed2p4HZtZA1s+XbTFm1gohtMQL0Hhr2y/UEZV6bR46/XMNHes2WmqrAXItcYNodUfPGCSmpfAyTUPRyE+wWBuujaqekCJqVwtZHxbyFVKkH6XVzzRD2Y4h1Q==
Received: from MW4PR02CA0019.namprd02.prod.outlook.com (2603:10b6:303:16d::23)
 by BYAPR12MB2613.namprd12.prod.outlook.com (2603:10b6:a03:69::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 11:49:07 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::a9) by MW4PR02CA0019.outlook.office365.com
 (2603:10b6:303:16d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 11:49:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 11:49:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 11:49:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 04:49:05 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 29 Aug 2022 04:49:01 -0700
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
Subject: [PATCH v7 1/5] vfio: Add the device features for the low power entry and exit
Date:   Mon, 29 Aug 2022 17:18:46 +0530
Message-ID: <20220829114850.4341-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829114850.4341-1-abhsahu@nvidia.com>
References: <20220829114850.4341-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 627e0062-9520-4432-7454-08da89b47ac4
X-MS-TrafficTypeDiagnostic: BYAPR12MB2613:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8AH5/rcP8SKIufgF3FaWGhyCTfKrvU7PGjTL7G4GScnfU6A5X5yJM4+z3htfi7uj2PWQNbnQDbqUmnbdcs2sviQRxq9nHP1Ju7wYnXSA1JVBQ2rfEB3sG4087bJR5/eqITAL+jh6xEyv+UztkLkcdWWUzE8SGvntUs1wnO7+SOJgqoSkX5wk5VbugLbSC825ycDAgcmYEdX6UliQa2m88oPtVGos3kSJ0x4Kzhzmlj0GnmhEQNnmm2O8D3MVgECtWGVllCV/VlafWV1eCC0uxGOaB3VgxfjB0TEPJM9/X3+iVW/HrK6GZkCX5tU4qGN6+leBHIvvVc6QI394R8CDMvVzEEySO627QVgpuqgjQK0f4Unw+ig1tiB2zjOqrz4Osy3B6nY2vA1JHi4vbJ+Ap8hMMf90oPAjUPyoYsHYSI/JoQxrVL6tJ974WpeTbNrF2CfwmMhaI1UAwikodTzrN6eLZC+nVLw/iEEmn5qXV9GEwrfdrWIweAVOvKnMR5t+IGqxT0m0I9PqBwMVph0UyuKt+4cTqxgfd2wxZZYTeN32BWfnwhYNTRsXlCDoXiUbY2XYWWmy8/n9Rl3qvQU1MbjGFYezGaM4kj2PjifTNWEtqR9YSck11yESK7Mau/xyxolSCNkYyN8s/eQuKwyHi43KlszDbLelqlKkAbLiSCkcUkZOk7X7cLUXrmdK3K3CDnERCHFlmZFVJyiLreaLQiA0414OEF1T4Qeo/7IlcHrwnupEw075rK185MyBK/NDXQA5szqdNJVIJJqXFqYqbnHh0+Miccq4DLbsRZl8PWrh8GdE7gZPkzdzGJp3W4L
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(40470700004)(46966006)(4326008)(70206006)(110136005)(316002)(70586007)(54906003)(82310400005)(8676002)(40460700003)(40480700001)(36860700001)(7416002)(8936002)(5660300002)(2906002)(81166007)(356005)(82740400003)(36756003)(6666004)(7696005)(26005)(86362001)(107886003)(478600001)(41300700001)(1076003)(2616005)(186003)(426003)(83380400001)(336012)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:49:07.2066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 627e0062-9520-4432-7454-08da89b47ac4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2613
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

For vfio-pci based devices, with the standard PCI PM registers,
all power states cannot be achieved. The platform-based power management
needs to be involved to go into the lowest power state. For doing low
power entry and exit with platform-based power management,
these device features can be used.

The entry device feature has two variants. These two variants are mainly
to support the different behaviour for the low power entry.
If there is any access for the VFIO device on the host side, then the
device will be moved out of the low power state without the user's
guest driver involvement. Some devices (for example NVIDIA VGA or
3D controller) require the user's guest driver involvement for
each low-power entry. In the first variant, the host can return the
device to low power automatically. The device will continue to
attempt to reach low power until the low power exit feature is called.
In the second variant, if the device exits low power due to an access,
the host kernel will signal the user via the provided eventfd and will
not return the device to low power without a subsequent call to one of
the low power entry features. A call to the low power exit feature is
optional if the user provided eventfd is signaled.

These device features only support VFIO_DEVICE_FEATURE_SET and
VFIO_DEVICE_FEATURE_PROBE operations.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 include/uapi/linux/vfio.h | 56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 733a1cddde30..76a173f973de 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,62 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
+ * state with the platform-based power management.  Device use of lower power
+ * states depends on factors managed by the runtime power management core,
+ * including system level support and coordinating support among dependent
+ * devices.  Enabling device low power entry does not guarantee lower power
+ * usage by the device, nor is a mechanism provided through this feature to
+ * know the current power state of the device.  If any device access happens
+ * (either from the host or through the vfio uAPI) when the device is in the
+ * low power state, then the host will move the device out of the low power
+ * state as necessary prior to the access.  Once the access is completed, the
+ * device may re-enter the low power state.  For single shot low power support
+ * with wake-up notification, see
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
+ * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
+ * calling LOW_POWER_EXIT.
+ */
+#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
+
+/*
+ * This device feature has the same behavior as
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
+ * provides an eventfd for wake-up notification.  When the device moves out of
+ * the low power state for the wake-up, the host will not allow the device to
+ * re-enter a low power state without a subsequent user call to one of the low
+ * power entry device feature IOCTLs.  Access to mmap'd device regions is
+ * disabled on LOW_POWER_ENTRY_WITH_WAKEUP and may only be resumed after the
+ * low power exit.  The low power exit can happen either through LOW_POWER_EXIT
+ * or through any other access (where the wake-up notification has been
+ * generated).  The access to mmap'd device regions will not trigger low power
+ * exit.
+ *
+ * The notification through the provided eventfd will be generated only when
+ * the device has entered and is resumed from a low power state after
+ * calling this device feature IOCTL.  A device that has not entered low power
+ * state, as managed through the runtime power management core, will not
+ * generate a notification through the provided eventfd on access.  Calling the
+ * LOW_POWER_EXIT feature is optional in the case where notification has been
+ * signaled on the provided eventfd that a resume from low power has occurred.
+ */
+struct vfio_device_low_power_entry_with_wakeup {
+	__s32 wakeup_eventfd;
+	__u32 reserved;
+};
+
+#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
+ * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
+ * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
+ * This device feature IOCTL may itself generate a wakeup eventfd notification
+ * in the latter case if the device had previously entered a low power state.
+ */
+#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.17.1

