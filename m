Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF15F1A1C80
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 09:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgDHHWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 03:22:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:27549 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDHHWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 03:22:20 -0400
IronPort-SDR: H9c326LfmrsaQTligFC2SotXFt32A0INV7w8DU2VynfiKmn4yK5d8eEWHvNHRNoKi68/PY7S3c
 3cg0LJPNDrNg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 00:22:19 -0700
IronPort-SDR: gKnX5qseXmV3WmfIxHpupqPyGRM0UIDAt4K/RoSyYkt0udANyhV+gjvDAzcwGW9P0zbDktqEwH
 fQFaN9wLCMHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="398121373"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 08 Apr 2020 00:22:17 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio: avoid possible overflow in vfio_iommu_type1_pin_pages
Date:   Wed,  8 Apr 2020 03:12:34 -0400
Message-Id: <20200408071234.25702-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

add parentheses to avoid possible vaddr overflow.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 85b32c325282..3aefcc8e2933 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -555,7 +555,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			continue;
 		}
 
-		remote_vaddr = dma->vaddr + iova - dma->iova;
+		remote_vaddr = dma->vaddr + (iova - dma->iova);
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
 		if (ret)
-- 
2.17.1

