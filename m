Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC23D51646A
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 14:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347182AbiEAMgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 08:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240202AbiEAMgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 08:36:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C935E762
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 05:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0wuqj9JOdgZzku9kN3BEvTT7T3dcluZTAjNG01/BANkslh7cR2abuVvDmh6mM+Pf/ebM1WIZJmon6ynkslQe20veTF0Hw3xQ8J3pcDZTJY/wqWj4pt20Y/gdAMwZhbLdoJEPGKi+NEd1T1MifoWVrZNfw+J/K2/gB7Xk+8rPFfBukiC8bQnhO3PscnmmEZeCnvXwFXSbuEPnm+wTwcAXv0KxEVDr6pBNTFu1s07yRX+qZTCS3O8pvmFi4D8cPaGS9skw8k2KqXRhIVowkJu/GUEoTdrdNDydl40RUfcQCJ+7IBoNAR4OfhfjaPi+jopEz9dK1l7ThYPAagqU0ozPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/fXH28bFuTVFXAB9ZJS9ixeOfqgpbEzVAlVPEsnqsU=;
 b=XIvj+ktYyCBQXk6HXBM7A8S9ngnXjM/BFFm4rr+AifeZuSZiKAvuZS4gae0uH1XpHMaKVZ68oYT0vgb2TDojvMhiobzh4XLtLfRE1btPjD6jTRTaawre44h5ad4DePzU8Yf3zNxsIdh1DxfZHaWSOV5phTQ8SKdL/V+r3cWfLpNxJmJ6QYLR2vjL+Nj7Gb9pAkwhvhzw9zx4ofGfa13YB3tnZmY1F4k4PnwH3VBRV9SEZj3YKs6eGhtltoj3JiHq8fenvnvIosG3UcjOBrIbvZ9XfsawQSnnWT8xo/zBfNcpUOu2B5lYNCJhlqaDbW4vShgXD7O5ncPVB3hGYFG7ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/fXH28bFuTVFXAB9ZJS9ixeOfqgpbEzVAlVPEsnqsU=;
 b=XEOyWe3qRO6iS5wa2vVBYsrWu3qb80VXityqmkJ2W3zZ0oRDEcrT7q5kJs2qQ9P31Tt4Wd/Y3wAS0Vy9NghcwWNEEDf92saaY1Ul8syIVlqi6Zn4bFkmjPY2EmIS4a0FYBJHH3HKxyHZVfsnNAPDXtg+D6ItP3m/gFhG1+B62/y0ZlJBscK/LhXgjWYYbTLEvR5eOS0dP0XhNi48Q2KtJp7xESGi8YbHgMcHL9wC7TWuK9NEI+1Eg8rUyVOOGvgnQi+Adiynnm97JCzSeOAq42D3ROkvAb6lkxq6dZW7Y/ugJPiUnmuW+vsuRH4h3//rC46E7yVhAQclevvCnxBoFQ==
Received: from BN0PR04CA0076.namprd04.prod.outlook.com (2603:10b6:408:ea::21)
 by SN6PR12MB4688.namprd12.prod.outlook.com (2603:10b6:805:5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Sun, 1 May
 2022 12:33:25 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::27) by BN0PR04CA0076.outlook.office365.com
 (2603:10b6:408:ea::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Sun, 1 May 2022 12:33:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Sun, 1 May 2022 12:33:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 1 May
 2022 12:33:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 1 May 2022
 05:33:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 1 May
 2022 05:33:19 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <eric.auger@redhat.com>
Subject: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Date:   Sun, 1 May 2022 15:33:00 +0300
Message-ID: <20220501123301.127279-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cebe83b-3dd8-432c-2ed1-08da2b6ec901
X-MS-TrafficTypeDiagnostic: SN6PR12MB4688:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4688CF02ADBD95575320DF45C3FE9@SN6PR12MB4688.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REnnY6nRZV+T3O5w2qJ4NAnaJhJqM6ItlM8ZGdC6/avR4LsSRxMn86mfcbe8VK6Hf/U0dP1PuaUbflhdltDDb84W2YYMwzzQvsPMXwBoqp8u1MzsAUKb7Oh4rSTQU6QPYVZC2PZOT1vLC9UENGDwiXceoOD8/jFbbx50QnH4wRAg0GrDUTI6OA7X1eGAuSvwporAiTsiF12zlgzBMHRVEfvBMSBQyDZFk6At3GhYBZRFfJtC8cmFR5K4UTjA0roiYUZ/WuUZW//YHQ3GhAkItO29iU5bg5ke22Ge82NQ4/joT3/pLUpZsM5J6NqeBlfJwF5toR5jl60MDhzRfx0a56cwPXzsNfwZ7oQv82H231vugjDEu0MCuvLlsJTXyubW2LXro8xuZDBh6mBvSn13coeBgMdKe7YPuvZBv/G66kipgg1PYOIqJxCrhWYISC+YJF8qn6VjqdZZAK6NMeXt+cjC+Nw53J0MEkgXgl1AvjtEV5IscN4nFETjYUJtHnQvgY5KN5i/cr4vciRpcOEPwD9RIG2sy2eKSllK4mMkZyeTy4EMX+u2urCoAqT/oEg7WFfPWaU4HdMKmLi3xBUu+1qjuCj2bTnAKB3TnNnRYFuawcB/p8ysUjJmI0tqnOQ8rSTaQ7O1ybarUtdMaN5zBY4ay6yuQgkUoxCd4Gfje4mN31uEVNj9FwGSQLfoQoTbcgBYJyZ4C6R/4phee5VYdV0RwrePALE8l6lbg1k53m/eqv+WQAWuLA2RQG+NnNAsA7RswoZZaQJm6eQ2OzoZDvBDwa0LNLZgws2qjIfrrDs=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(356005)(81166007)(4326008)(8676002)(36860700001)(1076003)(7696005)(70206006)(316002)(40460700003)(83380400001)(36756003)(47076005)(70586007)(54906003)(110136005)(508600001)(966005)(5660300002)(82310400005)(86362001)(8936002)(336012)(426003)(26005)(186003)(2906002)(6666004)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 12:33:24.3322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cebe83b-3dd8-432c-2ed1-08da2b6ec901
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4688
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DMA logging allows a device to internally record what DMAs the device is
initiation and report them back to userspace.

It is part of the VFIO migration infrastructure that allows implementing
dirty page tracking during the pre-copy phase of live migration.

Only DMA WRITEs are logged, and this API is not connected to
VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

This RFC patch shows the expected usage of the DMA logging involved
uAPIs for VFIO device-tracker.

It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.

It exposes a PROBE option to detect if the device supports DMA logging.

It exposes a SET option to start device DMA logging in given of IOVA
ranges.

It exposes a SET option to stop device DMA logging that was previously
started.

It exposes a GET option to read back and clear the device DMA log.

Extra details exist as part of vfio.h per a specific option in this RFC
patch.

Note:
To have IOMMU hardware support for dirty pages the below RFC [1] that
was sent by Joao Martins can be referenced.

[1] https://lore.kernel.org/all/2d369e58-8ac0-f263-7b94-fe73917782e1@linux.intel.com/T/

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/vfio.h | 80 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index fea86061b44e..9d0b7e73e999 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -986,6 +986,86 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
+ * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
+ * DMA logging.
+ *
+ * DMA logging allows a device to internally record what DMAs the device is
+ * initiation and report them back to userspace. It is part of the VFIO
+ * migration infrastructure that allows implementing dirty page tracking
+ * during the pre copy phase of live migration. Only DMA WRITEs are logged,
+ * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
+ *
+ * When DMA logging is started a range of IOVAs to monitor is provided and the
+ * device can optimize its logging to cover only the IOVA range given. Each
+ * DMA that the device initiates inside the range will be logged by the device
+ * for later retrieval.
+ *
+ * page_size is an input that hints what tracking granularity the device
+ * should try to achieve. If the device cannot do the hinted page size then it
+ * should pick the next closest page size it supports. On output the device
+ * will return the page size it selected.
+ *
+ * ranges is a pointer to an array of
+ * struct vfio_device_feature_dma_logging_range.
+ */
+struct vfio_device_feature_dma_logging_control {
+	__aligned_u64 page_size;
+	__u32 num_ranges;
+	__u32 __reserved;
+	__aligned_u64 ranges;
+};
+
+struct vfio_device_feature_dma_logging_range {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
+
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
+ * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
+ */
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
+ *
+ * Query the device's DMA log for written pages within the given IOVA range.
+ * During querying the log is cleared for the IOVA range.
+ *
+ * bitmap is a pointer to an array of u64s that will hold the output bitmap
+ * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
+ * is given by:
+ *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
+ *
+ * The input page_size can be any power of two value and does not have to
+ * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
+ * will format its internal logging to match the reporting page size, possibly
+ * by replicating bits if the internal page size is lower than requested.
+ *
+ * Bits will be updated in bitmap using atomic or to allow userspace to
+ * combine bitmaps from multiple trackers together. Therefore userspace must
+ * zero the bitmap before doing any reports.
+ *
+ * If any error is returned userspace should assume that the dirty log is
+ * corrupted and restart.
+ *
+ * If DMA logging is not enabled, an error will be returned.
+ *
+ */
+struct vfio_device_feature_dma_logging_report {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 bitmap;
+};
+
+#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

