Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ACD5175D8
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386678AbiEBRfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386658AbiEBRfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C145A6268
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ2Mk/hZ025bNu2EdpIyREOj/3b4eGmmOEQVGVCJGvganOEsxpOjHYgDXj+ZcdojhD2qBWRE1rIrZ2cle1GRqbJvA07WwvnlwGTjXqvpHYqZ++STCpnUBXA+7mbc/fOgI+tDq2f8soVC6JqpLy8SqxT/p1+UeYn6P9mPl7swVFLUEYC4e2ryrIusZRs/8L9x3gCWH7bTVoQGMEEWyinE/kFOGidqXeYfyVjdf9pJYJKOnxiw0uofM/9a9k9hM3/erXypni0/iXW+LTnXmBYfQ6gXMJKfV2fO5Tdf7XszvoSnlO4okD8J0hUfj8dD3KxHgW5vZjw/2JLKEqpe8xr/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKgmevxs4ymKgofDqjFWofAStJLtOC/grEjyH3LWHdk=;
 b=LwlCEVyHaMhRfzuqNiVhhYNQnU41T+cUbsFHOpyWrIs8LKCqV1QsuvwN1djt+NS1i1WX1yG1471hhsYufurPNpDxq8nTiOIoaApSkhjRyD8p15LXpsD7wL4+XR6TSlDGdnSv9l6E3+/+1z2A13XFuyrwWhOsLldR+dbjJK+B4cpdoYhzd3WqWlrlzqZXDVeO1zHut82aEc0kJxyKoDd8tfP0hqv48kyt8tIOSPmpOe0FoSOXfG+y6LNYtqwK9ySUNpnHw5Ubn8iWucKmOcxhFebMZTGq7Ina3e1GbFyb9h8eVSTiagPeKDVX+jT8ac9f2TBc1feWTuJdTA3BH4e5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKgmevxs4ymKgofDqjFWofAStJLtOC/grEjyH3LWHdk=;
 b=a2RPKlASPhrQsXFt5E+luf0zVeU1VAM143m0A1Z9EOKhajY0d8hH/A5pOGcelr1k/FnJtCTWycwK6hhP9Busmt5Ez3gVe+zqlmKGwlBqzyRWjFmV0+Ak8rSsV0IIS4igWDnx3NmnEV0G8ZDFkVc3s9SZ3epi79v0qBwGNukb+z6ECfMWgPhQFDlU4MuiKvlAV8vVp0OWL6xlQeh4Dicq5bnONkFP6Tycrl2qPL2tF6/CRXE8ja/sUICLgBpx7oOBBZ8rZFMyD5go0+1ElkR9vwNnSv5Q5F1E8Pn3xOoqdq2AyjbVR/lZsoBxGlHn9DLsbiez9R5TNhKKva4gQ84/0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 3/7] vfio/mdev: Pass in a struct vfio_device * to vfio_pin/unpin_pages()
Date:   Mon,  2 May 2022 14:31:33 -0300
Message-Id: <3-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 802b1530-f908-4750-fb00-08da2c619d0c
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5458B15CAD0BF2F20F5D2427C2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMTylhpwUhiR/Gdn+lfYdnXgPhvmX1LvXilvrrBwULVsNDzQqSopuTkvilkpTXAueiNmvvyhxlLqPwZmjv3oPBxNJwdGi7EuiG3Cd9Km8qej647w8Kvw0I9eMXdAEEvqimbgn6DlU4y9dSG/sZc/r8TXd6vKkAi2PNz25E+DU6uZC1m2GiJFJCtx1lu0DkHsxKMgy63VJxUevVBysk/RfzDvWYOy7XhxuEf3k1tCoj2CZkbowIhkNrQMbCj/Do6gl5qr2kLS+QhamuRKoo03zkYRQzlCpvW2ia6T8OMIrMg34twtTIRMKAo2toB96+Isg2WA08IBa3HNdhDgt52ifPf/bDKo/Rv8GmZ06E8pi7tKbUfxJ7S3T/Vbl7lRfdnSFDkwmRdSVYg/CWmMt8l0D3XkbUc1HCr+7RImkuTa8eVLykSH9/2lcTCFjN1/w9tQ3NFGorYjom71tVEoGngEbShuJu5MjgtoUkmcEEXGFRE6yqY1A09wtSL7siMPvC4/yAXuCAWlwrLHtVoSqPynuVEOdJd0KMCblQimn2mrYkkaVtoc4HIXIKK72f2L7KIgRvZr+KGc7kRi7Roqytbes3gyshYRRZOs6bRPDG4X6m1l82p/soYhnoopEO4tvIrB7powvlMc+RzD14BO8ZBG4Z1xYlA8ybbyXGVw9fWVCdYuoZN4WMa6PR8lG1tAAlE9BWu3LBlQ+o53Z6y46QJHuGR058MvLUxb5Ylu7G5nzJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7ZBIwdeSQhkw1D1WG2p8XRmbIwy3Ra/l9ZUYvZXdOUs8gibSaT1gYloP8hWe?=
 =?us-ascii?Q?RBNTvkp80z1yqtEh9E5wYkUIsW0G8W/zoLjBnw+4VFx7m6rbPY7W8sqQxsYD?=
 =?us-ascii?Q?RZjTXQEBythsZu6N1jDE3m5vueLJHfzembF5wsVbHCo+9iwqlmP7x9r5ucMI?=
 =?us-ascii?Q?iese1KwEMGfimemvKaS8ATklpA8zMcbQ2pJPuxTVCRnYTgYxy+NvufTI0Qe/?=
 =?us-ascii?Q?HhmBY6YHBdt7Q3hphFzu6fCgIdGmEk/9TnEG03QTcqrQskHrjy90nRNulmf+?=
 =?us-ascii?Q?6XX1M57mBK/6MPboGzsU7++cUUqJbWkPrSfrLu59fTiqJL3yF498zucPipFM?=
 =?us-ascii?Q?0NkOKct5zv0aTUtl/klRMmPVNYy+y4ovINSRGVnfu/pdhSSclsFRqikeHnDk?=
 =?us-ascii?Q?sh7PpiE7ffMfIZvG+XCuo+iBCimg0FCRvgxgM0yyiPtF6Mcm9ms0cJIC7pa3?=
 =?us-ascii?Q?FgFY4xfD3X/IV/pFOgvkbo1x2c6DgwvPuuQqxcp/MiS4/7Z2FXRYLNIz6Y98?=
 =?us-ascii?Q?PoWXSI6Ih0lFFadJ/Y+4EdwpKp+I6HCGO1HOmmAD7tzTAs4E3hKci8rNivTM?=
 =?us-ascii?Q?bq3KveX9+3hTAaJI+t9P12ZPktrHKsZBWAOD2y7nDv7j1ddyutQyzSlQaB+j?=
 =?us-ascii?Q?qp6F3rKc+UFi0CVqzT/xHHu81NPuOUGNvNfUs8KxcI4lnPhCwoUNq4dz47DV?=
 =?us-ascii?Q?OHNQ5IBBed6xWxYZpjsyBU8CoNHxWOUhefzhbARAO8RqA+/BYVmaE6WdlTBm?=
 =?us-ascii?Q?VbMcozRKo6pmJ2hJb/f4i5ubIB44qd68Xp5NG+81UbN7MqdfSVp/w5NZNYCo?=
 =?us-ascii?Q?3GKSSLF71QNci9Va0IEFXp1xYbuJysmYaBTroTeT9NkCiR1G2ruqgnMC5z6w?=
 =?us-ascii?Q?5Fxgo4szQYglIeE7pJaIWuYG8ylEa0SOuCW66p6R4nzACpzj5gRuMxTfeBoQ?=
 =?us-ascii?Q?rNQS/FnqxfJtUin+aWGBit3NcPKr6RzVwcw1FIkEBCLuQ+IZ5imA93a0wMBC?=
 =?us-ascii?Q?RhGJhz5Dzxy/7ekJydZJX/ihTaCB92IXan4qtdNvCCCyvUg/Lr89Lw9exnCv?=
 =?us-ascii?Q?NIzPwV4g4hA5LkEbTJN6qGEQ+KRUKFMKp6bt0Pw0+FHrAZtxXMKzT16fsNzz?=
 =?us-ascii?Q?IjC8v/yCAs35sTun0tJ81uY9vgnUy77h3mseryN9RYi9anLISAULED0zKJEW?=
 =?us-ascii?Q?h62MbK841DUUQzpSuPwb7SW46wDFA3o8TJmNgMhNdFkLlWUrINcW+3axB/vL?=
 =?us-ascii?Q?wD8JayhYZiMrddFc6B2pyLZf0HOJuwWdLoxj1KG8lp2R3Wy5IAydHJBAL0tM?=
 =?us-ascii?Q?D8cB/apYEVaBGXQmOSpOvy4h1dIG9uLFXQPlD2ioynJDiPMD3361hVIdTrIY?=
 =?us-ascii?Q?ELXj5PmN1mcWb1wUlHkaAo7DiV40YdPj2TgXdLrI4goUdXpVYIreBL8m14NC?=
 =?us-ascii?Q?Mzixn+/XnFmLgS3v4ksE5w1O+VkWVKZiIBBVo9U4PnVt/+pCVyC7iJp3TALC?=
 =?us-ascii?Q?GPdPrBsOzd3ifGSf1zlG1A37laceM/dbgQ+t6GT9hFhzjQkqAEJrdM5/59d/?=
 =?us-ascii?Q?Ps6sPybaisoom9SruNBdkkM60NXmH210O6ZnTMcxNAz5GQNIouC8AXhoMH9B?=
 =?us-ascii?Q?GJ8Xld3HN3vLsVUqY41eXsuNgaU/vyt1QpRtSS0WoMcBVNVFkfVFjo1XiKNf?=
 =?us-ascii?Q?aHQebdqcvNeaqPvqFfMxhv9hVJYtdsM5NreIfuoqcGu31gheQ9VJS1pMtXvt?=
 =?us-ascii?Q?Or+on/tb1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802b1530-f908-4750-fb00-08da2c619d0c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:38.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhXYzSjIvfi5wx5H7ymmiPJZD5jwLhEDGdWZnyxMiALkipjOoX63SaykvqQyA9UM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every caller has a readily available vfio_device pointer, use that instead
of passing in a generic struct device. The struct vfio_device already
contains the group we need so this avoids complexity, extra refcountings,
and a confusing lifecycle model.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  4 +-
 drivers/s390/cio/vfio_ccw_cp.c                |  6 +--
 drivers/s390/crypto/vfio_ap_ops.c             |  9 ++---
 drivers/vfio/vfio.c                           | 40 ++++++-------------
 include/linux/vfio.h                          |  4 +-
 5 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 784bbeb22adcf5..2f9e6025eb2fe1 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -262,10 +262,10 @@ Translation APIs for Mediated Devices
 The following APIs are provided for translating user pfn to host pfn in a VFIO
 driver::
 
-	extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
+	int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 				  int npage, int prot, unsigned long *phys_pfn);
 
-	extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
+	int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 				    int npage);
 
 These functions call back into the back-end IOMMU module by using the pin_pages
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 7a1cf3091cd647..0c2be9421ab78f 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -103,13 +103,13 @@ static int pfn_array_pin(struct pfn_array *pa, struct vfio_device *vdev)
 {
 	int ret = 0;
 
-	ret = vfio_pin_pages(vdev->dev, pa->pa_iova_pfn, pa->pa_nr,
+	ret = vfio_pin_pages(vdev, pa->pa_iova_pfn, pa->pa_nr,
 			     IOMMU_READ | IOMMU_WRITE, pa->pa_pfn);
 
 	if (ret < 0) {
 		goto err_out;
 	} else if (ret > 0 && ret != pa->pa_nr) {
-		vfio_unpin_pages(vdev->dev, pa->pa_iova_pfn, ret);
+		vfio_unpin_pages(vdev, pa->pa_iova_pfn, ret);
 		ret = -EINVAL;
 		goto err_out;
 	}
@@ -127,7 +127,7 @@ static void pfn_array_unpin_free(struct pfn_array *pa, struct vfio_device *vdev)
 {
 	/* Only unpin if any pages were pinned to begin with */
 	if (pa->pa_nr)
-		vfio_unpin_pages(vdev->dev, pa->pa_iova_pfn, pa->pa_nr);
+		vfio_unpin_pages(vdev, pa->pa_iova_pfn, pa->pa_nr);
 	pa->pa_nr = 0;
 	kfree(pa->pa_iova_pfn);
 }
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index bfa7ee6ef532d9..e8914024f5b1af 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -124,8 +124,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
 		q->saved_isc = VFIO_AP_ISC_INVALID;
 	}
 	if (q->saved_pfn && !WARN_ON(!q->matrix_mdev)) {
-		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
-				 &q->saved_pfn, 1);
+		vfio_unpin_pages(&q->matrix_mdev->vdev, &q->saved_pfn, 1);
 		q->saved_pfn = 0;
 	}
 }
@@ -258,7 +257,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		return status;
 	}
 
-	ret = vfio_pin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1,
+	ret = vfio_pin_pages(&q->matrix_mdev->vdev, &g_pfn, 1,
 			     IOMMU_READ | IOMMU_WRITE, &h_pfn);
 	switch (ret) {
 	case 1:
@@ -301,7 +300,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		break;
 	case AP_RESPONSE_OTHERWISE_CHANGED:
 		/* We could not modify IRQ setings: clear new configuration */
-		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1);
+		vfio_unpin_pages(&q->matrix_mdev->vdev, &g_pfn, 1);
 		kvm_s390_gisc_unregister(kvm, isc);
 		break;
 	default:
@@ -1250,7 +1249,7 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 		struct vfio_iommu_type1_dma_unmap *unmap = data;
 		unsigned long g_pfn = unmap->iova >> PAGE_SHIFT;
 
-		vfio_unpin_pages(mdev_dev(matrix_mdev->mdev), &g_pfn, 1);
+		vfio_unpin_pages(&matrix_mdev->vdev, &g_pfn, 1);
 		return NOTIFY_OK;
 	}
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 13494c1e497405..dc5d40b07e2381 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1927,32 +1927,26 @@ EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
  * @phys_pfn[out]: array of host PFNs
  * Return error or number of pages pinned.
  */
-int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
+int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn, int npage,
 		   int prot, unsigned long *phys_pfn)
 {
 	struct vfio_container *container;
-	struct vfio_group *group;
+	struct vfio_group *group = vdev->group;
 	struct vfio_iommu_driver *driver;
 	int ret;
 
-	if (!dev || !user_pfn || !phys_pfn || !npage)
+	if (!user_pfn || !phys_pfn || !npage)
 		return -EINVAL;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return -ENODEV;
-
-	if (group->dev_counter > 1) {
-		ret = -EINVAL;
-		goto err_pin_pages;
-	}
+	if (group->dev_counter > 1)
+		return -EINVAL;
 
 	ret = vfio_group_add_container_user(group);
 	if (ret)
-		goto err_pin_pages;
+		return ret;
 
 	container = group->container;
 	driver = container->iommu_driver;
@@ -1965,8 +1959,6 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
 
 	vfio_group_try_dissolve_container(group);
 
-err_pin_pages:
-	vfio_group_put(group);
 	return ret;
 }
 EXPORT_SYMBOL(vfio_pin_pages);
@@ -1980,28 +1972,24 @@ EXPORT_SYMBOL(vfio_pin_pages);
  *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
  * Return error or number of pages unpinned.
  */
-int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
+int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
+		     int npage)
 {
 	struct vfio_container *container;
-	struct vfio_group *group;
 	struct vfio_iommu_driver *driver;
 	int ret;
 
-	if (!dev || !user_pfn || !npage)
+	if (!user_pfn || !npage)
 		return -EINVAL;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return -ENODEV;
-
-	ret = vfio_group_add_container_user(group);
+	ret = vfio_group_add_container_user(vdev->group);
 	if (ret)
-		goto err_unpin_pages;
+		return ret;
 
-	container = group->container;
+	container = vdev->group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unpin_pages))
 		ret = driver->ops->unpin_pages(container->iommu_data, user_pfn,
@@ -2009,10 +1997,8 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
 	else
 		ret = -ENOTTY;
 
-	vfio_group_try_dissolve_container(group);
+	vfio_group_try_dissolve_container(vdev->group);
 
-err_unpin_pages:
-	vfio_group_put(group);
 	return ret;
 }
 EXPORT_SYMBOL(vfio_unpin_pages);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 748ec0e0293aea..8f2a09801a660b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -150,9 +150,9 @@ extern long vfio_external_check_extension(struct vfio_group *group,
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
+extern int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 			  int npage, int prot, unsigned long *phys_pfn);
-extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
+extern int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 			    int npage);
 
 extern int vfio_group_pin_pages(struct vfio_group *group,
-- 
2.36.0

