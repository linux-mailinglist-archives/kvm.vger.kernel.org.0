Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD6D5E6BA5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiIVTUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiIVTUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E20E62FC
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQk/du8DcM3zj7C6Y2b4ytu6AlCVfixzAtYb1rs5cXofhqVoUF5JrxKFQxdqaeQpRdfs1/Xv8x2i7F8GCPXWeLc8SkbjMnJNR7nOiQIaItNmG+pfquiU49xE+VQ5g2Ccvl0lZ8k+O7IkxBEwdEn90LVGTHap/BOdyoXxRkqohL/s/Fs38NPXBrdU8EO4gwuZAuWMPMblzXpPxEpXhlLneF5EjnylUQIdyCjDQ5M4O3+mJFALeM/mNEdwT7S165w6V7g8jfv56dcb/pYn7pQJvVo+cuJNG6IyUlWkicsRPjzWuCg/t5HJmq/3vUXvJBwYXL9f9NBMS2nyTRJyWhRfvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixlwgif2lIC+cscRiZkK1sWw4MH9g6P9mpQyGa/fg1U=;
 b=A5n2eR/YXTkeM0igppS5CEh8KW6UoofGhB2GpWxj2q4KJtxjI6wwd35tKIoReCYOV+JptIYuSsxZZLCYrZ5x9OQfPqJKgjqczv331rMSBZ3BLMtSDsB/zNHml0fZ89dIYb1ki+HmdHWH9AikwupvEa8Xojvi7p9JTErp7DFixgBFP4unOTwdz39N8g6XgZvxG3Vi4qwGy9HDdCbw4Jq4sxYudPBSkZ/AL8/5edGpArnZXBHLqsljtNKN7sMKi6xcoQTZsNW2jDqIkx9QNVS75nA02BB9s/jabwisngQCPwmEkds6+vIPmqhW5HaAZa77oLVNE8/NAMRNBlU+unxAbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixlwgif2lIC+cscRiZkK1sWw4MH9g6P9mpQyGa/fg1U=;
 b=S4/qNBo/ZQ1IDBlgnZxYqvFWHbCfDR7fhBSKI9h2Hky75sJUtAMKvyUSvu4Gyj4FkoJjQlibVOkcePv2bwlouo7BPwr8nXaif7i08+n+1S95stPcrAiBtZaKsWhg54fw8x6HtO3ogUKVcp6r37iQtKm5txJTQC3SrYqVcJefpws7OiGPKCW0GB3EhXmW6MwRSPHtLUmkxu5O9YbpKUIG3oyRUkLLTuKlyPEA/ZAuIfuFOxEiO8li8Eso0oUixFzPjYPJZ4PtrlovUA5UeygOBeoD+wqUQqnKc73+XZOU1MMVCsAP8ZnUo8MXhcEvj4+ErSgOAC4erY1OemvWEhNs7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5486.namprd12.prod.outlook.com (2603:10b6:a03:3bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:30 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 5/8] vfio: Split out container code from the init/cleanup functions
Date:   Thu, 22 Sep 2022 16:20:23 -0300
Message-Id: <5-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:208:32a::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d520f5e-8a5e-469c-0dac-08da9ccf81a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XASx131nMK15UxmBASqvTKkBCIP+EUz/lt+EviRMoX7eDeucPr9FOqpeZM012U2LfW8JoaDZV9TpbhMwiP2LMQ6QG2oXJntex4g6M50jf1Rvj5Z0Gi5hh1OKJ0cCX+HonAtweI9+15HIZchtR4ps+J88Zs/0rPj6xUGojmaCJAUYWUbi5f7+lgrbmt20Q9seKVAxsjOrY4EF3mbYtWl7TnHffzDCD7sACna2aa6IFSPGnapG5jce0cnQhdvrxk3OyYcNuE9cwAw6IcTrJb8NfJFskF7G84KdGU89VvZm3e3xzoQWTOBRpx1HP1oGDjYl8ApcQZDFzdmfVntb9OStdDJ8BMFjZaGpZ4L0BLmkEQKZrmxq73B0UcGeVTrY8goo93kybURxTNZ2J5OonzX9edq7H0I/cmSTi9MeSsdBP5X5fzdKQRI///7uyrK89I3OfMMeSsDI5jcLEdzPuTzdhjE58Jl8nlkYidBAKtBhsViHNQzH8EZszwuR//iuwAfmx9VBvzAoH97OCAaWOL8DJ6qdEqTi4vaT+yFHAnIN7C9t89AM0/qTzNjFHqU89FJkxWvN3QKf/+duDis4bkY6K8t2+aR0H3bLYdjNKuyOCwlB9Mipm9HRFOo3GYrcZcQreDeJqAIDyLO/MZWVbc2SbYpbJHpLzZ7UijYA4JXrkkPFwXxIb4s9yFHvliiKl4v/znTXKRDxwHhB1MZ4DoepwK+n0RKhG4nF8qmH1Di8gTWLl1I53LHfxEWJ2RRnAo9I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(2616005)(36756003)(83380400001)(41300700001)(6506007)(6666004)(2906002)(8936002)(5660300002)(26005)(38100700002)(6512007)(186003)(316002)(86362001)(110136005)(6486002)(66556008)(478600001)(66476007)(66946007)(4326008)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2sOefXwTj76EiqQcBZ1Puz3f+wwaPqLpyb/lBBTV+pVx0zD09KCJVFahLOfJ?=
 =?us-ascii?Q?KeDMMY6AP1/z7uTnvpUM0ysIWuCLnzaHo9TyN+Ky0bwId11Y035PuSCs4x8I?=
 =?us-ascii?Q?lYgK7C7tywpW7ChhxTZKcqi+bo5L9N720+trVk7Uf+Bd+Lt2VgV0hfiPVr+h?=
 =?us-ascii?Q?IZfUOF03WOcSkt8nMwqV+RYgT2BVdG9EGFsGqK5EUIf0evBBRMvzJH9FiB5E?=
 =?us-ascii?Q?l+aDs0143XTPyvZoSCIg8D+tSEG2P7uG5y+aoR195z+hYKTd2B8LJDpQdAUD?=
 =?us-ascii?Q?6gTmN+7nRu8/HDH60DWGexEPwrqLRJHPvkTRrtrLwDhYYnxFyj4qLLMP4YN7?=
 =?us-ascii?Q?Qw0/lRSE+7y3GvheWevqHDwO+t3luRFkjmjJWr9rhmIX21beJ8VHqb9ib39n?=
 =?us-ascii?Q?GsjPY3yvQu2tfgNgDyWwAEojm9llf7HxsFSAQfu9uIP/4+GJsIr5i4Xxm48a?=
 =?us-ascii?Q?LutNc4JGhMoD3GfKg+00BxhKLWIkj9OyN1/8CtIDP02DCXcbZjXhVFOCb1fG?=
 =?us-ascii?Q?UQHNeNtUWTMs30m0HN20H6+JmeivPvk5eBaDjYKHrMHt6R5cdDHNg7Wb+fKO?=
 =?us-ascii?Q?tdPuP/GBMyhQ/r5FbmCFYuao7v5o+dYKzlHHZKQ/kxlm7RtHt7FugyFs8dy2?=
 =?us-ascii?Q?mZuStqYokLRpqtS3mEkMPichd6V10IdT78ZTRFQJLgLfC00mdzPUjKk80nHg?=
 =?us-ascii?Q?39wq7YAmbxDzbVwl/+Sjt7GUUmXBQLeWF0HCSAEQr9CspTdg+uh+HsP9G9em?=
 =?us-ascii?Q?xyNdMS8Xsznt7gIY9zQDawsylaMDSLFp1RLHxHQw4XYVLT7SXpzw6IMJne5H?=
 =?us-ascii?Q?oqU5ER7WT1L4Ha8UzGlzmNUwr/zPSXjxPkT4whVBMEscgUbMmsriXc7yKjrF?=
 =?us-ascii?Q?zg/vCKTGtYO7sdblXVlPliRcbO55Fd0yNm/3j+BfTJwXVmgeKjZDt8IWtCT2?=
 =?us-ascii?Q?9R2jK75Oijnekok29+6upqCQR7tTiD04pdu7Iar2NpOGLujGRNNgcVnHxIBK?=
 =?us-ascii?Q?FRFUoulP0a7BmzRoC3OeihfWUOhJ0hZFAzPCR/S0fJsU/7woTg+9WOSQ/J5J?=
 =?us-ascii?Q?QmEv+2TMlepgDf/wKfRKakRQnyvbLp6Ubd9f7WHxpdCTPmsmRO3Pj3QDmbW0?=
 =?us-ascii?Q?06rBV3uLs4dl6P4rHpjFyQ0ns5aL35k/1sJdJD2EVo1fIcGww+kkPuvLfmFE?=
 =?us-ascii?Q?mOKzqZ7VtdCkEcJqqbrXQxpBnlt3sX3CZ88bgy9SEFApyH3gp54Gx6n3fT96?=
 =?us-ascii?Q?fG6zaEu+qcTKzjDzdzEgmz/9zRsuzWwhWEakTA+GdSazAstsZLYIL3HLHd4m?=
 =?us-ascii?Q?rZ4sv2rBMvnsUDiqZfrEXlizFYaoRRpVelpf0M2ODI6yihYvZj2H7Mb/IxaU?=
 =?us-ascii?Q?funXpGthvkYmrKOj4A3w5qeFwdaAC4pYdiKAPi4CFEWxKvO841683LsXpvpF?=
 =?us-ascii?Q?8fXDERze33l538dkAGhd4buegqdUPYHRieJvfiksHV7jysLFjjqPspYZsNyS?=
 =?us-ascii?Q?v1Yeh/ALk3CZGVIxLQ80js5+at2w5GYkDTgMmba/J/jBtSZVP6X+qR6mSvlk?=
 =?us-ascii?Q?lHg9PBaYAmArqgOs1gYIeL+fZwYgvIw9IbFkoWKo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d520f5e-8a5e-469c-0dac-08da9ccf81a5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:27.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tu7uXorhJrNs6DaGCkKKe6Dd03godOPdaDhbHjONAvH6qcX8+sLd5lVScerun1lA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5486
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This miscdev, noiommu driver and a couple of globals are all container
items. Move this init into its own functions.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 54 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f79e7eb02931b0..3cb52e9ab035a5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2397,15 +2397,11 @@ static struct miscdevice vfio_dev = {
 	.mode = S_IRUGO | S_IWUGO,
 };
 
-static int __init vfio_init(void)
+static int __init vfio_container_init(void)
 {
 	int ret;
 
-	ida_init(&vfio.group_ida);
-	ida_init(&vfio.device_ida);
-	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
-	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
 
 	ret = misc_register(&vfio_dev);
@@ -2414,6 +2410,39 @@ static int __init vfio_init(void)
 		return ret;
 	}
 
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
+		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
+		if (ret)
+			goto err_misc;
+	}
+	return 0;
+
+err_misc:
+	misc_deregister(&vfio_dev);
+	return ret;
+}
+
+static void vfio_container_cleanup(void)
+{
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
+	misc_deregister(&vfio_dev);
+	mutex_destroy(&vfio.iommu_drivers_lock);
+}
+
+static int __init vfio_init(void)
+{
+	int ret;
+
+	ida_init(&vfio.group_ida);
+	ida_init(&vfio.device_ida);
+	mutex_init(&vfio.group_lock);
+	INIT_LIST_HEAD(&vfio.group_list);
+
+	ret = vfio_container_init();
+	if (ret)
+		return ret;
+
 	/* /dev/vfio/$GROUP */
 	vfio.class = class_create(THIS_MODULE, "vfio");
 	if (IS_ERR(vfio.class)) {
@@ -2434,17 +2463,9 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
-		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
-		if (ret)
-			goto err_driver_register;
-	}
-
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
 
-err_driver_register:
-	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
 	class_destroy(vfio.device_class);
 	vfio.device_class = NULL;
@@ -2452,7 +2473,7 @@ static int __init vfio_init(void)
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 err_group_class:
-	misc_deregister(&vfio_dev);
+	vfio_container_cleanup();
 	return ret;
 }
 
@@ -2460,17 +2481,14 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
-	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
-		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
-
 	ida_destroy(&vfio.device_ida);
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 	class_destroy(vfio.device_class);
 	vfio.device_class = NULL;
 	class_destroy(vfio.class);
+	vfio_container_cleanup();
 	vfio.class = NULL;
-	misc_deregister(&vfio_dev);
 	xa_destroy(&vfio_device_set_xa);
 }
 
-- 
2.37.3

