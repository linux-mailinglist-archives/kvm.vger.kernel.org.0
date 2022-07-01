Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AF6563BF8
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiGAVpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 17:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGAVpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 17:45:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D846D56B;
        Fri,  1 Jul 2022 14:45:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBQqz/pSopS1qzI6QG/1iDKJnfcjN8CfvpFdQGmS6DX8SZHLU5YHSYx6UhJgjHjrzqErM8O0wWZnE6TtdJ7f9OzgeTSC1pfD/meZQuW6zbSFLsJccBsiLX4DSXKk24q3yL6PjmroVVhSYkmoW00QPIV0m3QpbVaWVlaxl6kO0oDeWgNxDkzQSTAc2naBi69IWxtLZFaN9CmV4sdZsoGkL+D4ylpq0HtGhL+lSzNZYcB34InfCC1nJg7ffEt2quRosnUurJ1shZdqc9iNam5CxAXruxGS8x7XghSyRAyYkFFNbwC4C23qGuyF/qVOFhLqh2y8eHAq3Umg1a3gmX3g3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPSGFk9Xx7MdNiI8/CiOFYiI5dvrJ58k+niwmyR8Gk8=;
 b=Dveucd0BPOjb5+0sVHIRPtfKyZ6FGA8ZdGDadWrW/nhwnHCNUKrDdT5z+SLNyC0DuDfVAnrGUWS3iMh4q86aPdUl4sEEhbQTmLlMbYqtbkrGLcq0rIpnvIt1p+schJ0s1BT9e6ozikP+wc19rgdA7nPqZ/bdqoG6yVhPREYwUHxUX1pkLG9nAaP3v4F47HHEYRXn1Oq0N43OAR5AhPaeAMQDL1E+oH0etulD3vydHqC6Hfks8j2zyCWQXIF6G2NAG5QVC2Eko2z3Kt3CtnNivfO4KR4VQAE3Gou69n5yny9CLDW1uIcRE4HiMAuMNipmRHbAY6qH5C5gZztRESu6cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPSGFk9Xx7MdNiI8/CiOFYiI5dvrJ58k+niwmyR8Gk8=;
 b=aHphjtJwbBsB9cYBtz3gqHeT9QwJIrAmgke+XF4ih51NS7c55DlCaut1PiLKMtm10+y6w+InER4y2JcUkw3d7UAhA+Bud6tNxQNGO6OLc/YVI6f8Euvx2RTzV1e+D3p5EVX6h4BEUzJCjNp5D6jT5Syk8ZX6wwtP5rCPhnBM0uw03Dgfm77mEDW9iA5pi9KuOg+9+Z5v3J/Vqxvle8nCCGT55VD4DHpq9JHMC72MxIjvDimpyvxz52O45gNq4jDiR1IWBznk2JtSDnvDTaDg4nFN7HTQGa8UTrogd6Zgt9kxudcgkpLOGhoRgKjJ4rV3YQTpJVzLcEvjE5U1tcSORw==
Received: from DM6PR18CA0024.namprd18.prod.outlook.com (2603:10b6:5:15b::37)
 by CH2PR12MB4149.namprd12.prod.outlook.com (2603:10b6:610:7c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 21:45:10 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::a) by DM6PR18CA0024.outlook.office365.com
 (2603:10b6:5:15b::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17 via Frontend
 Transport; Fri, 1 Jul 2022 21:45:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 21:45:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 1 Jul
 2022 21:45:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 1 Jul 2022
 14:45:08 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 14:45:06 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v5 3/5] vfio/iommu_type1: Remove the domain->ops comparison
Date:   Fri, 1 Jul 2022 14:44:53 -0700
Message-ID: <20220701214455.14992-4-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701214455.14992-1-nicolinc@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93708aec-57cd-4372-09f8-08da5baaf899
X-MS-TrafficTypeDiagnostic: CH2PR12MB4149:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MbIWIBAl/l18QMJLzy4TV1FhJRm8Y4YIEePb27DcYTO6qDC5Yp3yyUYBZEtt?=
 =?us-ascii?Q?LpV8A0quJtgBAO1mLqeXQsuna3vAp7FYQwLGt3TXGzYj5WnHWNiFJFo9z8jL?=
 =?us-ascii?Q?hRdE0DR0z+WIdQCwDiQkdWIgBXhViDSTmMS+nAnpPHytn9bvhxYbhZmQWyyD?=
 =?us-ascii?Q?rwEKaqri1PTLpUQXoOdXeZgrEPX+qAGTA01PNx4bFxawW6aOGUvJwkjLGNak?=
 =?us-ascii?Q?0xopLZSIhP4VusPFn8jTUqh0BOXfj7wEkLqTopK8FWXsyeiLATRwvfN8JUcM?=
 =?us-ascii?Q?nuFIPgkRRWo6EJ/vGkn8BApauuZH9m+52TbqCXm0hcJxBNiMI23ACg+luFA1?=
 =?us-ascii?Q?Z64oVHZDHSgKNSoF8TLPnqsTDyilsooqMCg4HYONF73L9sEu9LnjB1aeE6XU?=
 =?us-ascii?Q?65/eNA7/THsTppWj5A8OMcN1RbaTtJvG8/rddDubY/yoIccvpfR4jrCc7jKm?=
 =?us-ascii?Q?QZ94oHEd3hykaaUg5DqfKIKN0ZQZlH4dOi27PO28xr/eiJqQBIQCBgiF6PDn?=
 =?us-ascii?Q?xGkxTV59ThmFv4XyQvAFSyDV59eUweH1ot8INWn3Khf5AoFf3ipbOJeD+IlC?=
 =?us-ascii?Q?zl0PKGZH3HnwoiI0Qbt+XXI+YVpSfEGFinGOlpQQIyafDx7ADyTSJ0D6Xfq+?=
 =?us-ascii?Q?0Bf+YJpc+J7Z7eH0KOczJVfUluFOPEgcP5bqBchUnWk8iA8PxwKJAn1BokGT?=
 =?us-ascii?Q?3irLapQMsF5UEnK6MBq9qiCZzxorhtntSKNJLTb+T+1DTS6smB0voTwwim+i?=
 =?us-ascii?Q?fwTEalNh1M3lz2gDaC7FQBKLycXqQHcojfEeHRdsv83WFa9ol0SYjnXU4QEa?=
 =?us-ascii?Q?oBgaW9FTHY/h+jIHPvTS/r4PMKbGKQLFG5TnZhrg553ChIFt5Ur65WBlmkHi?=
 =?us-ascii?Q?oh6vEZlCbSbsQFOen/ASMCpsaWJE5YxeKP8nJW7kVLWx2zaix4/ZPGG7UfHx?=
 =?us-ascii?Q?Gc9zxs7d+WysFRM33tGNqIb1KGBonDABsH1MGs0LuRZakq2vnVfcaWEPyomF?=
 =?us-ascii?Q?URAcc/Y8KBxj0cir24HkdgaSrw=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(46966006)(40470700004)(36840700001)(186003)(2616005)(1076003)(83380400001)(2906002)(81166007)(336012)(426003)(86362001)(82740400003)(356005)(36860700001)(921005)(40460700003)(8936002)(47076005)(8676002)(4326008)(7416002)(966005)(5660300002)(82310400005)(40480700001)(70206006)(70586007)(110136005)(316002)(54906003)(7696005)(7406005)(36756003)(478600001)(26005)(41300700001)(6666004)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 21:45:09.8443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93708aec-57cd-4372-09f8-08da5baaf899
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4149
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The domain->ops validation was added, as a precaution, for mixed-driver
systems.

Per Robin's remarks,
* While bus_set_iommu() still exists, the core code prevents multiple
  drivers from registering, so we can't really run into a situation of
  having a mixed-driver system:
  https://lore.kernel.org/kvm/6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com/

* And there's plenty more significant problems than this to fix; in future
  when many can be permitted, we will rely on the IOMMU core code to check
  the domain->ops:
  https://lore.kernel.org/kvm/6575de6d-94ba-c427-5b1e-967750ddff23@arm.com/

So remove the check in VFIO for simplicity.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 7530f0d727e5..5992ee2345a0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2280,29 +2280,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			domain->domain->ops->enforce_cache_coherency(
 				domain->domain);
 
-	/*
-	 * Try to match an existing compatible domain.  We don't want to
-	 * preclude an IOMMU driver supporting multiple bus_types and being
-	 * able to include different bus_types in the same IOMMU domain, so
-	 * we test whether the domains use the same iommu_ops rather than
-	 * testing if they're on the same bus_type.
-	 */
+	/* Try to match an existing compatible domain */
 	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops) {
-			iommu_detach_group(domain->domain, group->iommu_group);
-			if (!iommu_attach_group(d->domain,
-						group->iommu_group)) {
-				list_add(&group->next, &d->group_list);
-				iommu_domain_free(domain->domain);
-				kfree(domain);
-				goto done;
-			}
-
-			ret = iommu_attach_group(domain->domain,
-						 group->iommu_group);
-			if (ret)
-				goto out_domain;
+		iommu_detach_group(domain->domain, group->iommu_group);
+		if (!iommu_attach_group(d->domain, group->iommu_group)) {
+			list_add(&group->next, &d->group_list);
+			iommu_domain_free(domain->domain);
+			kfree(domain);
+			goto done;
 		}
+
+		ret = iommu_attach_group(domain->domain,  group->iommu_group);
+		if (ret)
+			goto out_domain;
 	}
 
 	vfio_test_domain_fgsp(domain);
-- 
2.17.1

