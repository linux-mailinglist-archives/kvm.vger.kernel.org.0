Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B11247871
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 23:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgHQVBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 17:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHQVA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 17:00:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E31BC061342
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 14:00:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m34so8685020pgl.11
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tcd-ie.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3b17tpQsxeSrpEJMNS65bCpVzCghTE72IhZ2F4sGm8=;
        b=X1ehmlg/aGEGwU8TlqB+7kJoeA7pGAjwOZUvoxZgjsb9cYUBO53eVjUbxfMC95XFPL
         Q8KTcz9XTCWFgfS2tP8/KtjBKQPS068kT06iwABH7hw+JoPmc92WjyUnCMMIOG3y3dVW
         8Q/jbqfphqosT0z/JKfeFL8aItaLAym4bVWP7q0TSCm4m0ToVhuJ35Ap7r2ZPap6h069
         bBTcdGkCwAwiKRLgIDJ19J8Tm4ve5mEQYQSNx8/ncgRMWb+p/t2HqFZdgrG5YRevMlXg
         JWZl6E+oOmLw2z+QC7yOGH/x/ODm219KdBiBikoMblD5i0+ahzg7NSv3BQ7zeySsdG5t
         oYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3b17tpQsxeSrpEJMNS65bCpVzCghTE72IhZ2F4sGm8=;
        b=K7g054qM2Zlr6M3qylGZSosLRDXUe28ZNBR9uTg8ca+dDPazj3Dn6XCYcYJ98G87Rm
         /KcFtBSwEE6wOD3nOVcMRFQNdz1qIfFl82DcdL/cfH3x1smZMNtJFALc13XNSLHUIGAT
         T9VWttx2hiUw6gTRQpL8kua7rNne5SoKMOoxL08+c9C5HjYz7NwhNUaniaweGPTxgfA4
         SpAl3wjGEC+4I9pMZRZ6tAe+FvnnhVV6Y4TNZ+A02190jWBTUgEz3LG8YIQ494xEWZyt
         uX1jCZNmJz2EteQVV4UmRhbKBe/Ex9y4968GLpESNwZEJBJwovC/mQW16p5lQnbE/t0Z
         jaJQ==
X-Gm-Message-State: AOAM531wd8yfS1UEugi8v9Fq9IQ++Cqm7sA940zzgVUR+SKluFZEYC/O
        mAQ3jvv4bp/4ejDuOMncaep9dQ==
X-Google-Smtp-Source: ABdhPJxZlziJHTCHPvQS4XhFGDrR51ylltOsuD3KwPoc2QE6wRzaZSRbXWvH7K1WQcYlUvdGvfnT7w==
X-Received: by 2002:aa7:9468:: with SMTP id t8mr12312380pfq.182.1597698056896;
        Mon, 17 Aug 2020 14:00:56 -0700 (PDT)
Received: from localhost.localdomain (S0106ac17c8c0ce82.vc.shawcable.net. [24.87.214.6])
        by smtp.googlemail.com with ESMTPSA id b20sm21158263pfo.88.2020.08.17.14.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 14:00:56 -0700 (PDT)
From:   Tom Murphy <murphyt7@tcd.ie>
To:     iommu@lists.linux-foundation.org
Cc:     person@a.com, Tom Murphy <murphyt7@tcd.ie>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Yong Wu <yong.wu@mediatek.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Rename iommu_tlb_* functions to iommu_iotlb_*
Date:   Mon, 17 Aug 2020 22:00:49 +0100
Message-Id: <20200817210051.13546-1-murphyt7@tcd.ie>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To keep naming consistent we should stick with *iotlb*. This patch
renames a few remaining functions.

Signed-off-by: Tom Murphy <murphyt7@tcd.ie>
---
 drivers/iommu/dma-iommu.c       |  2 +-
 drivers/iommu/iommu.c           |  4 ++--
 drivers/vfio/vfio_iommu_type1.c |  2 +-
 include/linux/io-pgtable.h      |  2 +-
 include/linux/iommu.h           | 10 +++++-----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 79e6d8d799a3..59adb1a0aefc 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -503,7 +503,7 @@ static void __iommu_dma_unmap(struct device *dev, dma_addr_t dma_addr,
 			domain->ops->flush_iotlb_range(domain, dma_addr, size,
 					freelist);
 		else
-			iommu_tlb_sync(domain, &iotlb_gather);
+			iommu_iotlb_sync(domain, &iotlb_gather);
 	}
 
 	iommu_dma_free_iova(cookie, dma_addr, size, freelist);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9065127d7e9c..70a85f41876f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -762,7 +762,7 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 
 	}
 
-	iommu_flush_tlb_all(domain);
+	iommu_flush_iotlb_all(domain);
 
 out:
 	iommu_put_resv_regions(dev, &mappings);
@@ -2317,7 +2317,7 @@ size_t iommu_unmap(struct iommu_domain *domain,
 	if (ops->flush_iotlb_range)
 		ops->flush_iotlb_range(domain, iova, ret, freelist);
 	else
-		iommu_tlb_sync(domain, &iotlb_gather);
+		iommu_iotlb_sync(domain, &iotlb_gather);
 
 	return ret;
 }
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 570ebf878fea..d550ceb7b2aa 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -774,7 +774,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
 	long unlocked = 0;
 	struct vfio_regions *entry, *next;
 
-	iommu_tlb_sync(domain->domain, iotlb_gather);
+	iommu_iotlb_sync(domain->domain, iotlb_gather);
 
 	list_for_each_entry_safe(entry, next, regions, list) {
 		unlocked += vfio_unpin_pages_remote(dma,
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 53d53c6c2be9..d3f2bd4a3ac4 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -31,7 +31,7 @@ enum io_pgtable_fmt {
  *                  single page.  IOMMUs that cannot batch TLB invalidation
  *                  operations efficiently will typically issue them here, but
  *                  others may decide to update the iommu_iotlb_gather structure
- *                  and defer the invalidation until iommu_tlb_sync() instead.
+ *                  and defer the invalidation until iommu_iotlb_sync() instead.
  *
  * Note that these can all be called in atomic context and must therefore
  * not block.
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 77e773d03f22..7b363f24bf99 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -542,7 +542,7 @@ extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr)
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
 
-static inline void iommu_flush_tlb_all(struct iommu_domain *domain)
+static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	if (domain->ops->flush_iotlb_all)
 		domain->ops->flush_iotlb_all(domain);
@@ -556,7 +556,7 @@ static inline void flush_iotlb_range(struct iommu_domain *domain,
 		domain->ops->flush_iotlb_range(domain, iova, size, freelist);
 }
 
-static inline void iommu_tlb_sync(struct iommu_domain *domain,
+static inline void iommu_iotlb_sync(struct iommu_domain *domain,
 				  struct iommu_iotlb_gather *iotlb_gather)
 {
 	if (domain->ops->iotlb_sync)
@@ -579,7 +579,7 @@ static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
 	if (gather->pgsize != size ||
 	    end < gather->start || start > gather->end) {
 		if (gather->pgsize)
-			iommu_tlb_sync(domain, gather);
+			iommu_iotlb_sync(domain, gather);
 		gather->pgsize = size;
 	}
 
@@ -762,11 +762,11 @@ static inline size_t iommu_map_sg_atomic(struct iommu_domain *domain,
 	return 0;
 }
 
-static inline void iommu_flush_tlb_all(struct iommu_domain *domain)
+static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
 {
 }
 
-static inline void iommu_tlb_sync(struct iommu_domain *domain,
+static inline void iommu_iotlb_sync(struct iommu_domain *domain,
 				  struct iommu_iotlb_gather *iotlb_gather)
 {
 }
-- 
2.20.1

