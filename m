Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F94566085
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 03:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiGEBK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 21:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiGEBK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 21:10:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E5EB1F0
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 18:10:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=io4+a+24LTFjlVcqeSLlRmZQKKt48SnRsO25ZAnW1u750E1gSJ+1kx2TvlwxX1UfCV/kRxPRjGEMLIkYKjX41NUoQnKvJ1FbtUQtJEKU9XDqsEuN+yEVVU/ipBxqov0z8lDP+qIYSC2xEt0qPKvb/bJAJkIIdlCEkimJd7bBBA3e9mSo/AfEpZVMGpiPebZNUZ/SwRr4Q7Jd1e4cKIKfGBdQ+sb22lc3aksx1qkP6Kn35ibTRinAnkrhuQDAwTB9miZ+OkwuaAeNFLGhC0t61w1+3JEu/SB5IX27ep5tUH+Q0jUXHd6Ig2CUPV5s2AP9cE05Zlad78Irf+CuCEarDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rL13KEnaElmlywaUkf0uyv6BeZC7krLIpo8CdRh3K7E=;
 b=RHdrKY9wIj2AsW98809jNoR3b07x/O6YLHMamLDMZ5t3iMTIxD6UoaVPzo7ISaoGAauL9rgHhhGDLG6XN+zijY81TstbqZ7zE8rIWqdS4QdwMmGK/NQQmyWKSkQjXIfY88z5l/GqB7sFUYdfi0bExIevnpFEabj3ZP2aqTy2bKinGXQUNLHE2QDWWlOlnQL2oOFnQb7qrDsoncemfiw5rvkt9wbZZfsuPlpgprJMsnKdZSQa0ZiMCiC1x+XMZ33JJ5YzYsP/gnBBc+3FRkZP9ZobnXcr66NfWSdXPhZ1bhls3LThwWCtJVg+jsLdrL7j0IgdB39yAuN2opEZCrGr4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rL13KEnaElmlywaUkf0uyv6BeZC7krLIpo8CdRh3K7E=;
 b=pkckHe+xggQ+B/WEDbYCk3B4KGBkaZN4l8qUt9gcqPDTuyDzOHdemDfDZam/BXEXEZrpnBpC+4XMUGW5auEZs20nu8cpLycZsGO2wKajdyQHLoa2eVduSQIOqjA+gfztcXFxRYVfCOI4dBYoPjJ8MfiOVP6dQS3glHaN2wJqy9k2MWybZjOxJBLp1dDZEh/CBkOuVtPVrlVXDoPx6MO8IaKQW6v/rRbtnJHsNHPD5/GgFlJOSu4dtkHcXWngl7bD3lA6gAltI7AcHXS15MENoXRVncMJKqcjqd6m+M9Dmtp6fJDLTkk76cM57xYDjU6dsD0CELgKwh9Ua90W1p8gxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6465.namprd12.prod.outlook.com (2603:10b6:510:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 01:10:52 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 01:10:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH rc] vfio: Move IOMMU_CAP_CACHE_COHERENCY test to after we know we have a group
Date:   Mon,  4 Jul 2022 22:10:50 -0300
Message-Id: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:208:fc::46) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b734ba9-69eb-493c-0c90-08da5e233460
X-MS-TrafficTypeDiagnostic: PH7PR12MB6465:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkWSlVM/ZU8NlKJIopHpjLr0BUXKgpL/VcV8bBfzXDzm+VOLdKxRmUfr7HBLCVll+V764d5rw0jOneuBwsrKXXBaaJ8Mjh1GGJEz+kNixKV6S5ZB5h+jUwWrsFqO1c9Hi0qbBh/xvj1yRLqD77d1YfkSFDGajhrYfr5XPO1c8VaetkUC4Yiy9HxvK+0FtXsyNC8j8h94iuuUC7kDe2C5RW6/ybW6Wd4QtkWCz2QohL1qy4LwH1KVXfWUn8NE+kBKT45wmK0vaiSPWNwS0ormihe0t6WqvibdeElgihuQ5X0D2n+NazzO/OKLZQAsI23dxebMjcKjQCQspL5empmFERKKwfPG4b2FDGBIsa4KRjbzD5nDlThNyY/yrkt/nxt90PYHJNxZ552nK3xANTQmOFPT7Jn3+HtksUumOnuxX/yIAWzTogrm0/pKOYEfwRR6oOMwS3HqjPDfdOdyhy2Q14kYA+tlHM9bE2hYeC0OuKpaiCeMfQbHEb2lI6Bv5Y9KVzVfznwAK31hNdbEPz+6T8VWINAoIwtjPuzCHtO66ZbEFgMxKg4BrBncoVn4jRxUBh3y2T3PTjdXA79rGXsNAi1NYEfkGh1pyVl9Xf8w5iBjiXJvTPh4sFK7SN4Jd+cDktjhaYYjkt0HJs4GqKQ6AQeuHTRKd4iPm9gJJg1DB8lsWEcOZZbqZTs1IlU1EPhEQNY6jntQ2ApjBzKSPmSIED3oRvkdnd43mcREhOS7GMYhP+VTtL7Deq2AIUF1Hb4Et9Z1f4pHwTTY2hmCeGRVPP+fcVW0F3JO36PpS7LN5DMzb+8C42yABbK/iaYdSCXx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(6506007)(41300700001)(38100700002)(66476007)(2906002)(66556008)(83380400001)(4326008)(6512007)(26005)(66946007)(8676002)(36756003)(8936002)(5660300002)(6486002)(54906003)(316002)(2616005)(478600001)(86362001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zQppMkAZOf0h0VKGvLeFoLH7a5VmGx9d//wXMsXIl9ltFjUJnmwLoAv8jQWK?=
 =?us-ascii?Q?1N71NM3RSyMqdUElbQ+M1CpEojfyF38VsRmFgWmypGFyvGzLDhEONDGkV1Jz?=
 =?us-ascii?Q?yORGAl+3OF8gNmizTkhAPoz9vM97cl5s2Wktrgaqw3uF2NN+rKhcpyoKz7VI?=
 =?us-ascii?Q?pD9vkgD/VksHKuv+sMkak6vmgUeexXz7/ZyHsG0JMkVBC+7tob4pNY/9AnXn?=
 =?us-ascii?Q?8+IRgvczcdJ7WTvIzr3jSVO8RtsH4riyNVeBp6uWzSTmJgjpEz2Nadv/wACl?=
 =?us-ascii?Q?s9i6OyKUU1Rs4cyq/3+9Ar5fHaumc3rAbmw1qDdO+BnZApQJjxwA1KhCRAaJ?=
 =?us-ascii?Q?2fAIqUihFQnSgwWcUaacTz0bw/iRmJdhAmqDj/D5hCcLD/V9OExz2WCHIwCe?=
 =?us-ascii?Q?tSc3UnlCzASxc+NXdMXIBigr17DIkHku/KU7sKK5XFbrvPcgl9N72ycHsJ5T?=
 =?us-ascii?Q?gO9tSRvSyymkL4qh2uJ5bWvk6XnNGof1bbLg3l0ffO4AE4tWTsPaXr81hkNY?=
 =?us-ascii?Q?hOFjsrmR2vzDN7V0qfbFGE5v2utip88YAE9iVgtSQdLv9u86o/tkB9oQUKox?=
 =?us-ascii?Q?NflQ/6zdUfyQj7ad+soSW4uqDaqbTRUu3QMHDBrSANJVF5TMqc/9uIv0FxI9?=
 =?us-ascii?Q?ZuaK4dXoLNwGR0cPMuc921BBn5DQP5Qpw3D7bamo0VCeqtWnw0BLzyOoMsga?=
 =?us-ascii?Q?CxAeA+O3MtK7p3cRcYNhA+JbZxtd1jr7v869XpHdaC0jJPbkwI16Tbxd7BRR?=
 =?us-ascii?Q?HinL5Algx/sr1YHd7Ub8eQAx7z3VImPFs4N5RA7FFp/GwztTUts03KsPZHuB?=
 =?us-ascii?Q?pH85C8UdTSdRSwYcRMXucmG1o8hcST9Ld6ALM/TFoKZHVyPQZ65pZs0d25SL?=
 =?us-ascii?Q?MjCCBB6H3BUIcfBJr0NMnlduJblZrR1utAfUvzH7By3bseiio02AkA5NHj2c?=
 =?us-ascii?Q?vLomtx+fKaevE7gkcPmHCMYd9HoG4VRFAnjQEsfFeeUDsMFwDJkmVD9tQlyj?=
 =?us-ascii?Q?X0MIuy4tHiWGFIRGWPuY4Wd1Rwh2Ekazx0LQpptcWSIEmMYsPVPJV+tz9wt4?=
 =?us-ascii?Q?aApbzdOJdPTZhOmEiXMgObzQcQNGYILCjlyAbMv+7MS3wY6QfOosNm+uomK2?=
 =?us-ascii?Q?2vEzJPtNx3vZIp2/BFR2dnocRjjlmoKG7f1S02tzGjhYUQcOhST565vI66zz?=
 =?us-ascii?Q?lTGEDzxvo5D/t4lLh/5NNfEHEEMcxlPLTd918tHXQxdQtYUCxVJPWN7BkIZp?=
 =?us-ascii?Q?m6u/e6xL8uD7i+yLcZgIpp6iGsA5fhywnEctxOcH20TvZ7cK5zla8XE6Zgde?=
 =?us-ascii?Q?Hh18jziv3O2xpM6NVPuIo85pJTkna+KQ7ge3xtNoDtbjeX3sCGlA5HZs+Pg/?=
 =?us-ascii?Q?EBadTchEs0fsi2NM0bGA6fwGoxX5s7MsqWdzkPe91Kq2+zRxXd4SheBRZVIv?=
 =?us-ascii?Q?EoYCt1OaoXinPM0Tt2bpIE/5JXvACSUKFkRjHnZiv9aKktVU5RRwqDuHZtzw?=
 =?us-ascii?Q?wlX3uvVnElV3/oN48Hhi9dvOmhG5aDbPJLggQX7YKnY5kdD+JXo93DOyQERT?=
 =?us-ascii?Q?lqx7orHt6X1g3MERF/m3u7sDPHE9kfIARFuUYKx1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b734ba9-69eb-493c-0c90-08da5e233460
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 01:10:52.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Zj94Z5qgwn0yICpqJ/NiTSjLP2Kwy4HQkuSzhX/YHYbV/IPqZwr6lGcu9WgPfpw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6465
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test isn't going to work if a group doesn't exist. Normally this isn't
a problem since VFIO isn't going to create a device if there is no group,
but the special CONFIG_VFIO_NOIOMMU behavior allows bypassing this
prevention. The new cap test effectively forces a group and breaks this
config option.

Move the cap test to vfio_group_find_or_alloc() which is the earliest time
we know we have a group available and thus are not running in noiommu mode.

Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
Reported-by "chenxiang (M)" <chenxiang66@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

This should fixe the issue with dpdk on noiommu, but I've left PPC out.

I think the right way to fix PPC is to provide the iommu_ops for the devices
groups it is creating. They don't have to be fully functional - eg they don't
have to to create domains, but if the ops exist they can correctly respond to
iommu_capable() and we don't need special code here to work around PPC being
weird.

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e43b9496464bbf..cbb693359502d9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -552,6 +552,16 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
+	 * restore cache coherency. It has to be checked here because it is only
+	 * valid for cases where we are using iommu groups.
+	 */
+	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
+		iommu_group_put(iommu_group);
+		return ERR_PTR(-EINVAL);
+	}
+
 	group = vfio_group_get_from_iommu(iommu_group);
 	if (!group)
 		group = vfio_create_group(iommu_group, VFIO_IOMMU);
@@ -604,13 +614,6 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 int vfio_register_group_dev(struct vfio_device *device)
 {
-	/*
-	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
-	 * restore cache coherency.
-	 */
-	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
-		return -EINVAL;
-
 	return __vfio_register_dev(device,
 		vfio_group_find_or_alloc(device->dev));
 }

base-commit: e2475f7b57209e3c67bf856e1ce07d60d410fb40
-- 
2.37.0

