Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353B963C967
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiK2Udk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiK2UdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F57686BF
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW2yO+nNw26rI29QWptr5ZcwV2GsZKHkZJeuQ2PFOqbcPDeku2czysSAvqkuDrrUeY+s0IQNsWevG5l+UljTUc9g56Xzizj7ssBl8PpB/XDSWP5iWCSOpSssDcP56dfPfdhS8x2ZMtbc/qQvjp+ReMyx9nTEg8uQiWdFXpmp2SXumMxHLzJsW1YOOkcnnOt1t7gCpOigdIhP+KoRE3D4wNmJIXfnQxsrfbVArj/YnUiWY8PVDnQUhgK3k6AaF1GHeuupBRB1aduAke9+tHNTmuf8FptG1v69KwZ8f3jkR6J8ZWyYIC9dcClMLPw80NZ57W3R3xwpN8CeVm22kE3FjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7QUjwHC1XGNl6OYKkp7lpyIPd0t2IjurQcp52ZhbP8=;
 b=CH3iHh5L3GxIawdwQH5hAtWVIFQRxdMhRLxmRDP9whFEyLIA2z5SP4A1aIU09SBV2VI/xKd9r9tBCmWKeshWAQK1PB6NE+vOu8Asy62jlDjUdQiZVRa7zbXqviPnwKqC1IPg+Po8ih0H5dHxy6vk6cQzIwy2BXEo8I8TYrfKnI+q96Y6hK0EUdlGFZ+poXKj/8KTtOPyAbHPzZONXJPgmQzp7hlNL1QpKoq4x0O5i2Ep3TN3ZLofOG1y6aQef3GCYf7uYhrQxxU5DR+x2ORCb3okjFmFUOGgiD5SsHSNVxFNGEjRzIiGpMnqpRcMg8Zfm6Y9RaNbwTFr5U/HxhiuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7QUjwHC1XGNl6OYKkp7lpyIPd0t2IjurQcp52ZhbP8=;
 b=W9zDsk+6E9SEX/+Sni6yizZZneFj65olAZeiaYg6K6Rjjs3COVdtjCYoRTNf16B2Ft9Ajl3f8GWRCepwuYwzgDg54ofREmjiYtYO5Tbohk5HOy+3Y5nDMeIRUaHlspF/VsjQHgwlpO0DmeAq5+38dd4fOw/PwZQm2XyZ2q14G+7cUQ4nBm540izn2BAOJ48J3ss9dvKh6c10iXOPvVnjDSM+JIx1ngoA/oenawx7cBgY1TnHYpFRFL7ee0Wv30TniHBOvVk3641ul4vv4z6gxhfSkzgFSdH9D2MA6gQkzQDlf1zKHTNS8HUqPhCU++/W3VnCGRg0QQIl9fmTUIg2tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:00 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 08/10] vfio: Move container related MODULE_ALIAS statements into container.c
Date:   Tue, 29 Nov 2022 16:31:53 -0400
Message-Id: <8-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:a03:100::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: d498e421-7259-4be6-405f-08dad248c35e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGyiwRjgxNgMJgZHHqSjk0Y/D8Gn7NrMWS4z/EZiO/b4M9maRSe7HvUNvrxuubqcqyLkAOocNUvxqYNuEp/VYIRUeqXOa9VYd7Sn+t7hL0bLZgw8lac5tovUlUb5SjLr+BLnb0nStNYMT3dGY8VJs03jiDeRF0cfW+8GbrYhmfmrpMVUjXtSFwjAgcAOvuIiyB67hT/RVV9UZslkTbsrW5KRNwYGGFxrdJgc2QqK4jFqVcaG9C9wG9S9njFO7YClqoAfki4cuZQvPwgvnvwcWH5EKdiSfBG0ZFE8T995kR5gGT6ikYIaeITYhzQ4T+2qQ4XdyRgBCvWuB+ZW2ZQrDZN/+I3dPvB7gUKL8pgEa2P3hCvyhCORBbgC6FEGly8Pb8FFcd0tjfJoNV4Rv50TPtnboC7sbkgM/mvx1LO9x11sZ3Rbl38a8VycJ97YHbWwoct+yuzPFJdgF14peEdgU2J0h60I4qQZxinYQP9YwQqjNuOk6Illo2LbDhGnFfcCRrNAGEfyharKWrevyA0UaYbStJf6fKBi2w3lOTkNNxy/oKakkXjy9wvJ3LIoVFSVrDJ8NXGC1RjVYueJEdFyLPhwd28XM3v8VFXDo5aX2TrpSxBwfAoATSjSelsDXIIg/9Cic5yMHNdJQNMztiu7jNIUdBQDfK0n+/ilakjmDs6hFxzvLMNttvL98ugMp6clAl1Vya2kGgTddEEPXVng5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZfKGoRXk6ozG51ZrKIwDDuJ1s2qHhZijxyiMjRlIOV2mldKyuxPZ/NglWjk+?=
 =?us-ascii?Q?+rgqpgkFBB5MaBhOqf1LdGLATo8U55l2+3ftHuKzRLKJAjcjyqFK5yuw/IuB?=
 =?us-ascii?Q?jusRxEjd7Bl9PbRaHveKAW1bBVkLyJh9Ey4VbOqr+yiMo2ySBRUhEMhM3LCD?=
 =?us-ascii?Q?do+rKrxV2y0Oma9504qD8rBcCPreXy/XMN+veQkbcZCrXrnBVk0hjRP+WSZS?=
 =?us-ascii?Q?KHmesld2cz+SmDVH7+S5P2nhClgTYF+MdebdIIGsxROu793SgDHTuPzK6IkK?=
 =?us-ascii?Q?zL36IHnmwkuSx1J228jSWrMFfFA7tYVGzFJOdz6CxDW+BddXbpj88ADe86X0?=
 =?us-ascii?Q?HfJZJ/+RBDCarTblTQepnOr3wshFBcjjktO8UrjyVfweW3o7LwHQocM92eUC?=
 =?us-ascii?Q?MYBC1cFJeJRVxC78t5CGWdahVZOxOyhtnq0T8+zkfpU6Kj9FlUeWDInMJVdM?=
 =?us-ascii?Q?OfSZ7MFdMc9GBHIES5zLv3qzuc7tJQteEOjK0GRoZT4HvIv60szYSdhWR4/q?=
 =?us-ascii?Q?W9/3olw9WGRc6EIrJqHePeRTmWrqQh0kRWs0K91je5OtaJ0/fmuAvNR8tu5b?=
 =?us-ascii?Q?7BW9R/fED/UWVA9H7LXWCwsC6U9+Ecr1I1WUe8LzjhawNDR6kuMP4XIw1jrJ?=
 =?us-ascii?Q?9TvbW8w3lkmbzNJDQPRT2CVUHvTWOvnADjeT6+/gYhl33o+M62DxMwFKrMSn?=
 =?us-ascii?Q?EnuOH72xJ8rE/dOFfj5R/scGcMMqNaYjv4jIUHkbhrwvn27Op2T/6h6t6y49?=
 =?us-ascii?Q?g3IKjmlD9RVrCWubcOiqlq5PmTsbXOtda3qN1by85OSQngRuPFBKkLDqz+JY?=
 =?us-ascii?Q?AwsnQIntsD1e/+w+gJsFcF+F0K768J1Zlk17EFq7MmquNnraWht37cIjTofW?=
 =?us-ascii?Q?LpOppSMpSoTlW427k6Q54vMA0t+9mIxy67jh3VcJKyUghwA5e5Dsj7uOYJmL?=
 =?us-ascii?Q?N876nW/F4l8hibYFhyi59P9caabgZ9nH114fKqMhl9z83VRMoMe9ESRnAjnK?=
 =?us-ascii?Q?2+80H9KxEX/YwwchvLWdgnFA3trH2oCHiSKwiv3x/kfgEfk5hA4E9LBuyNAW?=
 =?us-ascii?Q?2jKLnmCko2mPm9+r+Llr2LcCU3B8AbJIhhqbBD3j7+Nhgph3OlKNCT/KPPZk?=
 =?us-ascii?Q?FTkwWFhiQb0Ev9mkMFXC5rL8ucIOXC3eCjHjDYfpQNI+zBUmxUC/XD3UblP4?=
 =?us-ascii?Q?O/UcWp5m2DG45IAVP3zXScmYqlNK+Zirqx+hNFAoAy4J1XGiQiPCgL6zDK6/?=
 =?us-ascii?Q?Jvw12ebDhZTSEB0j2EzC4C1PicBFHrwlHkNseKzqIqzMH8smO1xOmYk61WDV?=
 =?us-ascii?Q?J9XhNDoHYBmiBmNHxNfyc9CbRg8mzfEfa731j7o/rkBHnsTkfHB905DeR4oW?=
 =?us-ascii?Q?0PZReN7LfhoficDX1NgBZX0Gk1WESwIv4RwiP1tI1YJQzCf1oNcrNCZEsU26?=
 =?us-ascii?Q?BxBZW/Ylk8NO7JI/1jRoDUGkpqGxbHAsrMDhvcbkhHTiAMWKItjQrEOwGUsi?=
 =?us-ascii?Q?NBG84SD+jF/0xd0kjcNU/r9XjZxkliRWKSwFClkdPyxP1gF1wINjhuo95NzK?=
 =?us-ascii?Q?9zXRsOR+bddmFrlArcTuq+FbbF5D1dBaB7xpTTax?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d498e421-7259-4be6-405f-08dad248c35e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9T8Lc+q4kEtpIMJEm3EDGpLFZnJiG928eu1XOZ89LArYeGO930OQMFrpnBvznPPH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The miscdev is in container.c, so should these related MODULE_ALIAS
statements. This is necessary for the next patch to be able to fully
disable /dev/vfio/vfio.

Fixes: cdc71fe4ecbf ("vfio: Move container code into drivers/vfio/container.c")
Reported-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c | 3 +++
 drivers/vfio/vfio_main.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 7f3961fd4b5aac..6b362d97d68220 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -608,3 +608,6 @@ void vfio_container_cleanup(void)
 	misc_deregister(&vfio_dev);
 	mutex_destroy(&vfio.iommu_drivers_lock);
 }
+
+MODULE_ALIAS_MISCDEV(VFIO_MINOR);
+MODULE_ALIAS("devname:vfio/vfio");
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index fd5e969ab653a5..ce6e6a560c702a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2073,6 +2073,4 @@ MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_ALIAS_MISCDEV(VFIO_MINOR);
-MODULE_ALIAS("devname:vfio/vfio");
 MODULE_SOFTDEP("post: vfio_iommu_type1 vfio_iommu_spapr_tce");
-- 
2.38.1

