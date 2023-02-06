Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB52368B6BE
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 08:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBFHuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 02:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjBFHty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 02:49:54 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96CE1CF75;
        Sun,  5 Feb 2023 23:49:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTNiPCF3AmyP3MYgZuTvz3MSn9Uq9zP3GgybfDDeC3e3lCUyL0UGqIWzr+L5C71E7bgB6hMmGqYga3WpRF56apR1HE3eRZlWxASaqHKXKdrBokTb7Ozg/gO+l2MC4Ld5RljeihEUYBK9IM+kWk+geqtPeyJJkTgdOKsQKcPlNU2CJzCmfZD3HRuO5byjQ3bAfKjWgC2LTdbxt81fe8oUrE5q0F7fKIWmJ4GxjfDOgl2M5gLeYH+QNuhWmmTTyxMbTmy4wRn+SpAGi/WUyBWrFnLE3DX+YUX78/SNDZ+BGjfT8chJUx110ciY+Y5Djwrz6rWHr6YPWf6uMI4gQbl1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EJyBunn0zT5d/t0YMoiL/ukwvRArAw0I+071Y/Pm2k=;
 b=VDyB2Hv2n45OEPJ8dQ9xlV4KOt3ZfMypAsGfaul0is5oM+cezUOq6+OHZ0fUJovFJF1q4cWJJgOKxMxDGFhGamJggn1ODOBfp0mEGCjfNHnbqtTIbsc94O42ORC7WJJ7pMeTSnqikVAvJ7uTW+vnSfpNgvtObwjqcPrr7oR96GErwF89fjgxsXW3FI0ibBHxFTl55wvrb8NvlK1yP1sgcni4B+6jPZDnPel+17kjARloof10xce5QhXn5ojJwHKo2qYOUHXUIGykKRujWbmldQPbSl2WPmS87CwCt2Yj9P0m2AuSYfTMBu9F2iZ2T8mQ5lZxxGJTdwndM+Tm4KVQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EJyBunn0zT5d/t0YMoiL/ukwvRArAw0I+071Y/Pm2k=;
 b=HdDvwTlno/2TJFtEwBIiS5c+AD1oEMvYqSxurzNyHD01OoIabNHwyzh/mIkTTgM9RtXxdonmgc5LImTBneN3gImrJwxvCtO3prL0TKaAWcP2MQIz0mjULA2GezhsbkxUfHouo9nN2zMGi79arJIK2cKCP0k29UU3oY1Vmesh6XMNMyXzk6ZdTnewXJuiGT0l1P6WEaPvoOtgok2ByKpKE+ZvFtpqZ8PxHNcfPKVqlAxX/8758AmEMs0krkoG0pqz0I6A0XwdxrMuKnjldSim9waR2MPiOJ0ZDre6eK3KkIk9o3QjRm4x6CRM0eqLykse91XKNIZp1mbef0MmDS5IEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5118.namprd12.prod.outlook.com (2603:10b6:5:391::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 07:49:00 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:49:00 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 07/19] vfio/type1: Charge pinned pages to pinned_vm instead of locked_vm
Date:   Mon,  6 Feb 2023 18:47:44 +1100
Message-Id: <60d8812272042f497b8d661f031f2cb593370b84.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYBPR01CA0191.ausprd01.prod.outlook.com
 (2603:10c6:10:52::35) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM4PR12MB5118:EE_
X-MS-Office365-Filtering-Correlation-Id: a122e17a-0e75-495d-a900-08db08169bd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D19c20F/3H5aBZUJtRuOisDUPLPCb3g6LkxaoePLUkkit594ylhxEln8lwG/d82+XWI05rsnfmCDpC1vsCuFjbdq0T+KCv+KHNH3Z1aAqkjU33XcFrBUQZbMEeFQgtvkBiGTeIJSKIQ2MddZlxG3YfOmSew5kvepMZq48suLfmTQwBEwo33I70s+Ja7PUUn3QNSE2FUThE0XFwbxgUaMIVe9GUF7NxVwc0qy2wj7pQXxrzDJgUHC0Q/JBTDXEsmthnznbrRHDiwJWaA+aWWrSoIXSx0VRQWGcVYheLkGBLu+xXeyIC2Gw18dBemMc1lxOq9jPC/DEAWZgqE7doc79lVQdyjo3KWLVWjm0JFbRAuXGheBNJAPf+5889LNCR5KX85ktUrTfOcg9QmjlEGFM6ixS39AqYugLMq7WkqF9RollRnLkbbzSyyHvE7kVodm3SJcWO9ptdE4zFYUWLipDugvSD+eqj9yI9v3B3/ox962XFxUFNzLjsjNCmQByB6eqtA1ZuSgg2tVdvGMkg9/RJlmsGzydh7de7yXSi9TUo5rfcq4YSgkGmaVEU3CzfVio1l9S/WGrRARhBlmNFsOVmZEcnOu6RLIM+iasIdbBDJLU4TfVxUJv/FRYQK+cf6Yk+LM9OBZtSt76bhD3O/kNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199018)(66946007)(66476007)(4326008)(41300700001)(8676002)(38100700002)(8936002)(6506007)(6512007)(26005)(316002)(54906003)(7416002)(66556008)(6666004)(5660300002)(478600001)(6486002)(83380400001)(186003)(2616005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7zc1D3qcVz4pASVKaNOAYrrUtV515FbAbdEHWZkkbDHYjdqtKw0XPemXYJSY?=
 =?us-ascii?Q?wcfzLz2N9qbtXnZJfs0tBfDB3GSEH1wVwNPZ1X6UY1BJ5KrPEplmF0HpxUZP?=
 =?us-ascii?Q?sWX/gkHfhPPhl/FvT4t/8RXEzjCW9utzJPt1FSXPpNFy0wJvExmYLYGZliTc?=
 =?us-ascii?Q?1vfC87bBfJ8P/upzU6ZwIuW0LWEBZ0TU7hNJQUK2ux5fpkRiux5QqH1EpPEL?=
 =?us-ascii?Q?od6+8+qHoXHKoWqjCAOCNFCIiM5F3sMg3f35sg62LsokIe5xTlMQWHSYlIOt?=
 =?us-ascii?Q?v5HNIHWZaLJrqiPqD5GHCUJMUoruk4gxNmPkdWy4YTA91t2WFJajEHXQchyN?=
 =?us-ascii?Q?ePxdNSsLESXHZEPRmIfHIWUa/FXfhK2k5oLJ7EUi/Hz/vg37L2ip9MzKCGP1?=
 =?us-ascii?Q?f1MtrZem2u0dS/oMmRY8wcCUgiedpGDfPp6TAzB4l3RAwnGq+VoSbkO/OEB1?=
 =?us-ascii?Q?qAO/IY6mkMicIxQsOK1U7b/1SMMw1k/31EwMPMRVYNpKy3Qi1si8fFkTaNjc?=
 =?us-ascii?Q?fpUMamA2bQl8HojR4dbZvu+kj2aXstteEXKk7+phR0UYv7Y4isQsqxem2f9Q?=
 =?us-ascii?Q?EtruYJGvO9qghNvs1VaZ/0iBS+N0UEzwEN663iGblYAGHlYVrnOU8sUd6YsO?=
 =?us-ascii?Q?SQuba1ohT3+BzDMfhKym0u36eIbfwLYO6tjopztiaoJg77KqGbYGTr1ClDpD?=
 =?us-ascii?Q?ZH6yI6h/bfpBWef3lfgUoXTqskTgc+xq90tObDDdTXwsIOy6avYGH7xDcfFJ?=
 =?us-ascii?Q?rWFQgsNt3x1CObnIpEO2yHE+n1kw7WXR/wR8svDv2R8SJ/ycXZTmlZ3WogEY?=
 =?us-ascii?Q?3gW/hBiaso/oZdTSl76qJGT1pwqVQCFjZsuJyxXjned/0NkrGnTQy9RGjWMW?=
 =?us-ascii?Q?a3Y7HoamZbppfx3D+cZNoVUH4A7mdhLi/of3bKSbp4gnekkEQAhLOi7cGLz2?=
 =?us-ascii?Q?UbtrH0Ji1fAe984WujANhSml4Tl4OQjAGSUPKQwWBScmb0mebOu2Ze2Lc6wR?=
 =?us-ascii?Q?1cbriRon0gWwJNCqCWiyLu+yxeCWaanKbvUwSI3xWAClIRq+F6Hel6j33cT6?=
 =?us-ascii?Q?17ZUEojAfuS5quvUQH+xd7teq9ytucZb4M52lvZAzsiCjuLODlYHuwwfsEKM?=
 =?us-ascii?Q?hu7PsKg1viWrQGxHxBax5NhSPmSsFb73FBaBWlSOq4ulWZQo1M0Qs28g3Ijt?=
 =?us-ascii?Q?oENbr7Wdb2t9E3AFJoaeQYNUzwrSDwOE7ARLQrq7us7gDNOGQR62g+f88SHw?=
 =?us-ascii?Q?Pq/D/D/hbmBVJYGY0JqE44wM0Zshh2j5g4t1znhkLLxDJuFvfefxHF6Z94MZ?=
 =?us-ascii?Q?Gwci8zh+bwxhHueDNR/jB1YC5/krCaVWho7fV4J4PEPyfHN9/HhCvdBhhdA9?=
 =?us-ascii?Q?DbjnXenyy1WwDwj0rojUpYu/JmgUwY578KclsGklzVMkBXHquwuys7EGWL+D?=
 =?us-ascii?Q?AgJYfIIWMop+ns4bOfJ1/nduNR+t2xGPB8cOeXF132uSMdDue+oaGLwGRzbK?=
 =?us-ascii?Q?4ltbp+RExjC37GcxTHoXk5J2BXSYY7x4hlNeGz425lHvovqNcU2nJ4s8/HNl?=
 =?us-ascii?Q?3flko8QKgwAAa8P2g/ug2lOCRA/95k2JHR2Kid1U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a122e17a-0e75-495d-a900-08db08169bd0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:49:00.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wp+R7my8ypqqhhSOfLO+TVLqtpDWGatzGK9uJJC/Lw68ZvcGUlzUXp6UMcD/A7fO22cL5YxY86EhX2g6PtdhlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5118
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This switches the charge to pinned_vm to be consistent with other
drivers that pin pages with FOLL_LONGTERM. It also allows the use of
the vm_account helper struct which makes a future change to implement
cgroup accounting of pinned pages easier to implement as that requires
a reference to the cgroup to be maintained.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/vfio/vfio_iommu_type1.c | 60 +++++++++-------------------------
 1 file changed, 17 insertions(+), 43 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..a3957b8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/irqdomain.h>
+#include <linux/vm_account.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -95,11 +96,11 @@ struct vfio_dma {
 	size_t			size;		/* Map size (bytes) */
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
-	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	bool			vaddr_invalid;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct vm_account       vm_account;
 };
 
 struct vfio_batch {
@@ -412,31 +413,6 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
-static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (!npage)
-		return 0;
-
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
-		return -ESRCH; /* process exited */
-
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
-
-	if (async)
-		mmput(mm);
-
-	return ret;
-}
-
 /*
  * Some mappings aren't backed by a struct page, for example an mmap'd
  * MMIO range for our own or another device.  These use a different
@@ -715,16 +691,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
-					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
-						__func__, limit << PAGE_SHIFT);
-					ret = -ENOMEM;
-					goto unpin_out;
-				}
+			if (!rsvd && !vfio_find_vpfn(dma, iova))
 				lock_acct++;
-			}
 
 			pinned++;
 			npage--;
@@ -744,7 +712,11 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	}
 
 out:
-	ret = vfio_lock_acct(dma, lock_acct, false);
+	if (vm_account_pinned(&dma->vm_account, lock_acct)) {
+		ret = -ENOMEM;
+		lock_acct = 0;
+		pr_warn("%s: RLIMIT_MEMLOCK exceeded\n", __func__);
+	}
 
 unpin_out:
 	if (batch->size == 1 && !batch->offset) {
@@ -759,6 +731,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				put_pfn(pfn, dma->prot);
 		}
 		vfio_batch_unpin(batch, dma);
+		vm_unaccount_pinned(&dma->vm_account, lock_acct);
 
 		return ret;
 	}
@@ -782,7 +755,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	}
 
 	if (do_accounting)
-		vfio_lock_acct(dma, locked - unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, locked - unlocked);
 
 	return unlocked;
 }
@@ -805,7 +778,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vm_account_pinned(&dma->vm_account, 1);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -833,7 +806,7 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
 	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
 
 	if (do_accounting)
-		vfio_lock_acct(dma, -unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, unlocked);
 
 	return unlocked;
 }
@@ -921,7 +894,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
 		if (ret) {
 			if (put_pfn(phys_pfn, dma->prot) && do_accounting)
-				vfio_lock_acct(dma, -1, true);
+				vm_unaccount_pinned(&dma->vm_account, 1);
 			goto pin_unwind;
 		}
 
@@ -1162,7 +1135,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	}
 
 	if (do_accounting) {
-		vfio_lock_acct(dma, -unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, unlocked);
 		return 0;
 	}
 	return unlocked;
@@ -1674,7 +1647,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 */
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
-	dma->lock_cap = capable(CAP_IPC_LOCK);
+	vm_account_init(&dma->vm_account, dma->task, NULL, VM_ACCOUNT_TASK |
+		(capable(CAP_IPC_LOCK) ? VM_ACCOUNT_BYPASS : 0));
 
 	dma->pfn_list = RB_ROOT;
 
@@ -2398,7 +2372,7 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 			if (!is_invalid_reserved_pfn(vpfn->pfn))
 				locked++;
 		}
-		vfio_lock_acct(dma, locked - unlocked, true);
+		vm_unaccount_pinned(&dma->vm_account, locked - unlocked);
 	}
 }
 
-- 
git-series 0.9.1
