Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9FC51AD9F
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377493AbiEDTSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355060AbiEDTSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:32 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E00A488AE
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BACGO7fCa0ZEm2dc5+JIsK0Zd9Gcq7EXFpfY1ZsUcYU0EVXpTxqEh4dNm680YtAPEAA66sIYKc7D42TONPcPrzGz3SWLW8GrZjqRufg6ZoLOQg+wriYIr/+AcmJ8UvCo7/JEatKOVyKk5wlbaCLdzJn70Uln/NXY/UDdjn/l/VaDX73Pq0oLjqt6Mwbbk5cLqp8fen3p498iBZdyRvzHfjTbbhk1H12ZlDuji0GIWZap51lo5OdPVMcYTGAw6+CcrXOeobfrLXonhR9gF/moVBRpgf2I3/82i5TabeNbi4/zf3AYd1tQOnxHJXN0EkExRQth191wJwTAzGZg7//1bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOJOWRkCSsNFpgrcAMdeKTwjUlFQmYp0FJksEI2G2DU=;
 b=lnwT9Sx5PhLjCyIjPlVv4058hididWYeKlZT0Sl2vnjEwA4VnLzsxNlwf8q8YOE6m+ADsMYeFjpGlxyOwS4Gs9SlQCdj77vw9ktH2VPaU5qtabjIyqYM/ue1WipOtvtkgE2ZsdnE33aM/V5HBi2u1rIGLB7uVrzTZu3fX+jZa7udQ7zeE25W1z90qzeniahyr4lId65ZPRpAy131CuUx0AbW/DkTF/QXmagsDsS1n95HLdEYxrsSSeQECC9joQWqYkpXKvBsowADcGvSQxyPhKaFX7cNleK5ZowJh8C1+fTBj/tk7fZh7e2lKtMKEDDenLj4fVef24vtPo3nfdi7yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOJOWRkCSsNFpgrcAMdeKTwjUlFQmYp0FJksEI2G2DU=;
 b=oZs/NeB8QDwLOhc+QlzqXLq6CTNDGwGjmQxN2U70mRg5LOZz2+fOAFT+ycdJ3EsvabesPqh3KVdyAqilkT53kNyt3K/HMfy42bb7wOaH52twrBOkCEZwlGL3s43UeWrLeKTwzFoL+fXIzlupXn0tWrscHCSu9W7zxbnQcwVtuWUdfG5+6Hhkl8eL/7iy4DxlWYYau/513ZCqfYElCUpnSvcC+7KS2CO/xSEC0jlPYINnoXWoL+iBtybSFnZ3zWKLkF0/5LIq3Kf9LEB42DPk9D6CvdpuHH3LCVAXsW+8WH4X/CbjyJjb8kMwLV1O8zNA3rJ7Dr25EWJky6mfpApVMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2341.namprd12.prod.outlook.com (2603:10b6:4:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:51 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 3/8] vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
Date:   Wed,  4 May 2022 16:14:41 -0300
Message-Id: <3-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:208:23b::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8bc9866-7d30-4a8f-20d2-08da2e025b84
X-MS-TrafficTypeDiagnostic: DM5PR12MB2341:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2341AF48F27AFE321EC79AEAC2C39@DM5PR12MB2341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CII6OqIO9jzfYI00rx69QvfibUGw0AtxDIkzhIfGzNeP80jfFwXP1XqUiCikDnVMSyrTfRC/CiMqOt93Em1kX+K0agQbpgoTDx+0I2hGb6ySw57jdwpa/4hnK/m1/a3CtLPepWahJpdXW1KzdvdTarVKwH46KYw3/WO/uML7hZQ4ImeAHsLstGoXSaCywQbm8zBAX0+JiW3lJMXFpHVfFEmUWqKYHWtTDvgIQIbjBkO5R9b9tuoK6a3dA/tpCSjQwg+7DXrSM3zlPq2s1fZSp+RsLOM9lbBE4ytY+UiFaqTorX8hKn0tAwLJ+XLRZXg3G5e1chk9z5QUSVfrriHXEO96Pus+yq/mujMQwxg06v2FZqAhaFzye9B8KRJ4nGInQWXkWTCJpPCNjDlJRnaNg2qQyUPuGZD9RZaZcAKqlG4Knx0SrMqcxl0no1ukMTIcbUp3NmdS6/v++ihwIRufT7fKnEEnEnMITtv/8N1pXMO7cUB6lMxg1SRPn6GGp0teZpCojT/5KEnarbRUo0R2mjFJ8DUEmlv2Xolu3gkZDkEi9jwVyRgu3ZwJvuxJ1TwC8CF5gnOdM+Natrapgl2dVpz45qQjBYnj0rn/4OkXKOGIkYqZYJ3y/45UCyBLl0+CPy6sm0/uhj1FTZoJu7IlkpIRTwpNJ17Sh0Xqp1sbYiA4mKY/jVRDKkOx1NoFrrkFrKl+eeWispa1iMZ0Of/COg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(2616005)(66946007)(8676002)(6666004)(66476007)(6506007)(38100700002)(6512007)(4326008)(26005)(66556008)(6486002)(54906003)(316002)(83380400001)(110136005)(2906002)(86362001)(5660300002)(36756003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t8Sie4zGi+2iHvOEMPJLAzXSpa7dokJT+93CezsPSxxZo+W+W967O1+M4Vne?=
 =?us-ascii?Q?EKVSHe/NVVOWFyf+u/B/wMXVHMHaLX8hyCKErJqN8nRCXliljWC17zkljbAA?=
 =?us-ascii?Q?oGPwsT1nMRZDQcLBKdZ/sbJgj4oP6J5PrvpCth6HgY+qQkBMlkygGV6K2RVv?=
 =?us-ascii?Q?7hSwq5D/84o+N50SCmCPn2HJiQwfGgPoXD5JVuvIfKW8729m3wmDz8ZYc8BK?=
 =?us-ascii?Q?WL88XvzWbbPPN4qCBHddyWewGMg46DLytyDOZ8E3WajmZj4U8rbZJimsf+46?=
 =?us-ascii?Q?JYV8QU6ygqsGkiIxPocGzLZ6vR250nGOprdwyM558L4CMCNCXcPVcoZmup7m?=
 =?us-ascii?Q?CQQ5cK8YSfAOcxsQY9TWrLqmLbVObuocbCickxqYkdH3zGi8YZR4m8GQp9oT?=
 =?us-ascii?Q?M7QhkhYSH1k9HdoeSxH1m6Vi+Cv0YMcYYMohXxwJLAOmojFvmIA1o7VUFgBA?=
 =?us-ascii?Q?4KubxXQ0e9cRq7e4H9IG42fBCVvi4+WYPCKsmGMhvllifLbFynNqcGtIefAj?=
 =?us-ascii?Q?d4GWGWCverMgX7lTJJhA6+8WjhdeUdZscnci2L650nr6krUafzeEGzOLEVPr?=
 =?us-ascii?Q?L1b4kDeqJ4Dwinrq6qxUDuRN7mwN60LLFhk3M/zGCAJzlR3obZdJqbFfbFpf?=
 =?us-ascii?Q?86ACgI73g5Hl7/o5qoojpkpoeQQajJgRqfWM8fsj55Vjps/j7CI7flnZDd3l?=
 =?us-ascii?Q?LcD0BrtxmC9P5dXl5b6vdvG9In/6VQqIFSK8BQpz9vZy3/TQfBCnho8KloJ0?=
 =?us-ascii?Q?5tE7lvdAS3A9lIj72oFtDpkuDH5GkA3F6Nu2yhRwEc+ckhvgfE2Mpjm3ZCLC?=
 =?us-ascii?Q?nIejUVPnVYbTwPeUj906Q+AFh/BgHotUI38r00hwxq3nsWIj8PdS3w8W40vv?=
 =?us-ascii?Q?qAswzlXCLrgwWCVISPfi5jIMgf+48ww2psrR75Anzq23iDI9hhlLnA/fKnW3?=
 =?us-ascii?Q?sVg6qQoaITFgwrpqkWh9eM3max6ErfvYwZypFKTxhVg4GLAAIQ14X255aZDd?=
 =?us-ascii?Q?4lveeC4wZeH8sLQKXNvj3yBoCPIL2OZkDhzenKoDkyeScLfColce0be4xRlB?=
 =?us-ascii?Q?AFFUA5eUfDe6f22nNpCshlZpuVqU1ZxfBtMC2y5CWiK/TBtQ/QRBnW+YJZnV?=
 =?us-ascii?Q?Ymt+jhZkFgyeCvtKmKsy9Ma2qdD79X9CY2j4Nf68Jl09Ce5M+osNakmL7Xkm?=
 =?us-ascii?Q?CeDF6mtd+eU7ZuwCYN7WKBfKquUNPO9qvPsyoYiMKoJRpaKau6IPv1252Wo1?=
 =?us-ascii?Q?TGHb8eT8LmFp2CVWJwgLeTMiXoYqA5qMRvMGBX9OATQaExe53BMWpmBrySp8?=
 =?us-ascii?Q?SYwBx8EQQU/AMEK6Yo615vR2aFUyuRY1TR/lo7wpg8pDJh198zRp0fIzWszV?=
 =?us-ascii?Q?KAIaxhKEeQHa2izDQAa2IOCrChySr4ECgbWa6t5hmE2nWV5PyWacr6ac4Qqm?=
 =?us-ascii?Q?ekWfBlUyodaiG0uBULVAXQkShnrQvoXNyT0yTI1nU5bnpAFvaMUKmGadbIYz?=
 =?us-ascii?Q?BlZBkZ7tkbJ5oJY4kHPjYIp6w38suzcg/EZg+TZIyKDnbGUAvyq8FPgKzbBa?=
 =?us-ascii?Q?GHU2yc33eVK4pBcIRfmeRd/IB8YUc0xf6fyXxuyC8Zx58GGXXATn58kVyPv4?=
 =?us-ascii?Q?1ZrT/n5JaptlCG+FSpS7LZgM6CtCes8WBsNzSL/ye8C6+j/Mnr+UGlVSe0sr?=
 =?us-ascii?Q?LXVQbSGrkfhe++GVSWNIvacJ8spHFr5J1sV0uQ9/CUrRXq2XzT4o/wqCxokB?=
 =?us-ascii?Q?b02hFl9UZg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8bc9866-7d30-4a8f-20d2-08da2e025b84
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:48.7638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebXrEXT9QEI08HWOui0E2ZMtjPLvqiEXsJ+sHcKyfzzwNLRBMcPngmFi6h5FEa+B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2341
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only caller wants to get a pointer to the struct iommu_group
associated with the VFIO group file. Instead of returning the group ID
then searching sysfs for that string to get the struct iommu_group just
directly return the iommu_group pointer already held by the vfio_group
struct.

It already has a safe lifetime due to the struct file kref, the vfio_group
and thus the iommu_group cannot be destroyed while the group file is open.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 21 ++++++++++++++-------
 include/linux/vfio.h |  2 +-
 virt/kvm/vfio.c      | 37 ++++++++++++-------------------------
 3 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index fcff23fd256a67..4f031ea4cacb9d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1673,10 +1673,7 @@ static const struct file_operations vfio_device_fops = {
  * increments the container user counter to prevent
  * the VFIO group from disposal before KVM exits.
  *
- * 3. The external user calls vfio_external_user_iommu_id()
- * to know an IOMMU ID.
- *
- * 4. When the external KVM finishes, it calls
+ * 3. When the external KVM finishes, it calls
  * vfio_group_put_external_user() to release the VFIO group.
  * This call decrements the container user counter.
  */
@@ -1717,11 +1714,21 @@ bool vfio_external_group_match_file(struct vfio_group *test_group,
 }
 EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
 
-int vfio_external_user_iommu_id(struct vfio_group *group)
+/**
+ * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
+ * @file: VFIO group file
+ *
+ * The returned iommu_group is valid as long as a ref is held on the file.
+ */
+struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
-	return iommu_group_id(group->iommu_group);
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return NULL;
+	return group->iommu_group;
 }
-EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
+EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
 long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index de8dd31b0639b0..86b49fe33eaea1 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -140,7 +140,7 @@ extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern bool vfio_external_group_match_file(struct vfio_group *group,
 					   struct file *filep);
-extern int vfio_external_user_iommu_id(struct vfio_group *group);
+extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 3bd2615154d075..9b7384dde158c1 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -108,43 +108,31 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 }
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
+static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
-	int (*fn)(struct vfio_group *);
-	int ret = -EINVAL;
+	struct iommu_group *(*fn)(struct file *file);
+	struct iommu_group *ret;
 
-	fn = symbol_get(vfio_external_user_iommu_id);
+	fn = symbol_get(vfio_file_iommu_group);
 	if (!fn)
-		return ret;
+		return NULL;
 
-	ret = fn(vfio_group);
+	ret = fn(file);
 
-	symbol_put(vfio_external_user_iommu_id);
+	symbol_put(vfio_file_iommu_group);
 
 	return ret;
 }
 
-static struct iommu_group *kvm_vfio_group_get_iommu_group(
-		struct vfio_group *group)
-{
-	int group_id = kvm_vfio_external_user_iommu_id(group);
-
-	if (group_id < 0)
-		return NULL;
-
-	return iommu_group_get_by_id(group_id);
-}
-
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
-		struct vfio_group *vfio_group)
+					     struct kvm_vfio_group *kvg)
 {
-	struct iommu_group *grp = kvm_vfio_group_get_iommu_group(vfio_group);
+	struct iommu_group *grp = kvm_vfio_file_iommu_group(kvg->file);
 
 	if (WARN_ON_ONCE(!grp))
 		return;
 
 	kvm_spapr_tce_release_iommu_group(kvm, grp);
-	iommu_group_put(grp);
 }
 #endif
 
@@ -258,7 +246,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		list_del(&kvg->node);
 		kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
@@ -304,7 +292,7 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 		if (kvg->file != f.file)
 			continue;
 
-		grp = kvm_vfio_group_get_iommu_group(kvg->vfio_group);
+		grp = kvm_vfio_file_iommu_group(kvg->file);
 		if (WARN_ON_ONCE(!grp)) {
 			ret = -EIO;
 			goto err_fdput;
@@ -312,7 +300,6 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
 						       grp);
-		iommu_group_put(grp);
 		break;
 	}
 
@@ -388,7 +375,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 
 	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
-- 
2.36.0

