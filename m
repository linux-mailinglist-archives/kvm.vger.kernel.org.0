Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCC0509069
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381784AbiDTT0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381763AbiDTT0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163DC4551A
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d07xQzTrEAE4aAaW9phUtxLww/DuvB+ajbEUuPcoyQSvhjGUg8Nx9neNUi5GejpVG92Wi5hk1Py3rgDdZGAGm3gCDiUWv5MYxC2jLch6nCl2o/1y+xc7v30M96a1f7uplGUYZOPiywCCTxePncVQhB+3r/HE9oijNVJLrbmNzExejpkNxXQH7zQ5JXNLs88DbcXnuQcmiRIpE8sKrOZUjFa5tIyZGr/sC8t+QtcHqFp2iHdXpu5YOKfNjK8NCHM78eUI3dGj7Y4YrBa5pe+7+Zo77x6WQCA251aBEtKcGE2P+FurxmQP+EfhQ8mKwzyyYzbEy4WAtGbDGgfp8qAksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOR40/At1boJtRmvFgNosCrdc34vkjdQ7fwVQW6HJJo=;
 b=Uz2HhY0GXuOi+AwOi7tQjKobHVhMOURpKnBouYDvuck2JRr47bOn3B4e+tbZAx8qrU9xVTt4rldLYcYNQZrXeW+oPp2yO8BEqQ3ku8jBddZanWj9hBSpkTuozvlJExRa+1Zo828Loht8C1S2g+xqXqWcdgGZw6v9UA0B0owW2+3QzrQKKNnbrY6s46tMvaoi54EePNh9jnl+UcdDLXcKYO16yXQ63XU1XU/IPU6W6bBd0dQVYRLzZj0BxTD8s4OvTnfkj4K1LHYM6ozIM6ZEdn/s+xfv/IcAnw56qsTWLAXyeghCyZsV7YOZjVk18w/nsefEfLqkLX6ahUvapcEhFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOR40/At1boJtRmvFgNosCrdc34vkjdQ7fwVQW6HJJo=;
 b=g8IjjDODz1ZoBU/RS3i2f+DKU6n4YEPOYGd9MIFTtyjsOvLBuQL5+BMVpdoZ/Elo0oRo4Le6Rw5sXGAjwsHLhlrRdH4YgRSVStFGlWQYFITv3CDVUIlnJBjl+RpKQefCEeQKTxgY4An1Rz3jlVAezwkDz5h9PjUvPTGQJT4y2L9gkXgKV3oWkaGwJ0mwaWCsYL5tmPtL289nBlWYFQ6vx7RnPBpi8JLsRDxaxruiZIgP1m7wgiELxfE/Vp3Tpy6WHJGeIm6Y9bxrscNtNxZgUAaG2+l+tC8uLx7fh5HfxM9vFK7KOo+to9+5Nd3TrkPnbzkCRZPajhVPUwdhsb4K1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 19:23:21 +0000
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
Subject: [PATCH v2 7/8] kvm/vfio: Remove vfio_group from kvm
Date:   Wed, 20 Apr 2022 16:23:16 -0300
Message-Id: <7-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:208:32a::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89f7c04e-aea1-476c-54a1-08da230339de
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4131F5827D63C6F28993BF29C2F59@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnBIAEabVV0ZUuweRI4Q1bZI45wpwSCSpQcumx12Fs9skCwAJNkQ5P/UQhkBABSUwUoBpCRC2R9O7uedr089cUv5LPMIiNzCaZYyXUJfKeJAh6CrSQBhgAHJtlS8Mh0+gofat9XpNaWn/KleWeBx7SeOLjCOMPT/I/rm8uYV3jJtf4YdEDkbHwurzdKc/agqT8SVKGhp5NhbTHNME6JZ1H2vIy1YnnL0PYUK6vB0IaXEQ97l/HjJ89iCYe7FHFV8uOAyX73X5cggbXDCWL507Bz2CN/0vW5B5DkoTaZE5TY9BZv6GQ78UxgRvmBUqKPFGhJMbSiplmAE0/XpEk+5DlWBPI2mVC75AY3GNjb9KvthMDDTwsV/bI2trd9SQVD/paDbnwZAjes2WBAINIp4CULhtd9PqK+/l5uVkWuqBHEK2qlfkOLWdZTEoKHr7KWa2iGfzR4s8ucsBu9LpW42z4eOG/eXvaT8HoAxb5uyCPjafmF+YV3txoEyqs2ziBtFIJU5m0akWVQ4/ZAAkCaVi6qUGYaop6OUK/xIkvZkOaZFkkAovHDcrGEJwmOOD9HwFsb13RdJoBTNa8KaJa9mnQvA0rE0ulKH1I3+ACUfWurNiksZM6AS6iHzd8Sy3FwstIfF8wFFwmn+3E710TEbszE9inyP/Ax9X0Oq4ToauI9OXKLRj72owlRh6U/V/DM8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38100700002)(6512007)(36756003)(6506007)(66946007)(2616005)(186003)(6666004)(66476007)(8676002)(66556008)(8936002)(316002)(4326008)(5660300002)(86362001)(83380400001)(110136005)(54906003)(508600001)(6486002)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zHZm8KhE2UX87/qtyccIM1EXcZSb3lhy22qd7YJ7UGUguT2VFHmpXZefLIqJ?=
 =?us-ascii?Q?UsQ4Fba8tDmjh0ou4TpDJNv4uQF72rF0aQS79KXE9onuqb7ud7H1pfYtEOhV?=
 =?us-ascii?Q?0tUdMPmkwwi7AyHf9c3Ezl/Y/qQmjIEMEWVg4FD+I5Ue0AViVO5crJM4qcok?=
 =?us-ascii?Q?vg48yRLhLfOzPeVHXb9pz8llp7a0Jo824fKyTSB0H8GYOAPL7wr8H2tzjRmd?=
 =?us-ascii?Q?Z4bO464lRDLSGT/q1/iEw87Q0I67kwUOkjpFL0Dfv6iw7P35+1YWs2zGpsAu?=
 =?us-ascii?Q?nwafGOFn+5LwsIL2KoZjlTuqHeZDOxTuBMC+DKZb2SJNpwYDWU0gesh3WYhj?=
 =?us-ascii?Q?bJNMBnDyQBtyiB48wvva7bJKF6WerG1HMxJVLjg1ereIDt0uSTSXIGHEjC0O?=
 =?us-ascii?Q?pVcSlKd4hxVH7+IZnAzLYnHJ/U1LJP7kRGYzu8bMocjpvdcWeBuzgTGHP98o?=
 =?us-ascii?Q?TjYDYnebHQHTfPaFiW+EUxe3nPjS4RpFkALtjuIsnvtQeAET05u5nt9pIUcB?=
 =?us-ascii?Q?3PnH65xYo2LX5k5/kathAfpkCzr/VB6pKIvONlU/wTdU8JiAzWJvsmMFPXN4?=
 =?us-ascii?Q?s+tAVn9ca5AUsdmzr+Zn/lSNJP3bL/5NEx3AK0uEWFFDZhgjIyNkjJZLkl/n?=
 =?us-ascii?Q?A7s7hsvvt/9XWHBvH5IGczoU9opK3N4SF1RG+JX0lMGq+Nvrjlw816bxeqZk?=
 =?us-ascii?Q?R08ibYJ8RFexHA1MZBFEQAF7U5VzUm0tx+vzPVyHFuDUhz+m+A1hCaBwTVkb?=
 =?us-ascii?Q?LRD9LbyekW9CV3Uq/z9GXdZrGEIA6DELDRXasx5LtjoFI5CNHJyjPOKR8Zrd?=
 =?us-ascii?Q?5CKFdBT0gR97FsPmTM82Th//YaVLjPswiW/9ucMH5boyJJwaeSKkuy65ZeSo?=
 =?us-ascii?Q?xxEb63RIy9l2Y8+Hm5lZHnKmc0ZKn0y2XkLainOlv+djr4kvuXNcaOd2haw/?=
 =?us-ascii?Q?+hyFYcnykZawUYLvEJlAJ+7nLbhczdTgk78yipXIe+Ljm5KeTmRUdZE1xL9v?=
 =?us-ascii?Q?Ja37DvswlM86EXc2s6HfvQzRxajA3BrIpCPkr/coJWbD6XeuzX9vVRVPSIsT?=
 =?us-ascii?Q?D/XT978Ze9cQgo/aC0BCCqqJnvvQeMIlpjv9Gzs5XRG/iUk7RiBrtgYPbjVM?=
 =?us-ascii?Q?3fE/+/rjygdk1bQiye0oParK/BEy0uVlVFSoB76V8BAyGTCu6EYO4bZu1udv?=
 =?us-ascii?Q?KmkjwhYzml2Zv076+8Cohk2kvwbgNzNtRNJ6E9USzTFR5etr8axowPo5JHKb?=
 =?us-ascii?Q?My/cjxCaWn+XsgQ+R5ku3CRrdzbtHCxczD+Pz3k/o3pYaIHVXBGKjPmJd+N9?=
 =?us-ascii?Q?n3zt4N9oMJY4yINmfqL4+ApT7ygaRuD2ZTcTIariqgN7j7Vb/qI5pB/kncAb?=
 =?us-ascii?Q?Pd5pJyj/UwrqP283PIgQ61CPAE3JyqOBitZ8ubA4gF/Z5riyUf5BWaMdXKuU?=
 =?us-ascii?Q?p5ZOX1jrYvSRJnMioIgwtF/kyCzDbhJbzedDnHGK2XGgjlpDpA63PC4SKDs8?=
 =?us-ascii?Q?u/8A6zfOmgoxTEHbZ8lmnjUW21MdDsF5yelH95xWD14BY5xQxWaZ7B/uOetG?=
 =?us-ascii?Q?PLbzMGWVpXJYTHRJUCC742xaMT3VopZy/hdXFls7YSLrDRYZJQF8dnr3YTXI?=
 =?us-ascii?Q?0826b/SX693FiG0DThOj8/vQ/x9yhg1rkSI8knBLQk1uCdA+gmBaQNG6ndXn?=
 =?us-ascii?Q?sS6RQ79bJZbnfN6AGRYQfssIjOik502tJS/o0ChEvDNYa5tP7bKQ0nu7A7Ct?=
 =?us-ascii?Q?qAc6Hr0oIQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f7c04e-aea1-476c-54a1-08da230339de
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:19.0342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ks8XHlf/7QfAaiGRDzw/usruiYnkhENz0v8StZniGRSB3jyMKiLteMNB7xr88Hk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

None of the VFIO APIs take in the vfio_group anymore, so we can remove it
completely.

This has a subtle side effect on the enforced coherency tracking. The
vfio_group_get_external_user() was holding on to the container_users which
would prevent the iommu_domain and thus the enforced coherency value from
changing while the group is registered with kvm.

It changes the security proof slightly into 'user must hold a group FD
that has a device that cannot enforce DMA coherence'. As opening the group
FD, not attaching the container, is the privileged operation this doesn't
change the security properties much.

On the flip side it paves the way to changing the iommu_domain/container
attached to a group at runtime which is something that will be required to
support nested translation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 51 ++++++++-----------------------------------------
 1 file changed, 8 insertions(+), 43 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 2aeb53247001cc..f78c2fe3659c1a 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -24,7 +24,6 @@
 struct kvm_vfio_group {
 	struct list_head node;
 	struct file *file;
-	struct vfio_group *vfio_group;
 };
 
 struct kvm_vfio {
@@ -33,35 +32,6 @@ struct kvm_vfio {
 	bool noncoherent;
 };
 
-static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
-{
-	struct vfio_group *vfio_group;
-	struct vfio_group *(*fn)(struct file *);
-
-	fn = symbol_get(vfio_group_get_external_user);
-	if (!fn)
-		return ERR_PTR(-EINVAL);
-
-	vfio_group = fn(filep);
-
-	symbol_put(vfio_group_get_external_user);
-
-	return vfio_group;
-}
-
-static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
-{
-	void (*fn)(struct vfio_group *);
-
-	fn = symbol_get(vfio_group_put_external_user);
-	if (!fn)
-		return;
-
-	fn(vfio_group);
-
-	symbol_put(vfio_group_put_external_user);
-}
-
 static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
 	void (*fn)(struct file *file, struct kvm *kvm);
@@ -91,7 +61,6 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
 	return ret;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
 	struct iommu_group *(*fn)(struct file *file);
@@ -108,6 +77,7 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 	return ret;
 }
 
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -157,7 +127,6 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
-	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
 	struct file *filp;
 	int ret;
@@ -166,6 +135,12 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	if (!filp)
 		return -EBADF;
 
+	/* Ensure the FD is a vfio group FD.*/
+	if (!kvm_vfio_file_iommu_group(filp)) {
+		ret = -EINVAL;
+		goto err_fput;
+	}
+
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
@@ -181,15 +156,8 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_unlock;
 	}
 
-	vfio_group = kvm_vfio_group_get_external_user(filp);
-	if (IS_ERR(vfio_group)) {
-		ret = PTR_ERR(vfio_group);
-		goto err_free;
-	}
-
 	kvg->file = filp;
 	list_add_tail(&kvg->node, &kv->group_list);
-	kvg->vfio_group = vfio_group;
 
 	kvm_arch_start_assignment(dev->kvm);
 
@@ -199,10 +167,9 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
-err_free:
-	kfree(kvg);
 err_unlock:
 	mutex_unlock(&kv->lock);
+err_fput:
 	fput(filp);
 	return ret;
 }
@@ -232,7 +199,6 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_file_set_kvm(kvg->file, NULL);
-		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		kfree(kvg);
 		ret = 0;
@@ -359,7 +325,6 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_file_set_kvm(kvg->file, NULL);
-		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		list_del(&kvg->node);
 		kfree(kvg);
-- 
2.36.0

