Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9432363C936
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbiK2U3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiK2U3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:50 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3056317C
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW4ICILeWW3TsM7OrKcIe0D6ZSOei9FrWBMS269LedGwxpKlo1R5kRDzYBqF238/TMIpb0sx1EkRiGl5b++sEg3EdgSGYsWsaBQ6zvu6bERobtVDtRWkAjlIl7rsFLAlGKRgggw8mdvK7kAeMxfbQFR9bkNMHh1NSP5l9DGfEp+2eEWex8O4t5RqjWtN/u0Fuh3ZutMa9UEQkIlIETM+wFSjyMF+tAxMFjiyC/RmfMJYGOJqFuW9e5k82wrwP/dY0S1Ep7Q4pKN1et6wmh1l5uqpWDCGFv+K8jq7q1ceZkEnManV8AyHCPxTiNGxQ2PMmhMFfH+sk1Mz1jPDQf+wvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/5IoMdzanZlihohIxZq3RVStRxJF7NBwPZO3xVT9Aw=;
 b=W4oes0hYeBH4tcTycNAhMlfVv42r/6nnGfHWVl80nlSRiaEVPOttEz2VeQJk3BzDseHgGAUaMNO+iaXBTa7Oj6k4QkUo+DkY5e2P/trElWt/S+Hcdq4c/CeQ1UFUUSnGUhMR4Ol0gBStTmiEfenYKIQFSqECCzVSKj4RfoK6rmxiojfoMHPjV2BhTeYRbCrtB0WM4f5filU+wA9zyt3rjh5g4JLApLs8pD//NKIkHW2tw7EQTkdtUUsklIhOARFEMgooC3swxP7SIGmLswo2BNJnAUng7gk3crz6Gzf3P3Aawo2sUOJg0et1BOEG5oGrhvEDYvlE2DbjOIJU8sn1hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/5IoMdzanZlihohIxZq3RVStRxJF7NBwPZO3xVT9Aw=;
 b=bgm2aq27OiSy6GyNyJgndTakgcMz0aEBftyNNenmU6LJ0S7I+xqtq7x83Bp8NflDEQCGIZiJSAD+BRugLpkUD1I/rA2QxdWZsMHh7kOIgEw/xSRsX+jVsT7Ikl9Kwpgo33AD+i2eBxnrKOqEdBpLxo0kmwIk/jVU+4eg4Fikc3LTeSWXJ+1vGFDNzTnwZc5myH/lymdwuY5nQlRn/Itm2rraSuJC8aG8F9eBARlbgLFvVoCIku8G35sJf23Me5dnycbB1Lq2ZOG5SeWOgkYsty0KDUPIqcLTp71ziKBwh/xwBMV3p7Yntn4uyBdP6Ht4PCn6p6YkNW56QYu2SEnoIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:46 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 02/19] iommu: Add device-centric DMA ownership interfaces
Date:   Tue, 29 Nov 2022 16:29:25 -0400
Message-Id: <2-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:334::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b5336a-c961-4c9f-69f9-08dad24873a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/U8R8k2mKotmGH8Z/8OhnSx9uDMwQt07Cvgi++gJYAUtINOotycxpzPvnlodQNM/07cRDK7fHTCYfSD1PR18gbmTP5sCoPHNkPml+SOUCWMrYTY2E1XU6C9opur6pBltAelXhOobTNifp9hVurAL1VGCep6rjuX+nxs3SnDlo76nomkuY5pIJbgfq2MnlqVGa5+8oETvU2AUQLBgWHaCPuLZV7apK3L20WIZ1UdxIfSGo+E15Aar6QyI1MHRcyJa6rQegKX+gbERAHv4dR8BkkKWc9LYTFtXO3VOrUqdG+Do2DpmFgos6NVc3Ucd8cS6+BSU40IqN8UalxXbhuPIPzGtkt7FPDrYG7L9N5J54nUY2H/6+62Nua5cveTx8iNdx4X3tdby/ZB+ULdJXzrMzWxii75JNC/e+mVzzIwPsTEwKBt1YLLD2LDfoMMjq+v3Ppo4mN87usrVCt6/de5oK5Pt8suPU5PExPuV/X6h2Rb6WFH1frVRnrqbF2GzwleOYJL5rqgDo89nFPfJ1uZmEYiOIE7bwl1vkv/LZEN8FfGLMdnBYP3VaCmmhM5gmlIg39NC7xWh8sGIlN74qwu8jgb9VZUwZNEFR1kf0ZvBRb943U3PKlr2GUctY7DZyygNeLKGqbyfZ3F7/LOxG9VtW4+bB9zQCrio6m/GitB8RFlcg7/62rzdnZnq51pXpvINHhMdGrR3CjHPBEweHhITA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6uI/SgjMbhSoAqZ27DIG3l6SwsS3DnV9dL1op1wObja9UoIcIaQHE7Y4pQs?=
 =?us-ascii?Q?LLRGTLktFE83Ov2/7KtXHfg+SYFInKHmL3QhNzEFKVcavSIM1nA+QoyqyG8B?=
 =?us-ascii?Q?GGHhQSJYRPfR/xWdwp3oB9NmJKref1QZotkib6z5tMF9vU//CZeI6eFOsw5i?=
 =?us-ascii?Q?ta0OW1E3BP4EZTwUb8+Ki9iv43+VmuNC08yUB3fLan4CO493uD1428l3E7Vj?=
 =?us-ascii?Q?lM/SKSMTfGm4VvMFWXOrNG3PU5pZsIKnJKJMIZ3Ui2wyX6ClbO5hjtnUJD69?=
 =?us-ascii?Q?qw/X1cTmNuwqS494ZvCHmMK/7L6pd0UJ6+wlJ6SRuqdc6vlxdamUL/SiKFct?=
 =?us-ascii?Q?++m7C0yDTjRjY2dxs6gftt0PboKqOEpi+iz4BmzM36sQTlBmx+9gbu8jBd9v?=
 =?us-ascii?Q?5ruzRN8R8d6AUUy+oTGqQp7Bjjr1NI1i8/yBU5Y1UVL6xDoPCXjyIhIU1Bgv?=
 =?us-ascii?Q?Q20gI1x0ylwn8IUCrwLqgh+d71boB9MZWrteFo7WeIBNOtO2olDd92NeAThA?=
 =?us-ascii?Q?wpVb4qgyO5f4iDomT4ALsUNeecM3sqLUa+V4lslpSZoNBuqZwSJeVhvofAS9?=
 =?us-ascii?Q?SAr1JgumX1NW9KNIEZp5nEDZANdfbaNeb/FM/r22lSKSX+/J0bhPBbAp6QUY?=
 =?us-ascii?Q?54Rtj2cZVvbvtOXzN76nM7KhG67Zt5wMg1JC9buEKIMPrdmcgPbZmMxPMzcA?=
 =?us-ascii?Q?sM5V4IVN53C7jAeFVF4fv6KcOScSvTC2jdvdZ7DGPSyuG4N+Q5zsD4B8OYil?=
 =?us-ascii?Q?HGEk1Vsqj3u2mH8LAJ7oUhHYzhM9ON0VXm1fyBxtORXe2DENKxXfJ7fF6rtU?=
 =?us-ascii?Q?R/cRtKnKHPA1hNNxxeR27XPKS3nNfpLP0iswMnwd/di4g+XMwtyjpdIN12M8?=
 =?us-ascii?Q?EmB6iogmdtdendl6ARZC/sQiOrMG/Xc4Axspro9oH542U4YPDdNV0jGJkuDC?=
 =?us-ascii?Q?9390sE9pWhXWM5E+Cl9B9H3HrMknpfQXzPvm6jlnSqbJd9oLyBxGmxYw+WOc?=
 =?us-ascii?Q?1V1Bzgvut4PFGqYfdWpw2QtTD1bMpC/09XAyuu40SY+iFXbkbqM0EMIVA+eN?=
 =?us-ascii?Q?P70O0lohHmx0/DzJrt4+DQFPisgzWMDNefB+Eqwhh7pZfPVafbpMiq1TWOPm?=
 =?us-ascii?Q?2dN9dNjoqjgu587awerpu+0+DIa1Tg2JdblIm7R+wCV1dD+rA/9myPg1IiIK?=
 =?us-ascii?Q?FGxrr3fKFqAW1JnUqR4TLzCV/awLwM5/d5lePaJ33IKrT2WWnJCFKkKJPaZI?=
 =?us-ascii?Q?HFLBxv9HmDwuwUOxFAftWNTU2p6u+DeQ6rFQsn1xEW7L97eJG7hsy48DIRb2?=
 =?us-ascii?Q?6NPUoigjpdpUYPCb3SEWqRWg0Z+IRSYcmlYqK5tK2QpBKiPXe1NbOaj0m3HZ?=
 =?us-ascii?Q?qRWPY0Msm39+FFnlwxfLZtLBnu89SsNRLldC95ISYzerAM9GseKPJQdQZERN?=
 =?us-ascii?Q?saYSYEJuEPlo+srkqXR68vVWxC5Ta5HqeWPAcQNb/OrOGdV8srFfIUcwGhRn?=
 =?us-ascii?Q?fdnLhr6Zs1i6B8Rlo93SSKaJ+Izq3N867e/aBBeji8wj22N+N9va3gm9+LHU?=
 =?us-ascii?Q?qCWPxV+T/Vsj4SVY/02+gqJpGvK15KL1A9ejeT0s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b5336a-c961-4c9f-69f9-08dad24873a0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:44.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvGbtdWBf7C5EPClf7JZmJk4RY22ijNXIl+BLsBraJyzhafpnUoPwy+lSGrPsGNC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
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

From: Lu Baolu <baolu.lu@linux.intel.com>

These complement the group interfaces used by VFIO and are for use by
iommufd. The main difference is that multiple devices in the same group
can all share the ownership by passing the same ownership pointer.

Move the common code into shared functions.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 121 +++++++++++++++++++++++++++++++++---------
 include/linux/iommu.h |  12 +++++
 2 files changed, 107 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6ca377f4fbf9e9..d69ebba81bebd8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3108,41 +3108,49 @@ static int __iommu_group_alloc_blocking_domain(struct iommu_group *group)
 	return 0;
 }
 
+static int __iommu_take_dma_ownership(struct iommu_group *group, void *owner)
+{
+	int ret;
+
+	if ((group->domain && group->domain != group->default_domain) ||
+	    !xa_empty(&group->pasid_array))
+		return -EBUSY;
+
+	ret = __iommu_group_alloc_blocking_domain(group);
+	if (ret)
+		return ret;
+	ret = __iommu_group_set_domain(group, group->blocking_domain);
+	if (ret)
+		return ret;
+
+	group->owner = owner;
+	group->owner_cnt++;
+	return 0;
+}
+
 /**
  * iommu_group_claim_dma_owner() - Set DMA ownership of a group
  * @group: The group.
  * @owner: Caller specified pointer. Used for exclusive ownership.
  *
- * This is to support backward compatibility for vfio which manages
- * the dma ownership in iommu_group level. New invocations on this
- * interface should be prohibited.
+ * This is to support backward compatibility for vfio which manages the dma
+ * ownership in iommu_group level. New invocations on this interface should be
+ * prohibited. Only a single owner may exist for a group.
  */
 int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
 {
 	int ret = 0;
 
+	if (WARN_ON(!owner))
+		return -EINVAL;
+
 	mutex_lock(&group->mutex);
 	if (group->owner_cnt) {
 		ret = -EPERM;
 		goto unlock_out;
-	} else {
-		if ((group->domain && group->domain != group->default_domain) ||
-		    !xa_empty(&group->pasid_array)) {
-			ret = -EBUSY;
-			goto unlock_out;
-		}
-
-		ret = __iommu_group_alloc_blocking_domain(group);
-		if (ret)
-			goto unlock_out;
-
-		ret = __iommu_group_set_domain(group, group->blocking_domain);
-		if (ret)
-			goto unlock_out;
-		group->owner = owner;
 	}
 
-	group->owner_cnt++;
+	ret = __iommu_take_dma_ownership(group, owner);
 unlock_out:
 	mutex_unlock(&group->mutex);
 
@@ -3151,30 +3159,91 @@ int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
 EXPORT_SYMBOL_GPL(iommu_group_claim_dma_owner);
 
 /**
- * iommu_group_release_dma_owner() - Release DMA ownership of a group
- * @group: The group.
+ * iommu_device_claim_dma_owner() - Set DMA ownership of a device
+ * @dev: The device.
+ * @owner: Caller specified pointer. Used for exclusive ownership.
  *
- * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
+ * Claim the DMA ownership of a device. Multiple devices in the same group may
+ * concurrently claim ownership if they present the same owner value. Returns 0
+ * on success and error code on failure
  */
-void iommu_group_release_dma_owner(struct iommu_group *group)
+int iommu_device_claim_dma_owner(struct device *dev, void *owner)
 {
-	int ret;
+	struct iommu_group *group = iommu_group_get(dev);
+	int ret = 0;
+
+	if (!group)
+		return -ENODEV;
+	if (WARN_ON(!owner))
+		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+	if (group->owner_cnt) {
+		if (group->owner != owner) {
+			ret = -EPERM;
+			goto unlock_out;
+		}
+		group->owner_cnt++;
+		goto unlock_out;
+	}
+
+	ret = __iommu_take_dma_ownership(group, owner);
+unlock_out:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_device_claim_dma_owner);
+
+static void __iommu_release_dma_ownership(struct iommu_group *group)
+{
+	int ret;
+
 	if (WARN_ON(!group->owner_cnt || !group->owner ||
 		    !xa_empty(&group->pasid_array)))
-		goto unlock_out;
+		return;
 
 	group->owner_cnt = 0;
 	group->owner = NULL;
 	ret = __iommu_group_set_domain(group, group->default_domain);
 	WARN(ret, "iommu driver failed to attach the default domain");
+}
 
-unlock_out:
+/**
+ * iommu_group_release_dma_owner() - Release DMA ownership of a group
+ * @dev: The device
+ *
+ * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
+ */
+void iommu_group_release_dma_owner(struct iommu_group *group)
+{
+	mutex_lock(&group->mutex);
+	__iommu_release_dma_ownership(group);
 	mutex_unlock(&group->mutex);
 }
 EXPORT_SYMBOL_GPL(iommu_group_release_dma_owner);
 
+/**
+ * iommu_device_release_dma_owner() - Release DMA ownership of a device
+ * @group: The device.
+ *
+ * Release the DMA ownership claimed by iommu_device_claim_dma_owner().
+ */
+void iommu_device_release_dma_owner(struct device *dev)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+
+	mutex_lock(&group->mutex);
+	if (group->owner_cnt > 1)
+		group->owner_cnt--;
+	else
+		__iommu_release_dma_ownership(group);
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+}
+EXPORT_SYMBOL_GPL(iommu_device_release_dma_owner);
+
 /**
  * iommu_group_dma_owner_claimed() - Query group dma ownership status
  * @group: The group.
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a09fd32d8cc273..1690c334e51631 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -707,6 +707,9 @@ int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner);
 void iommu_group_release_dma_owner(struct iommu_group *group);
 bool iommu_group_dma_owner_claimed(struct iommu_group *group);
 
+int iommu_device_claim_dma_owner(struct device *dev, void *owner);
+void iommu_device_release_dma_owner(struct device *dev);
+
 struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 					    struct mm_struct *mm);
 int iommu_attach_device_pasid(struct iommu_domain *domain,
@@ -1064,6 +1067,15 @@ static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 	return false;
 }
 
+static inline void iommu_device_release_dma_owner(struct device *dev)
+{
+}
+
+static inline int iommu_device_claim_dma_owner(struct device *dev, void *owner)
+{
+	return -ENODEV;
+}
+
 static inline struct iommu_domain *
 iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
 {
-- 
2.38.1

