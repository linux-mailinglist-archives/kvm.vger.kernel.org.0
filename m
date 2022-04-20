Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B77509064
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381775AbiDTT0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381771AbiDTT0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDFA13FBB
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dq32ijUjAubBAjgugAWm6XsvrQ5hRzy3XuQz2IKyh1a3X9pUwf348wtv2fgrd43MNo9olPJCapmEXEYtedynIt2IQQkqf7bqgWeLZ5GaDO6DeRx/xiIX9oqMby4olSrik2Q5mX22rr9vzVM5+WhFR13Zs39dWD8u+/qd7TqWmJfSXb2l4gCaKP+hTsNR3tuNaXAzY4X8q1QKbCUmOQ7cBynZpxOWo8mtMQl0Rj7MGdHrzT0bKxZOIPhUv8u825v8jqJao2ufO32XQ8UrLORkBENv2QXHIZWMQJNx4tEfCdbKVBRnXGJfQ26+XnO8xZKnU8ke+FTdH4i9Xyof3XaagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJkuj6aBfZTAR2SqokRd7NKbrY4cT6dx0hVCCImfhqw=;
 b=iUd682Xz2Ha3AWyA0WhYkrP04nARW7trZowVXsUphFLafbhLR6cTaY/O81G7A6Gf+EZkHwPXaOcodwFFlYQsUvlkQ6yVwETn7V0uNNZ6mSxPxOvlKgIlrfam8nj5NQirLkYQwRLcFTseVemaxsOyO5PRh/rUZOPfd9bpTIin+6/B51BVCovO1qKquUxhPXBTA8JHGBM4ey0bsX8QId7PVm1Jf9MUAXUq4ZqZ71Nz0GgjjPAJo0fHxRomFu1az10CQ2TZ9iziVKEYWzDqReiN6Oiw7DuqRWPEUtLamNxcIsJhV9k5xSuQcKBzZxdt5O31s+ZCPsEDC/THZVY32D1khw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJkuj6aBfZTAR2SqokRd7NKbrY4cT6dx0hVCCImfhqw=;
 b=X3AusgRgmeDCJNjvW/y9sGDa6uSMuMuzo/szgXjm6aH2ed/eyU835QkxyDqnAT92AlL4H1yks6iVqAyPYffgGUJzPmHVR8hLTRIVfC1ESeXMG8fwxhTejeg7BCt0jbduHt8MTaDZw4jhDpirSvKiF5ner6eDfI0gBLfwbgXxaQb4Yq/IcHHv2GlXlWGg1jE+KA3X4JqK8e9x4fB41FIYPId0iYR5mnTIyjfCAKWBWlALAX1K0hhaJtMQOnxMINYqRdpyR9ypkq3aHw+wEgu9b1nldn0UAFI09DjJhELpGqG/jVXPZ6zCcjd7z3g+XVrcKwgCuqGAcNbSDznnjeXjDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4325.namprd12.prod.outlook.com (2603:10b6:610:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 19:23:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:20 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to vfio_file_enforced_coherent()
Date:   Wed, 20 Apr 2022 16:23:14 -0300
Message-Id: <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cf1a8c5-9ad8-442f-2ddf-08da230339d7
X-MS-TrafficTypeDiagnostic: CH2PR12MB4325:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB43258F96081D381D994A49FBC2F59@CH2PR12MB4325.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9yUBdf5o9NlE68b+zWTxVtMbfmfqlnnoiksAyrUe9S4uf2dyiMzUAYaVIPVjOsz+xyHkWN7VBGAblqRHbzkjeVBx2YGIjbuaXuLROUr9DvMNQJoDvEXkjgQTcierrW3Tgf0VbHm414YR77zN+myhtkpU/E++DFxmnHb3fFeOik3K71cbvlUNLag18TOQH9jJMYvutJ6m5A1+7+ZWqNKHLTOr8IvoOejlcNOAa3la+FmWIoV8FSpqSNV7reydSCfaeiPS7ieSH7esMh9jhRpglQ/ZjbXkY+apo38W/GMO0HzXuRp8gY517Y6HccCyIbfLD0er1zeVRC/rydelDkFFMUJZUGmxn3G40IQmoQY7QrW0a5EoiTlBaJNGgbRq+M28YnYzgCesn8gJMuIVfUAZEW4dYTpftoIcjyvtV+LHDNwjnJMuO6b3e5S+xkQe55jDHfDSCye//w4CddYEIQaD5d3sZ2abNeXBxxDYMPOujXrHIXTmcnom8PekmpzarzFPX88zi8OE6VV4sh91rKjOypid56wErlMLIlw5j/BndLOkU6mAhQnAyi751UaFPYGw6j0HaW47fvguszcQywHRJAjPFmdYXDBrnGlnHfkKxA18TJaqM1yj5r5MAxfSXTDLtWfPXKeld8qE+pRTU8LwUnlNbYBylvJnZyDN0Q4F/xRs5SepvhBoHArezAE7AjK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(110136005)(6666004)(6512007)(26005)(6506007)(2616005)(66476007)(66556008)(8676002)(4326008)(54906003)(83380400001)(2906002)(508600001)(5660300002)(86362001)(6486002)(36756003)(38100700002)(186003)(8936002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bryKtkfguhkhi7su8rPDgq0rkX1V5+EieloM4/S1rrHgEahaOv9uc5pfzZHi?=
 =?us-ascii?Q?nws2PeFmV3FfS28P4F7sJHpTRRfeih8W2Nnvke50eDN6uCM87YbzWtfTfVYG?=
 =?us-ascii?Q?lrshtQuzik2jZKfHQ7wvdwCXfcYnhkyCm3l5P3h3t0LE88CSKTd9UCB7OgRx?=
 =?us-ascii?Q?uLE/XaTkGVRau6dm4i97XVGKY/B1F3VIZkqjkbXn+60f1f4kd5qnf/oyr39C?=
 =?us-ascii?Q?5IgJKFqH5HXg3HCK+o3lpW8ZFiTH1kzE/dyWkCtJgxl+XUX1xC5vB9I+XHH4?=
 =?us-ascii?Q?a0kFWDbwQTM8y6e5mfPRbvzda4vQt7pIdZPhzs/kgxuzkFBavvDnQQnMCNxh?=
 =?us-ascii?Q?kUi3EzMdcj0+Oq8IiAWQ9AQHLXNTW573pRK90Ze+6o5sDf9WoythTNb/7tlR?=
 =?us-ascii?Q?pb5o4E0Q/NxHS9FsN5Begy5oTq77ckVrsElhf+hsJi0jZ9dlOwMLzvjqo3Y4?=
 =?us-ascii?Q?oSUa/4LAYgRMIJqIlcAfivc3hJTd3xHbPWACNVrPT0S42dQpSbPHd3QhZqXy?=
 =?us-ascii?Q?6FIz0c+26IJyG99E9avU2GG5L2c1NdRKl4Uw2SOEYAdTNsE+1wEV0hQmhIoG?=
 =?us-ascii?Q?1Rld5rgxyks2B98LsrGWYjdR8rCuH44oiOd4m3uMA6uTkeK/ubIRzlKAAvup?=
 =?us-ascii?Q?9UUAV6vTkpN7E420fJXC6+lzqFJC/srIq1cd0Dv/EVwmXe92WjfqqzaP1Q5D?=
 =?us-ascii?Q?DWFhZcV2StWTFR8yI7N3ELtiiyp3L0D1tcp54nmNV9yklraPop/VDpRInblr?=
 =?us-ascii?Q?7+cc/PblIXkbi2asGlDws7JUTOhtdo3sZ4w2Uo4PQo6t9A7ZUmvGxyNdn2Pr?=
 =?us-ascii?Q?Gr/yk8ET79MhIsj8SZJRAUUPI4iXVIPWaukUIhBh2uWunr05GuME0jWU42dT?=
 =?us-ascii?Q?lyLpQ6dVtjPtZOBV/79VNWe2X1qKtS5Uq8B5Qstra+X/2vsAaA8jbfV3DpMQ?=
 =?us-ascii?Q?gB+hP5ZrwxHCu6gWDRj89NaVv0ajlDKPi9HPGFIYq174GalyZD65SDgl9EBw?=
 =?us-ascii?Q?jWPb182fir2pGJSjvfG/UC+xUrbNv8gOij9zda3FowiPXhe3QIAjuBJqvrxP?=
 =?us-ascii?Q?RsqVruc4FLbpjeVwsibSlF38Vu0IFfQyl58p1y8Aw0nKk5m0yxpqgLWavW+g?=
 =?us-ascii?Q?RGJ1VxQ8skJXlzoY1WDRjDbthnAsmgPMb8n4ea3T/OiRtid2neYXppnf1TZN?=
 =?us-ascii?Q?RsDCWmBfIRnDfkNqILzvz5ZDE95+mDkfubmEHtpMmijXgjqU/oNffitzyeEg?=
 =?us-ascii?Q?Xb9OtyBeyJuVJsLWNtSo2JC/xfhSnDYezW2gWW6syOhEWX4cjebL42+Hb43a?=
 =?us-ascii?Q?iI7Yq1q99xOOWzzgMkJqHv+d2KD12tbZyNZ9+tm7Z0Tm00OYtqqG11XAxvoW?=
 =?us-ascii?Q?FR5JjoBvLSZvCe9/zxdo+kk/HRkHDt5GkQu4P3pCpRRYzedfZiZsVYth0rd6?=
 =?us-ascii?Q?NqMoyhze6QqoLiHCqoYlj4hWAc3Fxxwh4MaboPMOmsCV1pojwmyt2r+IHzyN?=
 =?us-ascii?Q?hj+4UGHOpS8bouGf5eiVoTW9egiz/c3RdSUXYkCSm2g+5ZJ+cEcafn8SdZ4A?=
 =?us-ascii?Q?uQ2EK3lEFbCqWYdcRcIiF8W1cCAiOW6nhS+6cogghQYkerxFtBXhHlYvWSH6?=
 =?us-ascii?Q?yGGPRf3/gTqCwRbKQb9NcP6CGO5QTN+/i4F/ZKbLsLu2KdFnLakPJihGj3AH?=
 =?us-ascii?Q?aalz4xRseFY//EBgaO4w0/KMaSj2FQ0A02xtrJKqZ0NsrcgGq/SYHNFq3oIS?=
 =?us-ascii?Q?DAwpNrdaGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf1a8c5-9ad8-442f-2ddf-08da230339d7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:18.9717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9MqmIK5yedIWya1qvWQdMKzpLir/xfxNAeER0EkJ9LEURQ4hMjDH1NSwjN2L6BM1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4325
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 30 +++++++++++++++++++++++++++---
 include/linux/vfio.h |  3 +--
 virt/kvm/vfio.c      | 16 ++++++++--------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c9122c84583aa1..ae3e802991edf2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2005,11 +2005,35 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
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
index 132cf3e7cda8db..7f022ae126a392 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -143,8 +143,7 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
-extern long vfio_external_check_extension(struct vfio_group *group,
-					  unsigned long arg);
+extern bool vfio_file_enforced_coherent(struct file *file);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 50193ae270faca..2330b0c272e671 100644
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

