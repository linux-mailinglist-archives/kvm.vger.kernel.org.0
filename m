Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED03158B5F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 09:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgBKIkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 03:40:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52208 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727653AbgBKIkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 03:40:43 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8259A53757EA3401812D;
        Tue, 11 Feb 2020 16:40:40 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 16:40:33 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <alexandru.elisei@arm.com>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [kvm-unit-tests PATCH 1/3] arm/arm64: gic: Move gic_state enumeration to asm/gic.h
Date:   Tue, 11 Feb 2020 16:38:59 +0800
Message-ID: <20200211083901.1478-2-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200211083901.1478-1-yuzenghui@huawei.com>
References: <20200211083901.1478-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The status of each interrupt are defined by the GIC architecture and
maintained by GIC hardware.  They're not specified to the timer HW.
Let's move this software enumeration to a more proper place.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arm/timer.c       | 7 -------
 lib/arm/asm/gic.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index dea364f..94543f2 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,13 +17,6 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
-enum gic_state {
-	GIC_STATE_INACTIVE,
-	GIC_STATE_PENDING,
-	GIC_STATE_ACTIVE,
-	GIC_STATE_ACTIVE_PENDING,
-};
-
 static void *gic_isactiver;
 static void *gic_ispendr;
 static void *gic_isenabler;
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 09826fd..a72e0cd 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -47,6 +47,13 @@
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
 
+enum gic_state {
+	GIC_STATE_INACTIVE,
+	GIC_STATE_PENDING,
+	GIC_STATE_ACTIVE,
+	GIC_STATE_ACTIVE_PENDING,
+};
+
 /*
  * gic_init will try to find all known gics, and then
  * initialize the gic data for the one found.
-- 
2.19.1


