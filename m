Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B80F1375E2
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgAJSLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 13:11:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:47030 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgAJSLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 13:11:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 10:11:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="224266365"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2020 10:11:35 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ipykw-0008ri-F3; Sat, 11 Jan 2020 02:11:34 +0800
Date:   Sat, 11 Jan 2020 02:10:52 +0800
From:   kbuild test robot <lkp@intel.com>
To:     weiqi <weiqi4@huawei.com>
Cc:     kbuild-all@lists.01.org, alexander.h.duyck@linux.intel.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        wei qi <weiqi4@huawei.com>
Subject: [RFC PATCH] vfio: vfio_iommu_iova_to_phys() can be static
Message-ID: <20200110181052.4k2zckkmebgtt64w@f53c9c00458a>
References: <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: 3b764b3397df ("vfio: add mmap/munmap API for page hinting")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 vfio_iommu_type1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3939f9573f74f..f25c107e2c709 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1272,7 +1272,7 @@ static int vfio_iommu_type1_mmap_pages(void *iommu_data,
 	return ret;
 }
 
-u64 vfio_iommu_iova_to_phys(struct vfio_iommu *iommu, dma_addr_t iova)
+static u64 vfio_iommu_iova_to_phys(struct vfio_iommu *iommu, dma_addr_t iova)
 {
 	struct vfio_domain *d;
 	u64 phys;
