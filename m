Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B3C51AD9A
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354883AbiEDTSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343629AbiEDTS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75BC488AD
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwQ+qfDc/guszBhN5aF+96h4pACHnI7nnLhdKplE9BpG5BEF6D5DdZ42G1xATeX0X/z6qYqPZ5K16+H/fjKVNuRUfnHL4cm1ZcAmy+MJ1xVt0ZtAbFP9FeFz9a5xdfz+4aCMjmC893lPf54l0xiSWz7/3/D0D7Xijv5XP0u0zOC3+HRD503F6Z6+8i6I2VmK9OjYNmSUZICjhNU+4pQUtYPk/AYZVBnl6rkwUpBfgk9j8MsZ46xPOrHwHiapedfx8PrEqq7aJNB1HiI047zfYUcaPRxQLvWE/6pjjpvg3pBmoRh2VRUrNF975aJCrq+8cC/a0KKje3frdz3s49iTUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjXSS1zTzdZCb+fxCy9eb4lylTxxy4+UEg9JTOsRAsQ=;
 b=jV4HoSkzydJee3/itgpVnKVR1vNq+0oiQkaaePeNuVsjmpNEPQFuslPbuAHHiQ7L6Tw6SizzSNac+spjjL9U2RdJxM5TkL5ic/FF/xC1Z33F8/dXQ84EDi3jNHdxO5ngIWyHK16tSdPrVkjNhXZP1/rvrTgxvUeGCwRocXqCjFpxHnBORPE2YqqaQcD5bSkvClTM8p7t3MyaWmb3EXSqQqB6Lhoyy2Vo5N8oM4ENaF+i2xTxMQorch8jxTnfrVhL/vSvtp10o74Qdy4AJDd2BeuOOGo7sYFBJth2mXfoK2eEQegO4OMchHGKktvge/AzvvglMg1ojc3Zeak9LNiUzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjXSS1zTzdZCb+fxCy9eb4lylTxxy4+UEg9JTOsRAsQ=;
 b=W/0VZ7q5D/dDFhPI8pRJFpwwDshB5abkbNrN5Kkpl8xbxb6tlja2mExdO7HzJXBPGMZLxhiHCp1adSixd1oCpm6XZC/mEMCZhlH000Am+/SeBQvNYDnoOdRRE1+hUhVPZvolaezrX9gLlrHmA7BlxVk1bkONMLaj4BUGSvwijIC1+2GYO4OaWxYvhULSqnls4OB9lPSWB1krPZj1t87nRBwW97crxUeAbBHDtRGJCk7RnNue5+5HlxhNo1Xi+4l+0oXhfHS6VmKuwn8PLY4YXjm1Y1k+0tqEpNVzzJm49FF6Y94/WHRPG702Yuf3wxgjCZqUC664+e05FCkHaGKGwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:48 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 5/8] vfio: Change vfio_external_check_extension() to vfio_file_enforced_coherent()
Date:   Wed,  4 May 2022 16:14:43 -0300
Message-Id: <5-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:207:3c::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f98849af-b800-4239-6da5-08da2e025ac5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1419FB5622EF0A2CF43D95FFC2C39@DM5PR12MB1419.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcRqpG/XI1xsHkmEWKgHUDNPejYBcDZXNe+2Jz8PJpiAHAKW+H8KxGBe2hebHKbbI23sVefy26G0cf15TmZCGaGa1/XxigDSB3GoOUxzFSr2YkFTpeVzvt0Vj70+Qq1BS2JsfJ5jpGZ4nFI7hJGgGhmOJDy3CqX5VjZiEjGbOx9+DlgYbNfxtY0L77dWiNLzUZ9I2oJ2weRqhyb52NusEuc7dTN5hUQ+nSQEwsI7yQj86+j8QYZIdqLubCvfVxusr8L+uJvTsgNA5pAbsePTwny+DSb0rA8xdxy5yc3RkjC9mUlOj5Ov+uw0Dr+H4F4e+QrHHnuNS0XKz8QLbtPEJFHYGaMO0ltF+81X969lJ600KYsgPr4joWmv4NvaFXjVp/Glxp4xY8NzRceRwfaj4GktRnluUQc0b/xaH4qLq6Vf1gYVAy19Djg5AFjckdCSeVlMzCv8GZ9BcbSJrvWT0rAnpD3pf5t8rKXaJpODwExkpOfPUtPM3kXVvnzbiPus9xdFT9EejQwPTHwmGgZmSepPZI2iWSb+Qv2q3CD9Qt2ZER99p0YjMovzATGLppufJjBAP8dC30QZY19LaXO5uPmNgAgd8HvYBTgTA+WkOHhsb7Tvl4/FEyoJaBi2KeDD6DIJzvWKOBSwIYaWTCCOE3KKYJKihPwxnYymL+YXMFcyffQpqm4aTon165wRgzAKhovpIo/YWUtbofwhEDdnQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(110136005)(54906003)(5660300002)(6512007)(86362001)(508600001)(316002)(2906002)(2616005)(6486002)(83380400001)(36756003)(6666004)(186003)(26005)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n9I9I4AObFEYbOq1P+ku4wteLwaQnbcbhSyjMjhVxfP5YgK/jj6B22xlh10h?=
 =?us-ascii?Q?jTBkeFQXj10slad3YjZvHiQUFf/ZEoDS55C2YqwHH2f5VRWOKsWPBwCiOlHb?=
 =?us-ascii?Q?o1+lOn/as4B3ERaXs1jlXxY9AQufib2HICst8/E4Ic54iv2hVwzLaJBTwjAT?=
 =?us-ascii?Q?/Ui8Az9CeSelF4H7FoLT2yVzEb2Cf773tY/x8Ra+1L6SovMSHezhY/fi+KLL?=
 =?us-ascii?Q?l7iwQxWu3Mu/8kHwFqO1SsM4h+okGs5IifkSMbjb6H/q9eqTho3amjS63IrG?=
 =?us-ascii?Q?agrOH3+NTcA9Z6IEbBVSC8tD/nvabEK6J1KXjVkmiURwFDjH6IIcabPdmp5s?=
 =?us-ascii?Q?BiJ8Ve6bzOnHGQZgZT0VY/zf9faqYKd1bz8+HEfSDovaY6LwV8XRf/kFsWr8?=
 =?us-ascii?Q?fPDQlBBX0saqrnIQjv9fszSa5G/X4EAUNFb+S9WQ7uB2ERRid+ZNmWbs+WxV?=
 =?us-ascii?Q?P6Ps++5GcQGXziSak1uVouRfnfVkgv20ldbp9Ql/ev/KDMmHvTbCkNMjWvQe?=
 =?us-ascii?Q?TyvtddCfoZ6ZmeRFmlAztF0h7rDfRATfXrJ0sJZqLXdnGcjRp/+NnjXJ717C?=
 =?us-ascii?Q?Sq5/I8NC3qwB6PKI0VqmnfbohqsWmCZzFYQdCK9mQjGhXJzdJbWqOoQ+TgDH?=
 =?us-ascii?Q?uOSUmRYCVAzHZVqPpah+0W8cq5Oi9cGPQBF6UTeNZPqhgPIEuWH/NtNkO92P?=
 =?us-ascii?Q?7jjNU2OcRKgCnWHnUJRTV2EjpHZJ7U2GqEhTEgW0EfACLF7cq52lT5/WF+EW?=
 =?us-ascii?Q?5X2GFO/y16648JngbQjo2QCKXRgI6g1OsmbazW/Je2Ubb5EfqHExJmzYDWeH?=
 =?us-ascii?Q?sn12UmpMx/wRKdytsahj2CbBR87psH+xFH5F28jHMOLQbojQ0TeeW9rpjHaQ?=
 =?us-ascii?Q?c+ycHNKuPJkjGHjmffN6hYtwt/rKDZRkAwrWzlpGONEj3kw76oxGOG1xyn+I?=
 =?us-ascii?Q?LFUIoy6y1AxKxxslNO1YT/YZmLXpPoJeUMXS+A3YOIne3i/7plbWMsFnZSXn?=
 =?us-ascii?Q?+YdpmXy1D4yXocb3IWFYoT/IDjNG+9ie5tKXuRomQzmUlrVIaf1HFycIrNl+?=
 =?us-ascii?Q?5uzs2162ct0MtbRlQpkoVndvq1G7jQWMRLFPSc340sU/UqWfr4eX45nsB+Qr?=
 =?us-ascii?Q?6nw5hi5+ne9wgVbpyPndWswqu/N50MVuGLgQdm03z5nLv0CYYXQrqpnBd57j?=
 =?us-ascii?Q?xs0yETxWLzL2E2hvuuFLRsPdUr8loty4/lsrKldGxMbHzcx8nb7cAyAe1FGp?=
 =?us-ascii?Q?SnV3Dz/v4qt1XM9f0cbYOx0S1AZyigpewCRnAydOIfgjv0ILNHku9P3xCQo+?=
 =?us-ascii?Q?WNPnRfQwEma3RGPkCCsa3U+tmUfV/K/bXuvSdsBAoQmzRGWx3ZMBL2VXXDsC?=
 =?us-ascii?Q?+IknqracHGWA/1JIv1OiLjkS3I9+V48YlIzh8x86TD8Y2t7HmXsINj90yWQS?=
 =?us-ascii?Q?YUX+4O+crpfBtZnc1ZK0KsqiY5k+NRKXDKKdAIcXiiJyXNbCufBe5PfJF4PW?=
 =?us-ascii?Q?1+S3l8EGm/Gzr+x9Qo0r8XGsnFIywZUGHYoI3y3QsxkNLozrag+vQ/RIE0WV?=
 =?us-ascii?Q?4mrTmDePSJsJvZqAUz448t1+bdNTTgEHrKr2BDdPCB0kXURCA4QHQXNy56iZ?=
 =?us-ascii?Q?M6yVGd1XCS9OepsSWfL1G4G/dSjEvtF4j5kVn7SQOjqqfvreTVJ/fjo6syOL?=
 =?us-ascii?Q?hSCc7YUV9qWOiFi46aevz7wQpwBj18yOC6NHPrDdXo4rwOxGWiAwhqJenSUc?=
 =?us-ascii?Q?I7fPiTyTkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f98849af-b800-4239-6da5-08da2e025ac5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:47.5765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loM6YZ1IIajzUMR8COyclnGesK2wmuMynejhSIhEym3yROKDjKfQl7yPlbR+LzON
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of a general extension check change the function into a limited
test if the iommu_domain has enforced coherency, which is the only thing
kvm needs to query.

Make the new op self contained by properly refcounting the container
before touching it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 30 +++++++++++++++++++++++++++---
 include/linux/vfio.h |  3 +--
 virt/kvm/vfio.c      | 16 ++++++++--------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a451800becfd86..ee38b4d88d5d47 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1721,11 +1721,35 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
-long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
+/**
+ * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
+ *        is always CPU cache coherent
+ * @file: VFIO group file
+ *
+ * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
+ * bit in DMA transactions. A return of false indicates that the user has
+ * rights to access additional instructions such as wbinvd on x86.
+ */
+bool vfio_file_enforced_coherent(struct file *file)
 {
-	return vfio_ioctl_check_extension(group->container, arg);
+	struct vfio_group *group = file->private_data;
+	bool ret;
+
+	if (file->f_op != &vfio_group_fops)
+		return true;
+
+	/*
+	 * Since the coherency state is determined only once a container is
+	 * attached the user must do so before they can prove they have
+	 * permission.
+	 */
+	if (vfio_group_add_container_user(group))
+		return true;
+	ret = vfio_ioctl_check_extension(group->container, VFIO_DMA_CC_IOMMU);
+	vfio_group_try_dissolve_container(group);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(vfio_external_check_extension);
+EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 
 /*
  * Sub-module support
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4108034805fe6a..601f311f6c2e55 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -139,8 +139,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
-extern long vfio_external_check_extension(struct vfio_group *group,
-					  unsigned long arg);
+extern bool vfio_file_enforced_coherent(struct file *file);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 0b84916c3f71a0..d44cb3efb0b94a 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -75,20 +75,20 @@ static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 	symbol_put(vfio_group_set_kvm);
 }
 
-static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
+static bool kvm_vfio_file_enforced_coherent(struct file *file)
 {
-	long (*fn)(struct vfio_group *, unsigned long);
-	long ret;
+	bool (*fn)(struct file *file);
+	bool ret;
 
-	fn = symbol_get(vfio_external_check_extension);
+	fn = symbol_get(vfio_file_enforced_coherent);
 	if (!fn)
 		return false;
 
-	ret = fn(vfio_group, VFIO_DMA_CC_IOMMU);
+	ret = fn(file);
 
-	symbol_put(vfio_external_check_extension);
+	symbol_put(vfio_file_enforced_coherent);
 
-	return ret > 0;
+	return ret;
 }
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
@@ -136,7 +136,7 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (!kvm_vfio_group_is_coherent(kvg->vfio_group)) {
+		if (!kvm_vfio_file_enforced_coherent(kvg->file)) {
 			noncoherent = true;
 			break;
 		}
-- 
2.36.0

