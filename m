Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620B652E064
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 01:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245743AbiESXOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 19:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiESXOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 19:14:04 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2044.outbound.protection.outlook.com [40.107.96.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38014F688A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 16:14:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GF6iPTb/GgMWIO0HJxJj28j+ZMT94ToYZRpAR/yYROvJ3sIM0fXMBVwS+7Lo4uPjZwXeCZQEV4G8b434vE0TBzlmKAk4dqJjZX7Edf+exCvapIckm22eTWiPHyCfgLcgTvLv3lSClNIl3a1kdUoUTw8l/C+xn0EPPpsIECMcXdqv9X7/UhAt8ONsZe+lmm8jPt25Prgg6wcHNDQ7eD428UMFO/aRoIb/elA6fGFiNwCVK0ZB8meZSoKmhvvt3WcZ3LTfIPg6Eae1KthXf74qjaLX6HCJgmxa7mxlhuzUYMSTPEfFWRoCRMqHVBgCHmUO+vFzpEg6ZIzh/zgBZ3Sz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbgIovefvM9E+RE5ndPCmj91HRFC2cFEFtRb0VQqJxw=;
 b=I3ESqwLyCXAlV0EsLiucd2H6MBaZ8BuvNXzfzb0U9yCBUHGrtAVVImugEHNFfSitjkgc7B9wYSLKebIqO0BiCPi2NfqpaB2f+GHFy2s5JNneYE5lXDOBuSSDdHvc6f0JDxKPT5HnwxaV9Wjpselxo7a6VmwKk6/VmQnxNnXQXRc4CqHnAvcjZ/gFGojbFEbgAsPWBvzMIStg2PngSxLyOL3ltSoxPKVLZlJPhnITynzTAd6zVozZEUJb/9VNkD0d8Ol2uBkgLyg/Qg0opcBTrGgO+aJ5fdiwI6HkTkUW6uS5LLXqK2OiPZOsatybnbTFuFuBPPvUgWWNo4BHtkMY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbgIovefvM9E+RE5ndPCmj91HRFC2cFEFtRb0VQqJxw=;
 b=kwTPK92myAIyeDHmLl2zTt/Fw1lPWMYoect//BYu5BkLjbjN6dtiIVmIjQBphyuYCycDtaBxJYNMpaAotM0KaIfW7MV0HVfXAtStuaNjzw29V2ove0vvvoHEWKcUvjXo5U08ITVAdNuc33abJ+K1wAAXi7BDMcrUf7Ul22Xuhj63VeKlZ8pElqBlawAmwZ8eTjpxcSP6mIyIaSipSLW1nkRfLAyE/pUy7VZKWxmQ0AG4jgC5+Z8ZILs+mOB2hYICdODcvkHEjdIjiT9TK0AxWQKyCEH1288YiuJE7p/66VqWZDJkyw4b055rAf77fJX8o0Pc3r/Jytn4p2pz2tyNSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1450.namprd12.prod.outlook.com (2603:10b6:4:3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Thu, 19 May 2022 23:14:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 23:14:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci drivers
Date:   Thu, 19 May 2022 20:14:01 -0300
Message-Id: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:91::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbdcea8d-6f5a-455c-dedf-08da39ed4348
X-MS-TrafficTypeDiagnostic: DM5PR12MB1450:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1450EDD0727D66DAED9181E0C2D09@DM5PR12MB1450.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcBry1f5Jbr36/iv3wW4IBqyTh+gtIyngN9a8Bh6s8hclBknBetPdBdZpAJwrvTN+LL1WztmUh5OuLjGwAxzv7yfJFQtuhn6if2YkosvR8B0cDXipwCE9S4TrF9V8+okEFplo1jd6clrr5fea+h4shIURKD0Z2FsfrqIHN52IS/TK6E7kooL1Upf/Jdz9fc1lhLQcTTy5anOD3MV9wQeVIDsjs7Op2sZu22vN6vVMYHsJufrSpD9xhN1W1R8GR+ZNBeiEbt5psjk8zgdJ/JTa5X7GzPSAOcRyYNa8+Hwgd+5Vu9Vrn5fu11+3ZfRF6Jm7lMRXJamDxD+GHyrgMf2PIrv6JU30udSVt6R2jb1MdkeaWehE7B60e7KjH9oBQGHC0gpr84fD9YopnIKsjwWDDHLSd7ZIg7XYOlHg6slf1uKAfaxwoFGB7QHaTZdChGsm/1S2pA7ltwdU1R0dhu8RDOmEqgruIHBcsZrzqN2DDpwWMnTfGBoRECnbIqBX2T9yX3ldzCYefOMLwqAqb3RxCgCFgPi7gM0aH9wy16qCCj0QdaOyfXBC55YeRCibrvja1XtDX14gHQNOigCWaFGxPs8z7DjmHu8HY+dBF8VpfhwRhGiulWNgvmIaddiUCppNNMF0jkPPPimPoeCtDA5dSD8yzkWm7Ju/jZeP6JupyoSj4iZNU0FfFdYRzHkDa7hmIpmg4lleweN2cZJUymD0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(2616005)(2906002)(6506007)(26005)(6486002)(6512007)(86362001)(508600001)(38100700002)(66556008)(66946007)(66476007)(83380400001)(8676002)(110136005)(54906003)(107886003)(186003)(36756003)(316002)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vbiheOUXoMqNsfQr2QBsJS6FwVnJe38SKXShohJKbWrGXAqXsCYoMstfS827?=
 =?us-ascii?Q?pEgzMvaYPgy6Ulnw9VoP4llc15o+r3Etr5IOvWpTLefyPfOS5mDKSqyrdTZJ?=
 =?us-ascii?Q?9aWVluRB4fOsuUHGrTROeE/h6v872l9R920FDhj+EBt8nkRGsNRgQ5GTZ7QM?=
 =?us-ascii?Q?Uj4ockZDo0FhKZJX9AHeOsZsETPAd5Vvso+6QtIAGcDtdo2G9uB3U+pgnNsB?=
 =?us-ascii?Q?C+N1yl9/G67TOLCyp0ZnhWGIKx3J5SZ9oJkIGXnuUdCrj5QLRDiOfSme8nFO?=
 =?us-ascii?Q?rZZlsZs2qJgfwQgKM12i3s3axScIHemaSVWt8wkwXhfqpiM7cf9WkRCFFbMT?=
 =?us-ascii?Q?OADkTYQ3vppxOl+0zXONTst9v45UeAQkW4q/6ltW0TdXrj4SHmVxlRVaYdHj?=
 =?us-ascii?Q?wMmiMac6mMfzSplYQBiig7OQdFSx4Rtm7qWzYQWkRsYlPLaYE4LHnCHIvffj?=
 =?us-ascii?Q?gRAg0wSDZTMxfy3TX4ZHxTwlVuIsb8aQMjMoebstYQGHk/+uKrcElGcfgjRw?=
 =?us-ascii?Q?lnwYiWr2UfBLNqlmqHj/WSB+g6hUCj769od9IeRX3540XsDz9NYMd4hpxdYo?=
 =?us-ascii?Q?2qsQ1ftu9wgncslSqEvkUv39H5hAqk4LT1M3jiSF4L2uSiyipdttEDI2fTbg?=
 =?us-ascii?Q?px4qCL4r0N58L8Oi4I6ALrEZn3rWHyT+YfEwrG2oiPtMVnnzL7M1vQ1UKGie?=
 =?us-ascii?Q?uqBxIeX0FsDsBGnRSInPUfWoivTAGkQSqVpkY1JLwckYvJCZLYrJnLgwSESs?=
 =?us-ascii?Q?O2XDozKxQbchRy5H3JYot8om2S4L5SVI2ozHJb3FnUdDgrqRnqsIpUq/4SvX?=
 =?us-ascii?Q?0zLTwLnQrU/UFB2cnyJH1OxCTcbIf98Y8GRXFQSlCMXxYRwVZBBEerPOWFMY?=
 =?us-ascii?Q?Z3thzDI7EqdXpw5U5Rql9MvYjmJHXYCHl9UNelOVJ/S8P0KKDjy60tjoodMg?=
 =?us-ascii?Q?r3jPKxoO1GiqVxZNYxSgmVUjzgDycxURTCMp+KgbBWxR6mJgeHJouhNgHixo?=
 =?us-ascii?Q?3ksIYCFMW5cORj7ZlSLSvWmQ++jTvsCv04d66dTbapZzGpDkUr4++rWU10Rs?=
 =?us-ascii?Q?niGIsRQh/h+irB6jU9HzBpIiXJmea1sml5PT6gMW1vheVNLPel/r9fNydaGg?=
 =?us-ascii?Q?DdqoWXxAeCMOlLV2vgf/VAhcj5LxerkM8GOiU0eZ/YTtedV034096ZihNHNQ?=
 =?us-ascii?Q?ZKPzPxaGyyCtdsKmtuFMcvH5MCFJlKqWgZSyJCJGclmBGSiDUUIIfgnKXrQt?=
 =?us-ascii?Q?SWbSdoo9wthupVZzRL2KG9fvRxwDgf3rddZEoVUDKnKTBdrRCyp8aObzX51J?=
 =?us-ascii?Q?2zWPwNbGA8Q9NQAhFwW5zQeglhZHqTuyoh+Y5A7FwzZAEPPYs+7JKkhcUJ0V?=
 =?us-ascii?Q?kKU3aAml//yy0NI1UNnqf/SNF04U3iU20HL9qfR3A1Pk3qkK2YAvA8UryXoM?=
 =?us-ascii?Q?+ggtljRR3hPgVMqQ/yhtegbfARYDwWNbVnyOmS0y4lXWA21G/sKH7GKNskiG?=
 =?us-ascii?Q?ym6I/5a6dJNyY9bCtPL1uZOC+MXsralVT9zhEf0Gd6UTySo6UK8U71bAFQm3?=
 =?us-ascii?Q?L5PtrVCstLEKBgSxnWWGSFDqQypc0erHs4MfIQVjf46SN1mLWUKHm9W6Vs0C?=
 =?us-ascii?Q?+Ph5qlw4RRJnH9V+UmynuyajrK1nBAjihZgu7zisbshYE6eu3bsnSM80UwrO?=
 =?us-ascii?Q?/HTmpHBkZtip3Scs2ci9LfJnPL1WUPv0bul7JgCTpD0zhu7amPDPumP0BW9F?=
 =?us-ascii?Q?OzCU+ZOgLA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdcea8d-6f5a-455c-dedf-08da39ed4348
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 23:14:02.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9QPKEpii6CDqRKSpIWpo2ogtwbgr53mmzmTTacOFy2Hl3brSJszQxid1CzKzqTj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1450
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        LOTTO_DEPT,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the iommu series adding driver_managed_dma was rebased it missed that
new VFIO drivers were added and did not update them too.

Without this vfio will claim the groups are not viable.

Add driver_managed_dma to mlx5 and hisi.

Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
Reported-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 drivers/vfio/pci/mlx5/main.c                   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index e92376837b29e6..4def43f5f7b619 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1323,6 +1323,7 @@ static struct pci_driver hisi_acc_vfio_pci_driver = {
 	.probe = hisi_acc_vfio_pci_probe,
 	.remove = hisi_acc_vfio_pci_remove,
 	.err_handler = &hisi_acc_vf_err_handlers,
+	.driver_managed_dma = true,
 };
 
 module_pci_driver(hisi_acc_vfio_pci_driver);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index dd1009b5ff9c82..0558d0649ddb8c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -641,6 +641,7 @@ static struct pci_driver mlx5vf_pci_driver = {
 	.probe = mlx5vf_pci_probe,
 	.remove = mlx5vf_pci_remove,
 	.err_handler = &mlx5vf_err_handlers,
+	.driver_managed_dma = true,
 };
 
 static void __exit mlx5vf_pci_cleanup(void)

base-commit: 9cfc47edbcd46edc6fb65ba00e7f12bacb1aab9c
-- 
2.36.0

