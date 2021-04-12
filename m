Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074C335B8BC
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 04:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhDLCoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 22:44:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16891 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbhDLCox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Apr 2021 22:44:53 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FJY1b2zRtzlWjc;
        Mon, 12 Apr 2021 10:42:43 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 12 Apr 2021 10:44:25 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [PATCH] vfio/iommu_type1: Remove unused pinned_page_dirty_scope in vfio_iommu
Date:   Mon, 12 Apr 2021 10:44:15 +0800
Message-ID: <20210412024415.30676-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pinned_page_dirty_scope is optimized out by commit 010321565a7d
("vfio/iommu_type1: Mantain a counter for non_pinned_groups"),
but appears again due to some issues during merging branches.
We can safely remove it here.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---

However, I'm not clear about the root problem. Is there a bug in git?

---
 drivers/vfio/vfio_iommu_type1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 45cbfd4879a5..4d1f10a33d74 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -77,7 +77,6 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			pinned_page_dirty_scope;
 	bool			container_open;
 };
 
-- 
2.19.1

