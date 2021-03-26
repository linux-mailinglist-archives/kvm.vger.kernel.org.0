Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9C134A33C
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCZIhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:37:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14617 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhCZIhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 04:37:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6Fdy0cS4z19JkX;
        Fri, 26 Mar 2021 16:35:02 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 16:36:53 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/4] vfio/type1: fix a couple of spelling mistakes
Date:   Fri, 26 Mar 2021 16:35:25 +0800
Message-ID: <20210326083528.1329-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210326083528.1329-1-thunder.leizhen@huawei.com>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are several spelling mistakes, as follows:
userpsace ==> userspace
Accouting ==> Accounting
exlude ==> exclude

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index be444407664af74..21cf1d123036c82 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -16,7 +16,7 @@
  * IOMMU to support the IOMMU API and have few to no restrictions around
  * the IOVA range that can be mapped.  The Type1 IOMMU is currently
  * optimized for relatively static mappings of a userspace process with
- * userpsace pages pinned into memory.  We also assume devices and IOMMU
+ * userspace pages pinned into memory.  We also assume devices and IOMMU
  * domains are PCI based as the IOMMU API is still centered around a
  * device/bus interface rather than a group interface.
  */
@@ -871,7 +871,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 	/*
 	 * If iommu capable domain exist in the container then all pages are
-	 * already pinned and accounted. Accouting should be done if there is no
+	 * already pinned and accounted. Accounting should be done if there is no
 	 * iommu capable domain in the container.
 	 */
 	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
@@ -2171,7 +2171,7 @@ static int vfio_iommu_resv_exclude(struct list_head *iova,
 				continue;
 			/*
 			 * Insert a new node if current node overlaps with the
-			 * reserve region to exlude that from valid iova range.
+			 * reserve region to exclude that from valid iova range.
 			 * Note that, new node is inserted before the current
 			 * node and finally the current node is deleted keeping
 			 * the list updated and sorted.
-- 
1.8.3


