Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459981EC286
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 21:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFBTQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 15:16:01 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7505 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBTQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 15:16:01 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed6a51a0000>; Tue, 02 Jun 2020 12:14:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 02 Jun 2020 12:16:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 02 Jun 2020 12:16:01 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Jun
 2020 19:15:54 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Jun 2020 19:15:48 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>
Subject: [PATCH 2/2] vfio iommu: typecast corrections
Date:   Wed, 3 Jun 2020 00:12:37 +0530
Message-ID: <1591123357-18297-2-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1591123357-18297-1-git-send-email-kwankhede@nvidia.com>
References: <1591123357-18297-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591125274; bh=5Wj2K9vuNloUX1WzMLTNpeDsMst3FebRuyzK2zg0M7M=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=cBo7n2xs0y/XG43Pmp4cE0XDWwFN6CRR0/k2U0QvCqC2wiK0KeAwjcCQokSzPLZ9D
         AkJAtp0iaTQxQuJ9GPiQjcIQzxYz6bq7N9FmJ9fzgchpCNYBB2sxFkVmDtS6PboWx3
         tz8tgfiI3THfQoqwU+yLY6+oQm+3wlG6IwXsUaAf/VojEIDUhCpT0HBa3/RCTrlOMJ
         o2C7bfcnViThvxtrwAqfy8OR3w7JNn/8tTqlkeTpaNpXpyS4HNWBKVCNmyw5QmTZGE
         0faAGCCNt1IGuJzIbCvtx1IWHtOVeVDbX9yX16/8VREkYattFwQxN0Sk6oSS2gALAy
         12pHpWs2kZ7qQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes sparse warnings by adding '__user' in typecast for
copy_[from,to]_user()

Fixes: d6a4c185660c (vfio iommu: Implementation of ioctl for dirty pages tracking)

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9d9c8709a24c..5e556ac9102a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -998,14 +998,14 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 				  nbits + shift);
 
 		if (copy_from_user(&leftover,
-				   (const void *)(bitmap + copy_offset),
+				   (void __user *)(bitmap + copy_offset),
 				   sizeof(leftover)))
 			return -EFAULT;
 
 		bitmap_or(dma->bitmap, dma->bitmap, &leftover, shift);
 	}
 
-	if (copy_to_user((void *)(bitmap + copy_offset), dma->bitmap,
+	if (copy_to_user((void __user *)(bitmap + copy_offset), dma->bitmap,
 			 DIRTY_BITMAP_BYTES(nbits + shift)))
 		return -EFAULT;
 
-- 
2.7.0

