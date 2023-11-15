Return-Path: <kvm+bounces-1707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DAB7EBB0E
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 03:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C34C81F24F87
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 02:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459ABA55;
	Wed, 15 Nov 2023 02:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgdDq2c5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53DE642
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 02:02:55 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4F1D6;
	Tue, 14 Nov 2023 18:02:54 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5bd85b1939aso3981040a12.2;
        Tue, 14 Nov 2023 18:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700013774; x=1700618574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Id6MwfiB5Pv0ZXowasXpEYmbdbnPyV9LKqTkNMYOdRU=;
        b=VgdDq2c51h8dbXgW6V4bJ2/jbGECKr/vC8GuqkzTZX8RM9SYxclFSCG4vh7mGz+UH6
         ErMlldhsQcmfzL/XvN3RPr6s2aQa6ETZU8lss5qWTLUjnKeTLaP65TFjiKzRuDeEYB9o
         YbuA1taMdK4PrQzEekaV0pM/9pN5Wc3u8TQS7SknRBiFQ9YyJGHpqf9b6Ppb/pMoiAq5
         vLT960iK7IW+28GLD8l3vSJVtTTny2iKHJduGP6CkhSEDdsIMpnnIWmAc84mUNJHDEXs
         XYEbBfYUDMYxNQezSInO2WWHYaY/lhpcnx7JRx2/gCqmSwkHDp2nMZ6lhhm0ZzBbcEpH
         QvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700013774; x=1700618574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Id6MwfiB5Pv0ZXowasXpEYmbdbnPyV9LKqTkNMYOdRU=;
        b=rL2J5eheCfREnAM1qy2tue/OvCxsUMAz3dLAfP1LjEIZqzpD8mYFFx8ATMmQYj7B+I
         zlEw0kS0LD5sBVws3o0piTKqvrb8U+NdTD2hYBvvFQzKQhQEiJoANiPb8RksWz/XcllO
         o2FsNa4B3v36CLQ3kwOGLjN5az7gSrHV6A4xDXtsQFwJE1iPt2vizRG1/dVwSkXKqLWa
         V4qF1JJE1RocqwX6pS1L7coqyyV6U8+0D3YQsX1BRJmPiOvGeB2mEGK6Or8WFtafWWnY
         J8FYTTiROICoCPIs7YQWQP0WuglmcUGLDUFqIBmH74XrTIH6xw8h/H3sn9VYp2JF1+5q
         IXlA==
X-Gm-Message-State: AOJu0Yyln2UA2aEc6tRbhlXKbYsIOYHbv4X+qhxp6tjVKPKGsdSekM67
	Id7JItjq5VQy8QQu/2/r+c271d+ypdQ=
X-Google-Smtp-Source: AGHT+IECqFiO91Ny+OyS59YpVdL1lmTnIs1B2YgfSXtT4EjIvM1numDH3Yb/LVXNQ6gNzbxcSMNmww==
X-Received: by 2002:a17:90b:3886:b0:27d:3ecb:3cbb with SMTP id mu6-20020a17090b388600b0027d3ecb3cbbmr9591264pjb.37.1700013773692;
        Tue, 14 Nov 2023 18:02:53 -0800 (PST)
Received: from localhost.localdomain ([129.227.63.229])
        by smtp.gmail.com with ESMTPSA id z5-20020a1709027e8500b001b8622c1ad2sm6487842pla.130.2023.11.14.18.02.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Nov 2023 18:02:53 -0800 (PST)
From: yaozhenguo <yaozhenguo1@gmail.com>
X-Google-Original-From: yaozhenguo <yaozhenguo@jd.com>
To: yaozhenguo@jd.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	alex.williamson@redhat.com
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Zhenguo Yao <yaozhenguo1@gmail.com>,
	Wenchao Yao <yaowenchao@jd.com>,
	ZiHan Zhou <zhouzihan30@jd.com>
Subject: [PATCH V1] vfio: add attach_group_by_node to control behavior of attaching group to domain
Date: Wed, 15 Nov 2023 10:02:09 +0800
Message-Id: <20231115020209.4665-1-yaozhenguo@jd.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhenguo Yao <yaozhenguo1@gmail.com>

Groups will attach to one iommu_domain if ops and enforce_cache_coherency
are equal. And all the iommu hardware share one pagetable by default.
There are performance issue in some scenarios. For example:
Host hardware topopy:

node0 + PCIe RP0 ---+ GPU A100
      |         |---+ GPU A100
      |	        |---+ NIC Mellanox CX6
      |	        |---+ NIC Mellanox CX6
      + PCIe RP1 ---+ GPU A100
                |---+ GPU A100
      	        |---+ NIC Mellanox CX6
                |---+ NIC Mellanox CX6
node1 + PCIe RP0 ---+ GPU A100
      |         |---+ GPU A100
      |	        |---+ NIC Mellanox CX6
      |	        |---+ NIC Mellanox CX6
      + PCIe RP1 ---+ GPU A100
                |---+ GPU A100
      	        |---+ NIC Mellanox CX6
                |---+ NIC Mellanox CX6

We passthrough all NICs and GPU to VM, and emulate host hardware topopy.
Mellanox CX6 ATS feature is enabled, GPU direct RDMA enabled.
We test NCCL allreduce in VM at different cases.

Case1: allreduce test use 4nic and 4GPU in numa0.
Case2：allreduce test use 4nic and 4GPU in numa1.
case3: allreduce test use 8nic and 8GPU.

the result are below:

|        | algbw (GB/S) |
| ------ | -------------|
| case1  | 24           |
| case2  | 32           |
| case3  | 45           |

We checked that IOMMU pagetable is allocated in numa1 when VM boot up.
So, if IOTLB miss happan, IOMMU hardware in numa0 will access remote
pagetable in numa1. This will drop performance. After apply this patch and
attach_group_by_node is 1. Group in same node will attach to one domain.
IOMMU will access there local pagetable. Performance is improved:

|        | algbw (GB/S) |
| ------ | -------------|
| case1  | 32           |
| case2  | 32           |
| case3  | 63           |

Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
Co-developed-by: Wenchao Yao <yaowenchao@jd.com>
Signed-off-by: Wenchao Yao <yaowenchao@jd.com>
Co-developed-by: ZiHan Zhou <zhouzihan30@jd.com>
Signed-off-by: ZiHan Zhou <zhouzihan30@jd.com>
---
 drivers/iommu/intel/iommu.c     |  8 +++++++-
 drivers/vfio/vfio_iommu_type1.c | 33 +++++++++++++++++++++------------
 include/linux/iommu.h           |  1 +
 3 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3531b95..2c6d8f0 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -569,8 +569,10 @@ void domain_update_iommu_cap(struct dmar_domain *domain)
 	 * If RHSA is missing, we should default to the device numa domain
 	 * as fall back.
 	 */
-	if (domain->nid == NUMA_NO_NODE)
+	if (domain->nid == NUMA_NO_NODE) {
 		domain->nid = domain_update_device_node(domain);
+		domain->domain.nid = domain->nid;
+	}
 
 	/*
 	 * First-level translation restricts the input-address to a
@@ -1767,6 +1769,7 @@ static struct dmar_domain *alloc_domain(unsigned int type)
 		return NULL;
 
 	domain->nid = NUMA_NO_NODE;
+	domain->domain.nid = NUMA_NO_NODE;
 	if (first_level_by_default(type))
 		domain->use_first_level = true;
 	domain->has_iotlb_device = false;
@@ -1808,6 +1811,8 @@ int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	info->refcnt	= 1;
 	info->did	= num;
 	info->iommu	= iommu;
+	domain->nid     = iommu->node;
+	domain->domain.nid     = iommu->node;
 	curr = xa_cmpxchg(&domain->iommu_array, iommu->seq_id,
 			  NULL, info, GFP_ATOMIC);
 	if (curr) {
@@ -1837,6 +1842,7 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 		clear_bit(info->did, iommu->domain_ids);
 		xa_erase(&domain->iommu_array, iommu->seq_id);
 		domain->nid = NUMA_NO_NODE;
+		domain->domain.nid = NUMA_NO_NODE;
 		domain_update_iommu_cap(domain);
 		kfree(info);
 	}
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index eacd6ec..6a5641e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -59,6 +59,11 @@
 module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
 MODULE_PARM_DESC(dma_entry_limit,
 		 "Maximum number of user DMA mappings per container (65535).");
+static uint attach_group_by_node;
+module_param_named(attach_group_by_node,
+		attach_group_by_node, uint, 0644);
+MODULE_PARM_DESC(attach_group_by_node,
+		 "Attach group to domain when it's in same node");
 
 struct vfio_iommu {
 	struct list_head	domain_list;
@@ -2287,19 +2292,23 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		if (d->domain->ops == domain->domain->ops &&
 		    d->enforce_cache_coherency ==
 			    domain->enforce_cache_coherency) {
-			iommu_detach_group(domain->domain, group->iommu_group);
-			if (!iommu_attach_group(d->domain,
-						group->iommu_group)) {
-				list_add(&group->next, &d->group_list);
-				iommu_domain_free(domain->domain);
-				kfree(domain);
-				goto done;
-			}
+			if ((attach_group_by_node == 1 &&
+				d->domain->nid == domain->domain->nid) ||
+				attach_group_by_node == 0) {
+				iommu_detach_group(domain->domain, group->iommu_group);
+				if (!iommu_attach_group(d->domain,
+							group->iommu_group)) {
+					list_add(&group->next, &d->group_list);
+					iommu_domain_free(domain->domain);
+					kfree(domain);
+					goto done;
+				}
 
-			ret = iommu_attach_group(domain->domain,
-						 group->iommu_group);
-			if (ret)
-				goto out_domain;
+				ret = iommu_attach_group(domain->domain,
+						group->iommu_group);
+				if (ret)
+					goto out_domain;
+			}
 		}
 	}
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ec289c1..c1330ed 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -123,6 +123,7 @@ struct iommu_domain {
 			int users;
 		};
 	};
+	int nid;
 };
 
 static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
-- 
1.8.3.1


