Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4C10D09D
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 04:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfK2DT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 22:19:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6729 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726764AbfK2DT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 22:19:57 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09800991634F43F95A93;
        Fri, 29 Nov 2019 11:19:54 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 29 Nov 2019
 11:19:45 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <maz@kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <christoffer.dall@arm.com>,
        <catalin.marinas@arm.com>, <eric.auger@redhat.com>,
        <gregkh@linuxfoundation.org>, <will@kernel.org>,
        <andre.przywara@arm.com>, <tglx@linutronix.de>
CC:     <linmiaohe@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH] KVM: arm/arm64: Fix some obsolete comments
Date:   Fri, 29 Nov 2019 11:19:47 +0800
Message-ID: <1574997587-20842-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix various comments, including comment typo, and obsolete comments
no longer make sense.
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/arm/arch_timer.c    | 5 ++---
 virt/kvm/arm/arm.c           | 1 -
 virt/kvm/arm/vgic/vgic-its.c | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 73867f97040c..d8d2f4bec935 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -322,9 +322,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 	}
 
 	/*
-	 * If the timer can fire now, we don't need to have a soft timer
-	 * scheduled for the future.  If the timer cannot fire at all,
-	 * then we also don't need a soft timer.
+	 * If the timer cannot fire at all, we don't need to have a
+	 * soft timer scheduled for the future.
 	 */
 	if (!kvm_timer_irq_can_fire(ctx)) {
 		soft_timer_cancel(&ctx->hrtimer);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 8de4daf25097..7687663ab71b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -525,7 +525,6 @@ static bool need_new_vmid_gen(struct kvm_vmid *vmid)
 
 /**
  * update_vmid - Update the vmid with a valid VMID for the current generation
- * @kvm: The guest that struct vmid belongs to
  * @vmid: The stage-2 VMID information struct
  */
 static void update_vmid(struct kvm_vmid *vmid)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 98c7360d9fb7..d64569b30b5c 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2564,7 +2564,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 }
 
 /**
- * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
+ * vgic_its_save_tables_v0 - Save the ITS tables into guest RAM
  * according to v0 ABI
  */
 static int vgic_its_save_tables_v0(struct vgic_its *its)
-- 
2.19.1

