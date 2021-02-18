Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D931E447
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 03:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBRCSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 21:18:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12181 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhBRCSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 21:18:49 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DgyxK6hxYzlLgj;
        Thu, 18 Feb 2021 10:16:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Feb 2021 10:17:58 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>
Subject: [PATCH] vfio/iommu_type1: Fix duplicate included kthread.h
Date:   Thu, 18 Feb 2021 10:17:29 +0800
Message-ID: <1613614649-59501-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linux/kthread.h is included more than once, remove the one that isn't
necessary.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/vfio/vfio_iommu_type1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ec9fd95..b3df383 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -31,7 +31,6 @@
 #include <linux/rbtree.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
-#include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
-- 
2.7.4

